import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ArtisanProfilePage — matched to ClientDashboard theme
// ─────────────────────────────────────────────────────────────────────────────

class ArtisanProfilePage extends StatefulWidget {
  final Map<String, dynamic> artisan;
  final bool isArabic;
  final bool isDarkMode;
  final bool isGuest;

  const ArtisanProfilePage({
    super.key,
    required this.artisan,
    required this.isArabic,
    required this.isDarkMode,
    this.isGuest = false,
  });

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage>
    with SingleTickerProviderStateMixin {
  late bool isArabic;
  late bool isDarkMode;

  bool _following = false;
  bool _isFavorite = false;
  int _productTab = 0;
  late TabController _tabController;

  // ── Calendar state ──────────────────────────────────────────────────────
  DateTime _selectedDay = DateTime.now(); // for highlighting today

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() => _productTab = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Theme-aware colors (mirroring ClientDashboard) ──────────────────────
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);

  Color get topButtonBackground =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  static const Color _gold = Color(0xFFD4A017);
  static const Color _starGold = Color(0xFFF7B500);

  String t(String ar, String en) => isArabic ? ar : en;

  // ── Mock data ────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _productGroups = [
    {
      "tabAr": "كل الأعمال",
      "tabEn": "All",
      "items": [
        {"nameAr": "وشاح صوف", "nameEn": "Wool Scarf", "price": 22.0, "icon": Icons.checkroom_outlined},
        {"nameAr": "سجادة مطرزة", "nameEn": "Embroidered Rug", "price": 52.0, "icon": Icons.grid_on_outlined},
        {"nameAr": "مفرش طاولة", "nameEn": "Table Runner", "price": 35.0, "icon": Icons.table_restaurant_outlined},
      ],
    },
    {
      "tabAr": "تطريز",
      "tabEn": "Embroidery",
      "items": [
        {"nameAr": "وشاح صوف", "nameEn": "Wool Scarf", "price": 22.0, "icon": Icons.checkroom_outlined},
        {"nameAr": "سجادة مطرزة", "nameEn": "Embroidered Rug", "price": 52.0, "icon": Icons.grid_on_outlined},
      ],
    },
    {
      "tabAr": "منسوجات",
      "tabEn": "Textiles",
      "items": [
        {"nameAr": "مفرش طاولة", "nameEn": "Table Runner", "price": 35.0, "icon": Icons.table_restaurant_outlined},
      ],
    },
  ];

  // ── Events with actual DateTime objects ──────────────────────────────────
  final List<Map<String, dynamic>> _events = [
    {
      "titleAr": "معرض الحرف اليدوية",
      "titleEn": "Handcraft Fair",
      "date": DateTime(2026, 7, 15),
      "locationAr": "نابلس",
      "locationEn": "Nablus",
    },
    {
      "titleAr": "سوق رمضان",
      "titleEn": "Ramadan Market",
      "date": DateTime(2026, 7, 22),
      "locationAr": "رام الله",
      "locationEn": "Ramallah",
    },
    // Add a test event for today if you want to see the "today" indicator
    // {"titleAr": "حدث اليوم", "titleEn": "Today's Event", "date": DateTime.now(), "locationAr": "القدس", "locationEn": "Jerusalem"},
  ];

  // ── Reviews ──────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _reviews = [
    {"nameAr": "أحمد ناصر", "nameEn": "Ahmad Naser", "rating": 5, "commentAr": "جودة رائعة وتوصيل سريع، ينصح به بشدة!", "commentEn": "Excellent quality and fast delivery, highly recommended!"},
    {"nameAr": "سارة العلي", "nameEn": "Sara Al-Ali", "rating": 4, "commentAr": "عمل جميل جداً، التواصل كان ممتازاً.", "commentEn": "Very beautiful work, communication was excellent."},
    {"nameAr": "محمود حسن", "nameEn": "Mahmoud Hassan", "rating": 5, "commentAr": "تجاوز توقعاتي، شكراً جزيلاً!", "commentEn": "Exceeded my expectations, thank you so much!"},
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.black)),
        backgroundColor: _gold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Returns the event that matches the given date, or null.
  Map<String, dynamic>? _getEventForDate(DateTime date) {
    try {
      return _events.firstWhere((e) =>
      e["date"].year == date.year &&
          e["date"].month == date.month &&
          e["date"].day == date.day);
    } catch (_) {
      return null;
    }
  }

  /// Shows a dialog with event details when a day with an event is tapped.
  void _showEventDetails(DateTime date) {
    final event = _getEventForDate(date);
    if (event == null) {
      _showSnack(t('لا يوجد حدث في هذا اليوم', 'No event on this day'));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: topButtonBackground,
        title: Text(
          t(event["titleAr"], event["titleEn"]),
          style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: _gold, size: 16),
                const SizedBox(width: 8),
                Text(
                  "${date.day}/${date.month}/${date.year}",
                  style: TextStyle(color: secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: _gold, size: 16),
                const SizedBox(width: 8),
                Text(
                  t(event["locationAr"], event["locationEn"]),
                  style: TextStyle(color: secondaryTextColor),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('إغلاق', 'Close'), style: TextStyle(color: _gold)),
          ),
        ],
      ),
    );
  }

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
                    ? "يرجى تسجيل الدخول للاستفادة من هذه الميزة والتواصل مع أمهر الحرفيين."
                    : "Please log in to use this feature and connect with the best craftsmen.",
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

  @override
  Widget build(BuildContext context) {
    final a = widget.artisan;
    final name = t(a["nameAr"] ?? '', a["nameEn"] ?? '');
    final craft = t(a["craftAr"] ?? '', a["craftEn"] ?? '');

    // Get list of event dates for the calendar dots.
    final eventDates = _events.map((e) => e["date"] as DateTime).toList();

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,

        // ── Sticky bottom bar ────────────────────────────────────────────
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: topButtonBackground,
            border: Border(top: BorderSide(color: cardBorderColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.isGuest 
                      ? _showGuestPrompt 
                      : () => _showSnack(t('فتح نموذج الطلب المخصص', 'Opening custom order form...')),
                  icon: Icon(Icons.edit_outlined, size: 16, color: _gold),
                  label: Text(
                    t('طلب مخصص', 'Custom Order'),
                    style: TextStyle(color: _gold, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: _gold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.isGuest 
                      ? _showGuestPrompt 
                      : () => _showSnack(t('فتح نموذج التوظيف', 'Opening hire form...')),
                  icon: const Icon(Icons.handshake_outlined, size: 16, color: Colors.black),
                  label: Text(
                    t('استئجار / موقع', 'Hire / On-Site'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),

        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Cover + AppBar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: backgroundColor,
              leading: _CircleBtn(
                icon: isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                onTap: () => Navigator.pop(context),
                bg: topButtonBackground,
                iconColor: primaryTextColor,
                border: cardBorderColor,
              ),
              actions: [
                // ── Favourite heart button ──
                GestureDetector(
                  onTap: () {
                    if (widget.isGuest) {
                      _showGuestPrompt();
                      return;
                    }
                    setState(() => _isFavorite = !_isFavorite);
                    _showSnack(
                      _isFavorite
                          ? t('تمت الإضافة إلى المفضلة ❤️', 'Added to Favorites ❤️')
                          : t('تمت الإزالة من المفضلة', 'Removed from Favorites'),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isFavorite
                          ? const Color(0xFFE53935).withValues(alpha: 0.15)
                          : topButtonBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isFavorite
                            ? const Color(0xFFE53935).withValues(alpha: 0.6)
                            : cardBorderColor,
                        width: 1.5,
                      ),
                      boxShadow: _isFavorite
                          ? [
                              BoxShadow(
                                color: const Color(0xFFE53935).withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? const Color(0xFFE53935) : primaryTextColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleBtn(
                  icon: Icons.share_outlined,
                  onTap: () {},
                  bg: topButtonBackground,
                  iconColor: primaryTextColor,
                  border: cardBorderColor,
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [const Color(0xFF1C2431), const Color(0xFF0D1420)]
                          : [const Color(0xFFE8EAF0), const Color(0xFFF5F6F8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Avatar + name + follow row ───────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode ? const Color(0xFF0D1420) : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: _gold.withOpacity(0.2),
                            backgroundImage: (a["image"] != null && (a["image"] as String).isNotEmpty)
                                ? AssetImage(a["image"] as String)
                                : null,
                            child: (a["image"] == null || (a["image"] as String).isEmpty)
                                ? Text(
                              name.isNotEmpty ? name[0] : '?',
                              style: TextStyle(
                                fontSize: 28,
                                color: _gold,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: GoogleFonts.arefRuqaa(
                                        color: primaryTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.verified_rounded,
                                    color: _gold,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                craft,
                                style: TextStyle(
                                  color: _gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: secondaryTextColor,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    t('نابلس، فلسطين', 'Nablus, Palestine'),
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ── Action buttons ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            label: _following
                                ? t('متابَع', 'Following')
                                : t('تابع', 'Follow'),
                            icon: _following
                                ? Icons.check_rounded
                                : Icons.person_add_outlined,
                            filled: _following,
                            accent: _gold,
                            border: cardBorderColor,
                            surface: topButtonBackground,
                            text: primaryTextColor,
                            onTap: widget.isGuest 
                                ? _showGuestPrompt 
                                : () => setState(() => _following = !_following),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionBtn(
                            label: t('مراسلة', 'Message'),
                            icon: Icons.chat_bubble_outline_rounded,
                            filled: false,
                            accent: _gold,
                            border: cardBorderColor,
                            surface: topButtonBackground,
                            text: primaryTextColor,
                            onTap: widget.isGuest 
                                ? _showGuestPrompt 
                                : () => _showSnack(t('فتح المحادثة...', 'Opening chat...')),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Stats row ────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: topButtonBackground,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Row(
                        children: [
                          _Stat(
                            value: a["rating"] ?? '—',
                            labelAr: 'التقييم',
                            labelEn: 'Rating',
                            accent: _gold,
                            dim: secondaryTextColor,
                            isArabic: isArabic,
                          ),
                          _StatDivider(color: cardBorderColor),
                          _Stat(
                            value: a["jobs"] ?? '0',
                            labelAr: 'طلب',
                            labelEn: 'Orders',
                            accent: _gold,
                            dim: secondaryTextColor,
                            isArabic: isArabic,
                          ),
                          _StatDivider(color: cardBorderColor),
                          _Stat(
                            value: '128',
                            labelAr: 'متابع',
                            labelEn: 'Followers',
                            accent: _gold,
                            dim: secondaryTextColor,
                            isArabic: isArabic,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Bio ──────────────────────────────────────────────
                    Text(
                      t('نبذة', 'About'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t(
                        'حرفية فلسطينية متخصصة في التطريز والمنسوجات اليدوية التقليدية. أمارس هذه الحرفة منذ أكثر من ١٥ عاماً وتعلمتها من جدتي. أسعى دائماً إلى دمج الأصالة مع اللمسات العصرية.',
                        'Palestinian artisan specializing in traditional embroidery and handwoven textiles. I have been practicing this craft for over 15 years, learning it from my grandmother, and always strive to blend authenticity with modern touches.',
                      ),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 13.5,
                        height: 1.65,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Specializations ──────────────────────────────────
                    Text(
                      t('التخصصات', 'Specializations'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Chip(
                          label: t('تطريز', 'Embroidery'),
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                        ),
                        _Chip(
                          label: t('منسوجات', 'Textiles'),
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                        ),
                        _Chip(
                          label: t('خياطة', 'Sewing'),
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                        ),
                        _Chip(
                          label: t('كروشيه', 'Crochet'),
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Offer types ──────────────────────────────────────
                    Text(
                      t('أنواع الخدمات', 'Offer Types'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _OfferType(
                          icon: Icons.inventory_2_outlined,
                          labelAr: 'جاهز للبيع',
                          labelEn: 'Ready-Made',
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                          dim: secondaryTextColor,
                          isArabic: isArabic,
                        ),
                        const SizedBox(width: 10),
                        _OfferType(
                          icon: Icons.edit_outlined,
                          labelAr: 'طلب مخصص',
                          labelEn: 'Custom Order',
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                          dim: secondaryTextColor,
                          isArabic: isArabic,
                        ),
                        const SizedBox(width: 10),
                        _OfferType(
                          icon: Icons.handshake_outlined,
                          labelAr: 'خدمة في الموقع',
                          labelEn: 'Hire / On-Site',
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                          dim: secondaryTextColor,
                          isArabic: isArabic,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Products carousel ───────────────────────────────
                    Text(
                      t('الأعمال', 'Products'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tab row
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _productGroups.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final sel = i == _productTab;
                          return GestureDetector(
                            onTap: () {
                              _tabController.animateTo(i);
                              setState(() => _productTab = i);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: sel ? _gold : topButtonBackground,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: sel ? _gold : cardBorderColor,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                t(_productGroups[i]["tabAr"], _productGroups[i]["tabEn"]),
                                style: TextStyle(
                                  color: sel ? Colors.black : primaryTextColor,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Product carousel for active tab
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: (_productGroups[_productTab]["items"] as List).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final item = (_productGroups[_productTab]["items"] as List)[i];
                          return _ProductCard(
                            nameAr: item["nameAr"],
                            nameEn: item["nameEn"],
                            price: item["price"],
                            icon: item["icon"],
                            isArabic: isArabic,
                            isDarkMode: isDarkMode,
                            accent: _gold,
                            surface: topButtonBackground,
                            border: cardBorderColor,
                            text: primaryTextColor,
                            dim: secondaryTextColor,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Calendar & Events section ──────────────────────
                    Text(
                      t('الفعاليات القادمة', 'Upcoming Events'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Calendar Widget ─────────────────────────────────
                    _EventCalendar(
                      eventDates: eventDates,
                      isArabic: isArabic,
                      accent: _gold,
                      textColor: primaryTextColor,
                      surfaceColor: topButtonBackground,
                      borderColor: cardBorderColor,
                      todayColor: Colors.red, // or any color you like
                      onDayTap: (date) {
                        setState(() {
                          _selectedDay = date;
                        });
                        _showEventDetails(date);
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── List of upcoming events (only next 2, with "See All" later) ──
                    if (_events.isEmpty)
                      Text(
                        t('لا توجد فعاليات قادمة', 'No upcoming events'),
                        style: TextStyle(color: secondaryTextColor, fontSize: 13),
                      )
                    else
                      ..._events.take(2).map(
                            (e) => _EventTile(
                          titleAr: e["titleAr"],
                          titleEn: e["titleEn"],
                          date: e["date"],
                          locationAr: e["locationAr"],
                          locationEn: e["locationEn"],
                          isArabic: isArabic,
                          accent: _gold,
                          surface: topButtonBackground,
                          border: cardBorderColor,
                          text: primaryTextColor,
                          dim: secondaryTextColor,
                          onTap: () => _showEventDetails(e["date"]),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // ── Reviews ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t('التقييمات', 'Reviews'),
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: _starGold,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              a["rating"] ?? '—',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '  (${a["jobs"] ?? 0} ${t("تقييم", "reviews")})',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._reviews.map(
                          (r) => _ReviewCard(
                        nameAr: r["nameAr"],
                        nameEn: r["nameEn"],
                        rating: r["rating"],
                        commentAr: r["commentAr"],
                        commentEn: r["commentEn"],
                        isArabic: isArabic,
                        accent: _gold,
                        surface: topButtonBackground,
                        border: cardBorderColor,
                        text: primaryTextColor,
                        dim: secondaryTextColor,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Widget
// ─────────────────────────────────────────────────────────────────────────────

class _EventCalendar extends StatefulWidget {
  final List<DateTime> eventDates;
  final bool isArabic;
  final Color accent;
  final Color textColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color todayColor;
  final Function(DateTime) onDayTap;

  const _EventCalendar({
    required this.eventDates,
    required this.isArabic,
    required this.accent,
    required this.textColor,
    required this.surfaceColor,
    required this.borderColor,
    this.todayColor = Colors.red,
    required this.onDayTap,
  });

  @override
  State<_EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<_EventCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    // Start with current month, but if today's date is in the past, still show current month
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _hasEvent(DateTime date) {
    return widget.eventDates.any((e) =>
    e.year == date.year && e.month == date.month && e.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final monthName = widget.isArabic
        ? _arabicMonths[_currentMonth.month - 1]
        : _englishMonths[_currentMonth.month - 1];
    final year = _currentMonth.year;

    // Build days grid
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startWeekday = firstDayOfMonth.weekday; // 1=Monday, 7=Sunday

    // Offset for first day (Monday=0)
    int offset = startWeekday - 1;

    List<Widget> dayWidgets = [];
    // Empty cells for offset
    for (int i = 0; i < offset; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final hasEvent = _hasEvent(date);
      final isToday = _isToday(date);

      dayWidgets.add(
        GestureDetector(
          onTap: () => widget.onDayTap(date),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? widget.todayColor.withOpacity(0.15)
                  : (hasEvent ? widget.accent.withOpacity(0.10) : null),
              border: isToday
                  ? Border.all(color: widget.todayColor, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isToday ? widget.todayColor : widget.textColor,
                    fontSize: 14,
                    fontWeight: isToday || hasEvent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasEvent)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.accent,
                    ),
                  )
                else
                  const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.borderColor),
      ),
      child: Column(
        children: [
          // Header with month/year and arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 16, color: widget.textColor),
                onPressed: _prevMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '$monthName $year',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 16, color: widget.textColor),
                onPressed: _nextMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Weekday headers
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 1.2,
            children: widget.isArabic
                ? ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س']
                .map((e) => Center(
                child: Text(e, style: TextStyle(color: widget.textColor.withOpacity(0.6), fontSize: 12))))
                .toList()
                : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((e) => Center(
                child: Text(e, style: TextStyle(color: widget.textColor.withOpacity(0.6), fontSize: 12))))
                .toList(),
          ),
          const SizedBox(height: 4),
          // Days grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 1.2,
            children: dayWidgets,
          ),
        ],
      ),
    );
  }

  static const _englishMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const _arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (all themed to match ClientDashboard)
// ─────────────────────────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg, iconColor, border;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    required this.bg,
    required this.iconColor,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final Color accent, border, surface, text;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.filled,
    required this.accent,
    required this.border,
    required this.surface,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: filled ? accent : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: filled ? accent : border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: filled ? Colors.black : text),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.black : text,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, labelAr, labelEn;
  final Color accent, dim;
  final bool isArabic;

  const _Stat({
    required this.value,
    required this.labelAr,
    required this.labelEn,
    required this.accent,
    required this.dim,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isArabic ? labelAr : labelEn,
            style: TextStyle(color: dim, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final Color color;
  const _StatDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: color);
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color accent, surface, border, text;

  const _Chip({
    required this.label,
    required this.accent,
    required this.surface,
    required this.border,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OfferType extends StatelessWidget {
  final IconData icon;
  final String labelAr, labelEn;
  final Color accent, surface, border, text, dim;
  final bool isArabic;

  const _OfferType({
    required this.icon,
    required this.labelAr,
    required this.labelEn,
    required this.accent,
    required this.surface,
    required this.border,
    required this.text,
    required this.dim,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(icon, color: accent, size: 22),
            const SizedBox(height: 6),
            Text(
              isArabic ? labelAr : labelEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: text,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String nameAr, nameEn;
  final double price;
  final IconData icon;
  final bool isArabic, isDarkMode;
  final Color accent, surface, border, text, dim;

  const _ProductCard({
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.icon,
    required this.isArabic,
    required this.isDarkMode,
    required this.accent,
    required this.surface,
    required this.border,
    required this.text,
    required this.dim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Icon(icon, size: 36, color: accent.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? nameAr : nameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${price.toStringAsFixed(0)} JOD',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final String titleAr, titleEn;
  final DateTime date;
  final String locationAr, locationEn;
  final bool isArabic;
  final Color accent, surface, border, text, dim;
  final VoidCallback onTap;

  const _EventTile({
    required this.titleAr,
    required this.titleEn,
    required this.date,
    required this.locationAr,
    required this.locationEn,
    required this.isArabic,
    required this.accent,
    required this.surface,
    required this.border,
    required this.text,
    required this.dim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.event_rounded, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? titleAr : titleEn,
                    style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: dim),
                      const SizedBox(width: 4),
                      Text(
                        "${date.day}/${date.month}/${date.year}",
                        style: TextStyle(color: dim, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on_outlined, size: 12, color: dim),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? locationAr : locationEn,
                        style: TextStyle(color: dim, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isArabic ? 'تسجيل' : 'RSVP',
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String nameAr, nameEn, commentAr, commentEn;
  final int rating;
  final bool isArabic;
  final Color accent, surface, border, text, dim;

  const _ReviewCard({
    required this.nameAr,
    required this.nameEn,
    required this.commentAr,
    required this.commentEn,
    required this.rating,
    required this.isArabic,
    required this.accent,
    required this.surface,
    required this.border,
    required this.text,
    required this.dim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: accent.withOpacity(0.2),
                child: Text(
                  (isArabic ? nameAr : nameEn)[0],
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic ? nameAr : nameEn,
                  style: TextStyle(
                    color: text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: i < rating
                        ? const Color(0xFFF7B500)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? commentAr : commentEn,
            style: TextStyle(
              color: dim,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
