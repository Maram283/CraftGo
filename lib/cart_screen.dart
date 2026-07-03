import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_confirmation_screen.dart';
import 'location_picker_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CartScreen — سلة الشراء
// ─────────────────────────────────────────────────────────────────────────────

class CartItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String craftsmanAr;
  final String craftsmanEn;
  final double price;
  final String imagePath;
  int quantity;

  CartItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.craftsmanAr,
    required this.craftsmanEn,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const CartScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _deliveryAddress = "";
  String _paymentMethod = "";

  @override
  void initState() {
    super.initState();
    _deliveryAddress = widget.isArabic
        ? "نابلس، فلسطين"
        : "Nablus, Palestine";
    _paymentMethod = widget.isArabic ? "الدفع الإلكتروني (Escrow)" : "Online Payment (Escrow)";
  }

  // Mock data
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      titleAr: 'طاولة خشبية يدوية',
      titleEn: 'Handmade Wooden Table',
      craftsmanAr: 'محمد الحرفي',
      craftsmanEn: 'Mohammed Craftsman',
      price: 120.0,
      imagePath: 'assets/table.png', // Fallback icon will be used
      quantity: 1,
    ),
    CartItem(
      id: '2',
      titleAr: 'مصباح نحاسي تقليدي',
      titleEn: 'Traditional Copper Lamp',
      craftsmanAr: 'سالم النحاس',
      craftsmanEn: 'Salem Copper',
      price: 45.0,
      imagePath: 'assets/lamp.png',
      quantity: 2,
    ),
  ];

  // Theme colors
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.08);
  Color get accent => widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get delivery => _items.isEmpty ? 0 : 15.0; // Flat delivery fee
  double get total => subtotal + delivery;

  void _increment(CartItem item) {
    setState(() => item.quantity++);
  }

  void _decrement(CartItem item) {
    if (item.quantity > 1) {
      setState(() => item.quantity--);
    }
  }

  void _removeItem(CartItem item) {
    setState(() => _items.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(widget.isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('سلة الشراء', 'My Cart'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            if (_items.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _items.clear()),
                child: Text(
                  t('إفراغ', 'Clear'),
                  style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        body: _items.isEmpty ? _buildEmptyState() : _buildCartList(),
        bottomNavigationBar: _items.isEmpty ? null : _buildBottomSummary(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.shopping_cart_outlined, size: 80, color: accent),
          ),
          const SizedBox(height: 24),
          Text(
            t('سلتك فارغة!', 'Your cart is empty!'),
            style: GoogleFonts.cairo(color: text, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            t('تصفح منتجات حرفيينا وأضف ما يعجبك', 'Browse our craftsmen products and add some items'),
            style: GoogleFonts.cairo(color: dim, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              t('تصفح الآن', 'Shop Now'),
              style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Image Placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: accent, size: 32),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(item.titleAr, item.titleEn),
                      style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      t('بواسطة ${item.craftsmanAr}', 'By ${item.craftsmanEn}'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price} JD',
                      style: GoogleFonts.cairo(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              // Controls
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _removeItem(item),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _decrement(item),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Icon(Icons.remove, size: 16),
                          ),
                        ),
                        Text(
                          '${item.quantity}',
                          style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => _increment(item),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Icon(Icons.add, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectPaymentMethod() {
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final methods = [
          {'nameAr': 'الدفع الإلكتروني (Escrow) 🔒', 'nameEn': 'Online Payment (Escrow) 🔒', 'icon': Icons.shield_outlined, 'recommended': true},
          {'nameAr': 'بطاقة ائتمان / مدى', 'nameEn': 'Credit / Debit Card', 'icon': Icons.credit_card, 'recommended': false},
        ];

        return Directionality(
          textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('اختر طريقة الدفع', 'Select Payment Method'),
                  style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...methods.map((m) {
                  final name = t(m['nameAr'] as String, m['nameEn'] as String);
                  final isSel = _paymentMethod == name;
                  final isRecommended = m['recommended'] as bool;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isRecommended) ...
                        [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4A017).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                t('مدفوعاتك محمية حتى تتم الخدمة', 'Your payment protected until service is done'),
                                style: GoogleFonts.cairo(color: const Color(0xFFD4A017), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(m['icon'] as IconData, color: isSel ? accent : dim),
                        title: Text(
                          name,
                          style: GoogleFonts.cairo(
                            color: text,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSel ? Icon(Icons.check_circle, color: accent) : null,
                        onTap: () {
                          setState(() => _paymentMethod = name);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessOrder() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          isArabic: widget.isArabic,
          isDarkMode: widget.isDarkMode,
          orderNumber: '#CR-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location Selection Row
            InkWell(
              onTap: () async {
                final address = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPickerScreen(
                      isArabic: widget.isArabic,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
                if (address != null && address.isNotEmpty) {
                  setState(() {
                    _deliveryAddress = address;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _deliveryAddress.isEmpty ? t('اختر موقع التوصيل', 'Choose Delivery Location') : _deliveryAddress,
                        style: GoogleFonts.cairo(color: text, fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: dim, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Payment Selection Row
            InkWell(
              onTap: _selectPaymentMethod,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.payment_outlined, color: accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _paymentMethod,
                        style: GoogleFonts.cairo(color: text, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: dim, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Promo Code
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: text),
                    decoration: InputDecoration(
                      hintText: t('كود الخصم', 'Promo Code'),
                      hintStyle: TextStyle(color: dim),
                      filled: true,
                      fillColor: bg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: text,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    t('تطبيق', 'Apply'),
                    style: GoogleFonts.cairo(color: surface, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t('المجموع الفرعي', 'Subtotal'), style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                Text('$subtotal JD', style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            // Delivery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t('التوصيل', 'Delivery'), style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                Text('$delivery JD', style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: border),
            const SizedBox(height: 12),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t('الإجمالي', 'Total'), style: GoogleFonts.cairo(color: text, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  '$total JD',
                  style: GoogleFonts.cairo(color: accent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _showSuccessOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  t('إتمام الطلب', 'Checkout'),
                  style: GoogleFonts.cairo(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
