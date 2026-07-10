import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'craftsman_orders_screen.dart';
import 'craftsman_exhibitions_screen.dart';
import 'explore_exhibitions_screen.dart';

class CraftsmanDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String categoryTitleAr;
  final String categoryTitleEn;
  final String name;
  final String city;
  final String experience;
  final String bio;
  final bool isVerified;
  final bool isPending;

  const CraftsmanDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.categoryTitleAr,
    required this.categoryTitleEn,
    required this.name,
    required this.city,
    required this.experience,
    required this.bio,
    this.isVerified = true,
    this.isPending = false,
  });

  @override
  State<CraftsmanDashboard> createState() => _CraftsmanDashboardState();
}

class _CraftsmanDashboardState extends State<CraftsmanDashboard> {
  late bool isArabic;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
  }

  // Colors mapping
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor => isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.08);

  Color get topIconColor => isDarkMode ? Colors.white : Colors.black87;

  Color get topButtonBackground =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get chipBorderColor => isDarkMode ? Colors.white12 : Colors.black12;

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
    widget.onToggleLanguage();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    widget.onToggleTheme();
  }

  /// Convert English digits to Eastern Arabic digits when isArabic is true
  String localizeNumber(String value) {
    if (!isArabic) return value;
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < en.length; i++) {
      value = value.replaceAll(en[i], ar[i]);
    }
    return value;
  }

  String t(String ar, String en) => isArabic ? ar : en;

  // Helper to map category to asset images in project
  List<String> getCategoryAssets() {
    if (widget.isPending) return [];
    final title = widget.categoryTitleEn.toLowerCase();
    if (title.contains('crochet')) {
      return ['assets/images/crochet.jpg', 'assets/images/crochet.jpg'];
    } else if (title.contains('pottery')) {
      return ['assets/images/pottery.jpg', 'assets/images/plate.jpg'];
    } else if (title.contains('jewelry')) {
      return ['assets/images/jewelry.jpg', 'assets/images/jewelry.jpg'];
    } else if (title.contains('weaving')) {
      return ['assets/images/basket.jpg', 'assets/images/basket.jpg'];
    } else {
      // Fallback
      return ['assets/images/pottery.jpg', 'assets/images/plate.jpg'];
    }
  }

  // Helper to get mock orders based on category
  List<Map<String, String>> getCategoryOrders() {
    if (widget.isPending) return [];
    final title = widget.categoryTitleEn.toLowerCase();
    if (title.contains('crochet')) {
      return [
        {
          "titleAr": "تطريز ثوب تقليدي كامل",
          "titleEn": "Embroider traditional dress",
          "price": "250 JOD",
          "client": "أميرة أحمد",
          "time": "منذ ساعتين",
        },
        {
          "titleAr": "دمية كروشيه مخصصة للأطفال",
          "titleEn": "Custom crochet toy for kids",
          "price": "35 JOD",
          "client": "سارة علي",
          "time": "منذ 4 ساعات",
        },
      ];
    } else if (title.contains('pottery')) {
      return [
        {
          "titleAr": "صناعة طقم أواني فخارية من 6 قطع",
          "titleEn": "Handmade 6-piece clay cookware",
          "price": "180 JOD",
          "client": "محمد إبراهيم",
          "time": "منذ ساعة",
        },
        {
          "titleAr": "لوحة سيراميك مزخرفة للمنزل",
          "titleEn": "Decorated ceramic wall plate",
          "price": "90 JOD",
          "client": "رائد فهد",
          "time": "منذ يوم",
        },
      ];
    } else if (title.contains('jewelry')) {
      return [
        {
          "titleAr": "خاتم فضة عيار 925 بحجر عقيق مخصص",
          "titleEn": "Custom 925 silver ring with agate",
          "price": "120 JOD",
          "client": "خالد عمر",
          "time": "منذ 3 ساعات",
        },
        {
          "titleAr": "عقد ذهبي مصمم يدوياً بالكامل",
          "titleEn": "Fully custom designed gold necklace",
          "price": "450 JOD",
          "client": "هدى سليم",
          "time": "منذ 6 ساعات",
        },
      ];
    } else {
      return [
        {
          "titleAr": "طلب عمل قطعة خشبية فنية للمكتب",
          "titleEn": "Wooden artistic desk organizer",
          "price": "75 JOD",
          "client": "يوسف محمود",
          "time": "منذ 5 ساعات",
        },
        {
          "titleAr": "لوحة جدارية بخط عربي أصيل",
          "titleEn": "Arabic calligraphy canvas mural",
          "price": "150 JOD",
          "client": "ليلى حسن",
          "time": "منذ يوم",
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final activeCategory = isArabic
        ? widget.categoryTitleAr
        : widget.categoryTitleEn;
    final assets = getCategoryAssets();
    final orders = getCategoryOrders();

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topBarButton(
                          icon: isArabic
                              ? Icons.arrow_forward_ios
                              : Icons.arrow_back_ios,
                          label: "",
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            _topBarButton(
                              icon: Icons.language,
                              label: isArabic ? "EN" : "عربي",
                              onTap: toggleLanguage,
                            ),
                            const SizedBox(width: 10),
                            _topBarButton(
                              icon: isDarkMode
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              label: "",
                              onTap: toggleTheme,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Craftsman profile info
                    Row(
                      children: [
                        // Circular Profile Avatar with Glowing Gold Border
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD4A017),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD4A017,
                                ).withValues(alpha: 0.2),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF1C2431),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFFD4A017),
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Name and dynamic Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (widget.isVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      color: Color(0xFFD4A017),
                                      size: 18,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: secondaryTextColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.city,
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (widget.experience.isNotEmpty) ...[
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.workspace_premium_outlined,
                                      size: 14,
                                      color: secondaryTextColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.experience.contains('سنة') ||
                                              widget.experience.contains(
                                                'years',
                                              )
                                          ? localizeNumber(widget.experience)
                                          : "${localizeNumber(widget.experience)} ${isArabic ? 'سنوات خبرة' : 'years exp'}",
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Craft Category Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD4A017,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFD4A017,
                                    ).withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  activeCategory,
                                  style: const TextStyle(
                                    color: Color(0xFFD4A017),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Profile Completion Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                        border: Border.all(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isArabic
                                    ? "اكتمال الملف الشخصي"
                                    : "Profile Completion",
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                localizeNumber("85%"),
                                style: const TextStyle(
                                  color: Color(0xFFD4A017),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: 0.85,
                              backgroundColor: const Color(
                                0xFFD4A017,
                              ).withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFD4A017),
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isArabic
                                ? "أضف رابط حسابك على إنستغرام لزيادة الموثوقية"
                                : "Add your Instagram link to increase trust",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                     // ── Artisan AI Analytics (Premium Feature) ──
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF1C2431).withValues(alpha: 0.75)
                              : Colors.white.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFD4A017).withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A017).withValues(alpha: 0.08),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with glowing AI indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4A017).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.psychology, color: Color(0xFFD4A017), size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isArabic ? 'تحليلات AI الذكية' : 'Smart AI Insights',
                                          style: GoogleFonts.cairo(
                                            color: primaryTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          isArabic ? 'تحديث فوري • نشط' : 'Real-time • Active',
                                          style: GoogleFonts.cairo(
                                            color: const Color(0xFFD4A017),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.trending_up, color: Colors.green, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        isArabic ? 'ممتاز' : 'Optimal',
                                        style: GoogleFonts.cairo(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Grid of Key metrics
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricTile(
                                    isArabic ? 'الطلب المحلي' : 'Local Demand',
                                    '92%',
                                    Colors.purpleAccent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMetricTile(
                                    isArabic ? 'تفاعل الزبائن' : 'Engagement',
                                    '4.8x',
                                    const Color(0xFFD4A017),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Dynamic tag list & Actions
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildTrendChip(
                                    icon: Icons.whatshot,
                                    label: isArabic ? 'طلب مرتفع' : 'Trending',
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildTrendChip(
                                    icon: Icons.location_on,
                                    label: widget.city,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CraftsmanExhibitionsScreen(
                                            isArabic: widget.isArabic,
                                            isDarkMode: widget.isDarkMode,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildTrendChip(
                                      icon: Icons.festival,
                                      label: isArabic ? 'معارضي' : 'My Exhibitions',
                                      color: const Color(0xFFD4A017),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ExploreExhibitionsScreen(
                                            isArabic: widget.isArabic,
                                            isDarkMode: widget.isDarkMode,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildTrendChip(
                                      icon: Icons.search,
                                      label: isArabic ? 'استكشف المعارض' : 'Explore',
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 24, color: Colors.white10),

                            // AI Recommendation Bullet Items
                            _buildRecommendationItem(
                              icon: Icons.trending_up,
                              color: Colors.green,
                              text: isArabic
                                  ? 'يتوقع الـ AI زيادة في حجم المبيعات بنسبة 15% الأسبوع المقبل بمناسبة العيد.'
                                  : 'AI predicts a 15% increase in orders next week due to holiday shopping.',
                            ),
                            const SizedBox(height: 12),
                            _buildRecommendationItem(
                              icon: Icons.local_offer,
                              color: const Color(0xFFD4A017),
                              text: isArabic
                                  ? 'توصية تسعير: تقديم خصم 10% على "طقم خشبي" سيرفع سرعة المبيعات بمعدل 2.4 ضعفاً.'
                                  : 'Pricing recommendation: Offering 10% discount on "Wooden Set" will speed up sales by 2.4x.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),                    // Stats Panel (Glassmorphism row)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cardBorderColor, width: 1.5),
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.02),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            isArabic ? "الأرباح" : "Earnings",
                            widget.isPending ? "0 JOD" : "1,250 JOD",
                            Icons.account_balance_wallet_outlined,
                          ),
                          _buildStatDivider(),
                          _buildStatItem(
                            isArabic ? "التقييم" : "Rating",
                            widget.isPending ? "—" : "4.9 ★",
                            Icons.star_outline,
                          ),
                          _buildStatDivider(),
                          _buildStatItem(
                            isArabic ? "الطلبات" : "Completed",
                            widget.isPending ? "0" : "24",
                            Icons.done_all_outlined,
                          ),
                          _buildStatDivider(),
                          _buildStatItem(
                            isArabic ? "المشاهدات" : "Views",
                            widget.isPending ? "0" : "3.2K",
                            Icons.remove_red_eye_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Section 1: Portfolio Gallery
                    Text(
                      isArabic
                          ? "معرض أعمالك المميزة"
                          : "Your Featured Portfolio",
                      style: GoogleFonts.arefRuqaa(
                        color: primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      height: 160,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: assets.length + 1,
                          itemBuilder: (context, index) {
                            if (index == assets.length) {
                              // "Add New Work" Glass Card
                              return _buildAddWorkCard();
                            }
                            return _buildPortfolioCard(assets[index]);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Section 2: Available Orders in field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic
                              ? "طلبات متاحة لمجالك"
                              : "Available Orders in your field",
                          style: GoogleFonts.arefRuqaa(
                            color: primaryTextColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.bolt,
                          color: const Color(0xFFD4A017),
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // List of Orders
                    if (widget.isPending)
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFFD4A017,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFD4A017),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? "حسابك قيد المراجعة. لن تتمكن من استقبال الطلبات حتى يتم توثيق حسابك بالكامل."
                                    : "Account pending verification. You cannot receive orders until your account is fully verified.",
                                style: TextStyle(
                                  color: primaryTextColor,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return _buildOrderCard(
                            title: isArabic
                                ? order["titleAr"]!
                                : order["titleEn"]!,
                            client: order["client"]!,
                            price: order["price"]!,
                            time: order["time"]!,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD4A017), size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: secondaryTextColor, fontSize: 11)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: cardBorderColor);
  }

  Widget _buildPortfolioCard(String assetPath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAddWorkCard() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: const Color(0xFFD4A017),
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                isArabic ? "أضف عملاً جديداً" : "Add New Work",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required String client,
    required String price,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Client name and Time)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(
                            0xFFD4A017,
                          ).withValues(alpha: 0.12),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFFD4A017),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          client,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: secondaryTextColor.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Order Title
                Text(
                  title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Price & Bid Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFFD4A017),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Bid Button (Glass)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.4),
                          width: 1,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF7B500).withValues(alpha: 0.1),
                            const Color(0xFFD89A00).withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Submit Bid
                        },
                        child: Text(
                          isArabic ? "تقديم عرض" : "Submit Bid",
                          style: const TextStyle(
                            color: Color(0xFFD4A017),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: topButtonBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: topIconColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: topIconColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              color: secondaryTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({required IconData icon, required Color color, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              color: primaryTextColor.withValues(alpha: 0.85),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
