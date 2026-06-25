import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const ClientDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  late bool isArabic;
  late bool isDarkMode;

  // Selected filter category (null means "All")
  int? selectedFilterIndex;

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

  Color get secondaryTextColor =>
      isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);

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

  // Category filter items
  List<Map<String, dynamic>> get categories => [
        {"icon": Icons.all_inclusive, "titleAr": "الكل", "titleEn": "All"},
        {"icon": Icons.checkroom_outlined, "titleAr": "تطريز", "titleEn": "Crochet"},
        {"icon": Icons.local_cafe_outlined, "titleAr": "فخار", "titleEn": "Pottery"},
        {"icon": Icons.watch_outlined, "titleAr": "مجوهرات", "titleEn": "Jewelry"},
        {"icon": Icons.chair_outlined, "titleAr": "خشب", "titleEn": "Wood"},
      ];

  // Mock Craftsmen
  List<Map<String, dynamic>> get craftsmen => [
        {
          "nameAr": "أمجد الخطيب",
          "nameEn": "Amjad Al-Khateeb",
          "rating": "4.9",
          "jobs": "52",
          "craftAr": "أعمال الخشب والأثاث",
          "craftEn": "Woodworking",
          "image": "assets/images/plate.jpg"
        },
        {
          "nameAr": "فاطمة محمود",
          "nameEn": "Fatima Mahmoud",
          "rating": "4.8",
          "jobs": "74",
          "craftAr": "خياطة وتطريز",
          "craftEn": "Crochet & Knitting",
          "image": "assets/images/crochet.jpg"
        },
        {
          "nameAr": "إياد الكردي",
          "nameEn": "Iyad Al-Kurdi",
          "rating": "5.0",
          "jobs": "31",
          "craftAr": "الفخار والخزف",
          "craftEn": "Pottery & Ceramics",
          "image": "assets/images/pottery.jpg"
        }
      ];

  // Open AI Order Creator Bottom Sheet
  void _openAIOrderCreator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF0D1420).withOpacity(0.9)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: cardBorderColor, width: 1.5),
                ),
                child: Directionality(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? "طلب ذكي بالـ AI" : "AI Smart Order",
                            style: GoogleFonts.arefRuqaa(
                              color: const Color(0xFFD4A017),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: primaryTextColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isArabic
                            ? "اكتب ما تحتاجه وسيقوم الذكاء الاصطناعي بتصنيفه وتحديد السعر الموصى به."
                            : "Write what you need and the AI will categorize it and recommend a price.",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Text Field
                      TextField(
                        maxLines: 3,
                        style: TextStyle(color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: isArabic
                              ? "أحتاج إلى سجادة صوفية صغيرة بنقش تقليدي أحمر..."
                              : "I need a small wool rug with red traditional patterns...",
                          hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
                          filled: true,
                          fillColor: isDarkMode ? Colors.white10 : Colors.black12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFD4A017), width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Estimated Price Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFD4A017).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFFD4A017)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic ? "السعر الموصى به" : "Recommended Price Range",
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isArabic ? "45 - 60 دينار أردني" : "45 - 60 JOD",
                                    style: const TextStyle(
                                      color: Color(0xFFD4A017),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Post Button
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF7B500),
                              Color(0xFFD89A00),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic
                                      ? "تم نشر طلبك بنجاح وسيتواصل معك الحرفيون قريباً!"
                                      : "Order posted successfully! Craftsmen will bid soon.",
                                ),
                              ),
                            );
                          },
                          child: Text(
                            isArabic ? "نشر الطلب" : "Post Order",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        // Floating Action Button to post smart job
        floatingActionButton: FloatingActionButton(
          onPressed: _openAIOrderCreator,
          backgroundColor: const Color(0xFFD4A017),
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topBarButton(
                        icon: isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
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

                  // Header title
                  Text(
                    isArabic ? "ابحث عن الفن الجميل" : "Explore Beautiful Craft",
                    style: GoogleFonts.arefRuqaa(
                      color: primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isArabic ? "تواصل مع أمهر الحرفيين في منطقتك" : "Connect with the finest local craftsmen",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cardBorderColor, width: 1),
                    ),
                    child: TextField(
                      style: TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        hintText: isArabic ? "ابحث عن حرفة أو حرفي..." : "Search for a craft or craftsman...",
                        hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Categories Filter Chips Row
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selectedFilterIndex == index || (selectedFilterIndex == null && index == 0);
                        return _buildCategoryChip(
                          icon: cat["icon"],
                          title: isArabic ? cat["titleAr"] : cat["titleEn"],
                          isSelected: isSelected,
                          index: index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Section 1: Featured Craftsmen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? "أبرز الحرفيين" : "Featured Craftsmen",
                        style: GoogleFonts.arefRuqaa(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isArabic ? "الكل" : "View All",
                        style: const TextStyle(
                          color: Color(0xFFD4A017),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Horizontal list of craftsmen
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: craftsmen.length,
                      itemBuilder: (context, index) {
                        final maker = craftsmen[index];
                        return _buildCraftsmanCard(
                          name: isArabic ? maker["nameAr"] : maker["nameEn"],
                          craft: isArabic ? maker["craftAr"] : maker["craftEn"],
                          rating: maker["rating"],
                          jobs: maker["jobs"],
                          imagePath: maker["image"],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required IconData icon,
    required String title,
    required bool isSelected,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilterIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4A017)
              : (isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4A017) : cardBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.black
                  : (isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : (isDarkMode ? Colors.white70 : Colors.black87),
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftsmanCard({
    required String name,
    required String craft,
    required String rating,
    required String jobs,
    required String imagePath,
  }) {
    return Container(
      width: 175,
      margin: const EdgeInsets.only(left: 16, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      craft,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFD4A017),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating and jobs count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF7B500), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$jobs ${isArabic ? 'طلب' : 'Jobs'}",
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
}
