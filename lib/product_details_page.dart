import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'artisan_profile_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProductDetailsPage
//
// Receives a product Map from the dashboard. When real API data arrives,
// swap the Map for a typed Product model — the UI doesn't need to change.
//
// Sections:
//   • Image carousel (dots indicator)
//   • Title, price, rating
//   • Artisan shortcut card  → taps to ArtisanProfilePage
//   • Category chips
//   • Description
//   • Offer type badge  (ready-made / custom / hire)
//   • Quantity selector  (for ready-made)
//   • Delivery info row
//   • Sticky bottom bar  (Add to Cart + Buy Now)
// ─────────────────────────────────────────────────────────────────────────────

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isArabic;
  final bool isDarkMode;
  final bool isGuest;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.isArabic,
    required this.isDarkMode,
    this.isGuest = false,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late bool isArabic;
  late bool isDarkMode;

  int _carouselIndex = 0;
  int _quantity = 1;
  bool _inWishlist = false;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    isArabic  = widget.isArabic;
    isDarkMode = widget.isDarkMode;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _gold  = Color(0xFFD4A017);
  static const Color _navy  = Color(0xFF0D1B33);

  Color get bg      => isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text    => isDarkMode ? Colors.white : Colors.black87;
  Color get dim     => isDarkMode ? Colors.white60 : Colors.black45;
  Color get border  => isDarkMode ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.07);
  Color get accent  => isDarkMode ? _gold : _navy;
  Color get imgBg   => isDarkMode ? const Color(0xFF1C2431) : const Color(0xFFEEEEF2);

  String t(String ar, String en) => isArabic ? ar : en;

  void _showGuestPrompt() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: widget.isDarkMode ? Colors.white12 : Colors.black12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4A017).withOpacity(0.15),
                ),
                child: const Icon(Icons.lock_outline, color: Color(0xFFD4A017), size: 30),
              ),
              const SizedBox(height: 20),
              Text(
                widget.isArabic ? "ميزة للأعضاء فقط" : "Members Only Feature",
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isArabic
                    ? "يرجى تسجيل الدخول لاستخدام هذه الميزة والاستمتاع بجميع خدماتنا."
                    : "Please log in to use this feature and enjoy all our services.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A017),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    widget.isArabic ? "حسناً، فهمت" : "Got it",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ── Mock image slots (replace with product["images"] list later) ──────────
  // Using the product icon repeated across 3 "slides" as a placeholder.
  List<String?> get _images => [null, null, null];

  // ── Mock artisan attached to this product ─────────────────────────────────
  Map<String, dynamic> get _artisan => {
    "nameAr": "فاطمة محمود",
    "nameEn": "Fatima Mahmoud",
    "craftAr": "خياطة وتطريز",
    "craftEn": "Crochet & Knitting",
    "rating": "4.8",
    "jobs": "74",
    "image": "assets/images/crochet.jpg",
  };

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final name  = t(p["nameAr"] ?? '', p["nameEn"] ?? '');
    final price = (p["price"] as num?)?.toDouble() ?? 0.0;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,

        // ── Sticky bottom bar ──────────────────────────────────────────────
        bottomNavigationBar: _BottomBar(
          accent: accent,
          text: text,
          surface: surface,
          border: border,
          isArabic: isArabic,
          price: price,
          quantity: _quantity,
          onAddToCart: widget.isGuest ? _showGuestPrompt : () => _showSnack(t('أُضيف إلى السلة', 'Added to cart')),
          onBuyNow: widget.isGuest ? _showGuestPrompt : () => _showSnack(t('جارٍ التوجه للدفع...', 'Going to checkout...')),
        ),

        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── SliverAppBar with image carousel ────────────────────────
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: surface,
              leading: _CircleBtn(
                icon: isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                onTap: () => Navigator.pop(context),
                bg: surface,
                iconColor: text,
                border: border,
              ),
              actions: [
                _CircleBtn(
                  icon: _inWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  onTap: widget.isGuest 
                      ? _showGuestPrompt 
                      : () => setState(() => _inWishlist = !_inWishlist),
                  bg: surface,
                  iconColor: _inWishlist ? Colors.redAccent : text,
                  border: border,
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Image PageView
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (i) => setState(() => _carouselIndex = i),
                      itemBuilder: (_, i) => Container(
                        color: imgBg,
                        child: Center(
                          child: Icon(
                            p["icon"] as IconData? ?? Icons.inventory_2_outlined,
                            size: 100,
                            color: accent.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    // Dots indicator
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _carouselIndex ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _carouselIndex ? accent : accent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body content ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Title + rating row ──────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(name,
                              style: GoogleFonts.arefRuqaa(
                                  color: text, fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('${price.toStringAsFixed(0)} JOD',
                              style: TextStyle(color: accent, fontSize: 20, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF7B500), size: 15),
                            const SizedBox(width: 3),
                            Text(p["rating"] ?? '—',
                                style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w600)),
                          ]),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // ── Offer type badge ────────────────────────────────
                    _OfferBadge(type: 'ready_made', isArabic: isArabic, accent: accent),

                    const SizedBox(height: 18),

                    // ── Artisan shortcut ────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ArtisanProfilePage(
                          artisan: _artisan,
                          isArabic: isArabic,
                          isDarkMode: isDarkMode,
                        ),
                      )),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: border),
                        ),
                        child: Row(children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: accent.withOpacity(0.2),
                            child: Text('ف', style: TextStyle(color: accent, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t(_artisan["nameAr"], _artisan["nameEn"]),
                                style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(t(_artisan["craftAr"], _artisan["craftEn"]),
                                style: TextStyle(color: accent, fontSize: 12)),
                          ])),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF7B500), size: 13),
                            const SizedBox(width: 3),
                            Text(_artisan["rating"], style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right_rounded, color: dim, size: 18),
                        ]),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Category chips ──────────────────────────────────
                    Text(t('الفئة', 'Category'),
                        style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _Chip(label: t('تطريز', 'Embroidery'), accent: accent, surface: surface, border: border, text: text),
                      _Chip(label: t('مستلزمات المنزل', 'Home Décor'), accent: accent, surface: surface, border: border, text: text),
                    ]),

                    const SizedBox(height: 20),

                    // ── Description ─────────────────────────────────────
                    Text(t('الوصف', 'Description'),
                        style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      t(
                        'قطعة يدوية فريدة مصنوعة بعناية فائقة من قِبَل حرفيين محليين موثوقين. تجمع بين الأصالة والجمال وتُعبّر عن الهوية الثقافية الفلسطينية الأصيلة. مثالية كهدية أو للاستخدام اليومي.',
                        'A unique handmade piece crafted with exceptional care by trusted local artisans. It blends authenticity and beauty, reflecting genuine Palestinian cultural identity. Perfect as a gift or for everyday use.',
                      ),
                      style: TextStyle(color: dim, fontSize: 13.5, height: 1.65),
                    ),

                    const SizedBox(height: 20),

                    // ── Delivery info ───────────────────────────────────
                    Text(t('معلومات التوصيل', 'Delivery Info'),
                        style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Column(children: [
                        _InfoRow(icon: Icons.local_shipping_outlined, label: t('وقت التوصيل', 'Delivery Time'), value: t('٣–٥ أيام عمل', '3–5 business days'), text: text, dim: dim, accent: accent),
                        Divider(height: 18, color: border),
                        _InfoRow(icon: Icons.shield_outlined, label: t('ضمان الدفع', 'Payment Guarantee'), value: t('محمي بنظام الضمان', 'Protected by escrow'), text: text, dim: dim, accent: accent),
                        Divider(height: 18, color: border),
                        _InfoRow(icon: Icons.location_on_outlined, label: t('الشحن من', 'Ships from'), value: t('نابلس، فلسطين', 'Nablus, Palestine'), text: text, dim: dim, accent: accent),
                      ]),
                    ),

                    const SizedBox(height: 20),

                    // ── Quantity selector ───────────────────────────────
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(t('الكمية', 'Quantity'),
                          style: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w700)),
                      _QuantitySelector(
                        value: _quantity,
                        accent: accent,
                        surface: surface,
                        border: border,
                        text: text,
                        onChanged: (v) => setState(() => _quantity = v),
                      ),
                    ]),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: accent, behavior: SnackBarBehavior.floating),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  final Color bg, iconColor, border;
  const _CircleBtn({required this.icon, required this.onTap, required this.bg, required this.iconColor, required this.border});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(20),
      child: Container(width: 36, height: 36,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: Border.all(color: border)),
          child: Icon(icon, size: 16, color: iconColor)),
    ),
  );
}

class _OfferBadge extends StatelessWidget {
  final String type; final bool isArabic; final Color accent;
  const _OfferBadge({required this.type, required this.isArabic, required this.accent});
  @override
  Widget build(BuildContext context) {
    final labels = {
      'ready_made': isArabic ? '✓ متاح للشراء الفوري' : '✓ Ready to ship',
      'custom':     isArabic ? '✏️ طلب مخصص' : '✏️ Custom order',
      'hire':       isArabic ? '📍 خدمة في الموقع' : '📍 On-site service',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Text(labels[type] ?? '', style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final Color accent, surface, border, text;
  const _Chip({required this.label, required this.accent, required this.surface, required this.border, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: border)),
    child: Text(label, style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label, value; final Color text, dim, accent;
  const _InfoRow({required this.icon, required this.label, required this.value, required this.text, required this.dim, required this.accent});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 18, color: accent),
    const SizedBox(width: 10),
    Expanded(child: Text(label, style: TextStyle(color: dim, fontSize: 13))),
    Text(value, style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w600)),
  ]);
}

class _QuantitySelector extends StatelessWidget {
  final int value; final Color accent, surface, border, text;
  final ValueChanged<int> onChanged;
  const _QuantitySelector({required this.value, required this.accent, required this.surface, required this.border, required this.text, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      _QBtn(icon: Icons.remove, onTap: () { if (value > 1) onChanged(value - 1); }, accent: accent),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('$value', style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      _QBtn(icon: Icons.add, onTap: () => onChanged(value + 1), accent: accent),
    ]),
  );
}

class _QBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap; final Color accent;
  const _QBtn({required this.icon, required this.onTap, required this.accent});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(12),
    child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon, size: 18, color: accent)),
  );
}

class _BottomBar extends StatelessWidget {
  final Color accent, text, surface, border;
  final bool isArabic; final double price; final int quantity;
  final VoidCallback onAddToCart, onBuyNow;
  const _BottomBar({required this.accent, required this.text, required this.surface, required this.border, required this.isArabic, required this.price, required this.quantity, required this.onAddToCart, required this.onBuyNow});

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
    decoration: BoxDecoration(color: surface, border: Border(top: BorderSide(color: border))),
    child: Row(children: [
      // Add to Cart
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onAddToCart,
          icon: Icon(Icons.shopping_cart_outlined, size: 18, color: accent),
          label: Text(t('أضف للسلة', 'Add to Cart'), style: TextStyle(color: accent, fontWeight: FontWeight.w700)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: accent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      // Buy Now
      Expanded(
        child: ElevatedButton(
          onPressed: onBuyNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            '${t('شراء', 'Buy')}  •  ${(price * quantity).toStringAsFixed(0)} JOD',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ),
      ),
    ]),
  );
}
