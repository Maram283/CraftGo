import 'dart:ui';
import 'product_details_page.dart';
import 'artisan_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search_results_screen.dart';

class ClientDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final bool isGuest;

  const ClientDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    this.isGuest = false,
  });

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  late bool isArabic;
  late bool isDarkMode;

  // Selected filter category (null means "All") — quick chip row under search bar
  int? selectedFilterIndex;

  // ---- Advanced search / filter state ----
  Set<int> advancedCategoryFilters = {};
  RangeValues priceRange = const RangeValues(0, 200);
  double minRating = 0;
  // 'rating' | 'price_low' | 'price_high' | 'newest'
  String sortBy = 'rating';

  // ---- Products section state ----
  // 0 = Popular, 1 = New, 2 = Recommended
  int productTabIndex = 0;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant ClientDashboard old) {
    super.didUpdateWidget(old);
    if (old.isArabic != widget.isArabic) {
      setState(() => isArabic = widget.isArabic);
    }
    if (old.isDarkMode != widget.isDarkMode) {
      setState(() => isDarkMode = widget.isDarkMode);
    }
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

  Color get sheetBackground => isDarkMode
      ? const Color(0xFF0D1420).withValues(alpha: 0.95)
      : Colors.white.withValues(alpha: 0.95);

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
    {"icon": Icons.auto_awesome, "titleAr": "لك", "titleEn": "For You"},
    {"icon": Icons.new_releases_outlined, "titleAr": "جديد", "titleEn": "New"},
    {"icon": Icons.favorite_border, "titleAr": "الأكثر إعجاباً", "titleEn": "Most Liked"},
    {"icon": Icons.local_offer_outlined, "titleAr": "عروض", "titleEn": "Offer"},
    {"icon": Icons.location_on_outlined, "titleAr": "قريب منك", "titleEn": "Near You"},
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
      "image": "assets/images/plate.jpg",
    },
    {
      "nameAr": "فاطمة محمود",
      "nameEn": "Fatima Mahmoud",
      "rating": "4.8",
      "jobs": "74",
      "craftAr": "خياطة وتطريز",
      "craftEn": "Crochet & Knitting",
      "image": "assets/images/crochet.jpg",
    },
    {
      "nameAr": "إياد الكردي",
      "nameEn": "Iyad Al-Kurdi",
      "rating": "5.0",
      "jobs": "31",
      "craftAr": "الفخار والخزف",
      "craftEn": "Pottery & Ceramics",
      "image": "assets/images/pottery.jpg",
    },
    {
      "nameAr": "هنا سلامة",
      "nameEn": "Hana Salama",
      "rating": "4.7",
      "jobs": "28",
      "craftAr": "حلي ومجوهرات",
      "craftEn": "Jewelry & Accessories",
      "image": "assets/images/jewelry.jpg",
    },
    {
      "nameAr": "عمر السيد",
      "nameEn": "Omar Al-Sayed",
      "rating": "4.6",
      "jobs": "19",
      "craftAr": "رسم وفن تشكيلي",
      "craftEn": "Painting & Fine Art",
      "image": "assets/images/basket.jpg",
    },
  ];

  // Mock products feed — replace with real API data later.
  // tag is one of: popular, new, recommended (a product can carry more than one).
  List<Map<String, dynamic>> get products => [
    {
      "nameAr": "سجادة صوفية مطرزة",
      "nameEn": "Embroidered Wool Rug",
      "price": 52.0,
      "rating": "4.9",
      "icon": Icons.checkroom_outlined,
      "tags": ["popular", "recommended"],
    },
    {
      "nameAr": "إبريق فخاري تقليدي",
      "nameEn": "Traditional Clay Pitcher",
      "price": 28.0,
      "rating": "4.7",
      "icon": Icons.local_cafe_outlined,
      "tags": ["popular"],
    },
    {
      "nameAr": "خاتم فضة مصنوع يدوياً",
      "nameEn": "Handmade Silver Ring",
      "price": 35.0,
      "rating": "5.0",
      "icon": Icons.watch_outlined,
      "tags": ["new", "recommended"],
    },
    {
      "nameAr": "صندوق خشبي محفور",
      "nameEn": "Carved Wooden Box",
      "price": 60.0,
      "rating": "4.8",
      "icon": Icons.chair_outlined,
      "tags": ["new"],
    },
    {
      "nameAr": "وشاح صوف منسوج يدوياً",
      "nameEn": "Hand-Woven Wool Scarf",
      "price": 22.0,
      "rating": "4.6",
      "icon": Icons.checkroom_outlined,
      "tags": ["recommended"],
    },
    {
      "nameAr": "طبق خزفي مرسوم",
      "nameEn": "Hand-Painted Ceramic Plate",
      "price": 40.0,
      "rating": "4.9",
      "icon": Icons.local_cafe_outlined,
      "tags": ["popular", "new"],
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    const tags = ['popular', 'new', 'recommended'];
    final activeTag = tags[productTabIndex];
    return products
        .where((p) => (p["tags"] as List).contains(activeTag))
        .toList();
  }

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
                      ? const Color(0xFF0D1420).withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: cardBorderColor, width: 1.5),
                ),
                child: Directionality(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
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
                          hintStyle: TextStyle(
                            color: secondaryTextColor.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.white10
                              : Colors.black12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4A017),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Estimated Price Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(
                              0xFFD4A017,
                            ).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFD4A017),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic
                                        ? "السعر الموصى به"
                                        : "Recommended Price Range",
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isArabic
                                        ? "45 - 60 دينار أردني"
                                        : "45 - 60 JOD",
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
                            colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
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

  // Open Advanced Search / Filters Bottom Sheet
  void _openAdvancedSearch() {
    // Local copies so changes only apply when the user taps "Apply"
    Set<int> tempCategories = {...advancedCategoryFilters};
    RangeValues tempPriceRange = priceRange;
    double tempMinRating = minRating;
    String tempSortBy = sortBy;

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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: sheetBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: cardBorderColor, width: 1.5),
                ),
                child: Directionality(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? "تصفية متقدمة" : "Advanced Filters",
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
                        const SizedBox(height: 20),

                        // Categories (multi-select)
                        Text(
                          isArabic ? "الفئات" : "Categories",
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(categories.length, (index) {
                            if (index == 0) {
                              return const SizedBox.shrink(); // skip "All"
                            }
                            final cat = categories[index];
                            final selected = tempCategories.contains(index);
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (selected) {
                                    tempCategories.remove(index);
                                  } else {
                                    tempCategories.add(index);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFD4A017)
                                      : (isDarkMode
                                            ? Colors.white.withValues(
                                                alpha: 0.04,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.03,
                                              )),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFFD4A017)
                                        : cardBorderColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      cat["icon"],
                                      size: 15,
                                      color: selected
                                          ? Colors.black
                                          : (isDarkMode
                                                ? Colors.white70
                                                : Colors.black87),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isArabic
                                          ? cat["titleAr"]
                                          : cat["titleEn"],
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: selected
                                            ? Colors.black
                                            : (isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Price range
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? "نطاق السعر" : "Price Range",
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${tempPriceRange.start.round()} - ${tempPriceRange.end.round()} JOD",
                              style: const TextStyle(
                                color: Color(0xFFD4A017),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFFD4A017),
                            inactiveTrackColor: cardBorderColor,
                            thumbColor: const Color(0xFFD4A017),
                            overlayColor: const Color(
                              0xFFD4A017,
                            ).withValues(alpha: 0.15),
                          ),
                          child: RangeSlider(
                            min: 0,
                            max: 300,
                            divisions: 60,
                            values: tempPriceRange,
                            onChanged: (values) {
                              setModalState(() {
                                tempPriceRange = values;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Minimum rating
                        Text(
                          isArabic ? "الحد الأدنى للتقييم" : "Minimum Rating",
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (i) {
                            final starValue = i + 1;
                            final filled = starValue <= tempMinRating;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempMinRating = (tempMinRating == starValue)
                                      ? 0
                                      : starValue.toDouble();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Icon(
                                  filled ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFF7B500),
                                  size: 28,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Sort by
                        Text(
                          isArabic ? "الترتيب حسب" : "Sort By",
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _sortChip(
                              tempSortBy,
                              'rating',
                              isArabic ? "الأعلى تقييماً" : "Top Rated",
                              setModalState,
                              (v) => tempSortBy = v,
                            ),
                            _sortChip(
                              tempSortBy,
                              'price_low',
                              isArabic ? "السعر: الأقل" : "Price: Low to High",
                              setModalState,
                              (v) => tempSortBy = v,
                            ),
                            _sortChip(
                              tempSortBy,
                              'price_high',
                              isArabic ? "السعر: الأعلى" : "Price: High to Low",
                              setModalState,
                              (v) => tempSortBy = v,
                            ),
                            _sortChip(
                              tempSortBy,
                              'newest',
                              isArabic ? "الأحدث" : "Newest",
                              setModalState,
                              (v) => tempSortBy = v,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: BorderSide(color: cardBorderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    tempCategories = {};
                                    tempPriceRange = const RangeValues(0, 200);
                                    tempMinRating = 0;
                                    tempSortBy = 'rating';
                                  });
                                },
                                child: Text(
                                  isArabic ? "إعادة تعيين" : "Reset",
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
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
                                    setState(() {
                                      advancedCategoryFilters = tempCategories;
                                      priceRange = tempPriceRange;
                                      minRating = tempMinRating;
                                      sortBy = tempSortBy;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    isArabic
                                        ? "تطبيق الفلاتر"
                                        : "Apply Filters",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
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
          },
        );
      },
    );
  }

  Widget _sortChip(
    String currentValue,
    String value,
    String label,
    void Function(void Function()) setModalState,
    void Function(String) onSelect,
  ) {
    final selected = currentValue == value;
    return GestureDetector(
      onTap: () => setModalState(() => onSelect(value)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFD4A017)
              : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFD4A017) : cardBorderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: selected
                ? Colors.black
                : (isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  int get activeFilterCount {
    int count = advancedCategoryFilters.length;
    if (priceRange.start != 0 || priceRange.end != 200) count++;
    if (minRating > 0) count++;
    if (sortBy != 'rating') count++;
    return count;
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
            border: Border.all(color: cardBorderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4A017).withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFD4A017),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isArabic ? "ميزة للأعضاء فقط" : "Members Only Feature",
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? "يرجى تسجيل الدخول للاستفادة من هذه الميزة والتواصل مع أمهر الحرفيين."
                    : "Please log in to use this feature and connect with the best craftsmen.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              // We just pop the modal. The user can go to the login screen by tapping the Profile tab.
              // Actually, since we are inside MainShell, we could just instruct them to go to Profile tab.
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A017),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    isArabic ? "حسناً، فهمت" : "Got it",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : Colors.white,
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

  // ── AI Gift Assistant ─────────────────────────────────────────────────────
  void _showGiftAssistant() {
    final TextEditingController giftController = TextEditingController();
    int step = 0;
    List<Map<String, String>> chatMessages = [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            if (step == 0 && chatMessages.isEmpty) {
              chatMessages.add({
                'sender': 'ai',
                'text': isArabic 
                    ? 'مرحباً! 🎁 أنا مساعدك الذكي لاختيار الهدايا.\n\nلمن تبحث عن هدية؟'
                    : 'Hello! 🎁 I\'m your AI Gift Assistant.\n\nWho are you looking for a gift for?',
              });
            }

            void sendMessage(String text) {
              if (text.trim().isEmpty) return;
              setModalState(() {
                chatMessages.add({'sender': 'user', 'text': text});
                giftController.clear();
                step++;
              });

              Future.delayed(const Duration(milliseconds: 800), () {
                if (!mounted) return;
                setModalState(() {
                  if (step == 1) {
                    chatMessages.add({
                      'sender': 'ai',
                      'text': isArabic
                          ? 'اختيار رائع! 💝 ما هي المناسبة؟ (عيد ميلاد، ذكرى زواج، تخرج، بدون مناسبة...)'
                          : 'Great choice! 💝 What\'s the occasion? (Birthday, Anniversary, Graduation, No occasion...)',
                    });
                  } else if (step == 2) {
                    chatMessages.add({
                      'sender': 'ai',
                      'text': isArabic
                          ? 'كم ميزانيتك التقريبية؟ (مثال: 20-50 دينار)'
                          : 'What\'s your approximate budget? (e.g. 20-50 JD)',
                    });
                  } else {
                    chatMessages.add({
                      'sender': 'ai',
                      'text': isArabic
                          ? '✨ بناءً على إجاباتك، إليك اقتراحاتي:\n\n🎨 سجادة صوفية مطرزة — 52 دينار\n🏺 إبريق فخاري تقليدي — 28 دينار\n💍 خاتم فضة مصنوع يدوياً — 35 دينار\n\nيمكنك تصفحها من القائمة الرئيسية!'
                          : '✨ Based on your answers, here are my suggestions:\n\n🎨 Embroidered Wool Rug — 52 JD\n🏺 Traditional Clay Pitcher — 28 JD\n💍 Handmade Silver Ring — 35 JD\n\nYou can browse them from the main feed!',
                    });
                  }
                });
              });
            }

            return Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: topButtonBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border.all(color: cardBorderColor),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard, color: Color(0xFFD4A017)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isArabic ? 'مساعد الهدايا الذكي' : 'AI Gift Assistant',
                              style: TextStyle(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: secondaryTextColor),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    ),

                    // Chat messages
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          final msg = chatMessages[index];
                          final isAI = msg['sender'] == 'ai';
                          return Align(
                            alignment: isAI
                                ? (isArabic ? Alignment.centerRight : Alignment.centerLeft)
                                : (isArabic ? Alignment.centerLeft : Alignment.centerRight),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isAI
                                    ? const Color(0xFFD4A017).withValues(alpha: 0.12)
                                    : (isDarkMode ? const Color(0xFF2A3444) : const Color(0xFFE8E8E8)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                msg['text']!,
                                style: TextStyle(color: primaryTextColor, fontSize: 14, height: 1.5),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Input
                    if (step < 3)
                      Container(
                        padding: EdgeInsets.only(
                          left: 16, right: 16, top: 12,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        ),
                        decoration: BoxDecoration(
                          color: topButtonBackground,
                          border: Border(top: BorderSide(color: cardBorderColor)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: giftController,
                                style: TextStyle(color: primaryTextColor),
                                decoration: InputDecoration(
                                  hintText: isArabic ? 'اكتب إجابتك...' : 'Type your answer...',
                                  hintStyle: TextStyle(color: secondaryTextColor),
                                  filled: true,
                                  fillColor: isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                onSubmitted: sendMessage,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: const Color(0xFFD4A017),
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Colors.black, size: 20),
                                onPressed: () => sendMessage(giftController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
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
        // Floating Action Buttons
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI Voice Assistant
            FloatingActionButton.small(
              heroTag: 'voice_ai',
              onPressed: widget.isGuest ? _showGuestPrompt : () => _showVoiceAssistant(context),
              backgroundColor: Colors.purpleAccent,
              child: const Icon(Icons.mic, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            // AI Gift Assistant
            FloatingActionButton.small(
              heroTag: 'gift_ai',
              onPressed: widget.isGuest ? _showGuestPrompt : _showGiftAssistant,
              backgroundColor: const Color(0xFF1C2431),
              child: const Icon(Icons.card_giftcard, color: Color(0xFFD4A017), size: 22),
            ),
            const SizedBox(height: 12),
            // Main FAB
            FloatingActionButton(
              heroTag: 'add_order',
              onPressed: widget.isGuest ? _showGuestPrompt : _openAIOrderCreator,
              backgroundColor: const Color(0xFFD4A017),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ],
        ),
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
                    // Top bar is handled by MainShell — nothing here.

                    // ── Hero Banner ────────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFF1A2840), Color(0xFF0D1420)],
                        ),
                        border: Border.all(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD4A017,
                            ).withValues(alpha: 0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFD4A017),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic
                                    ? "مرحباً بك في CraftGo"
                                    : "Welcome to CraftGo",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isArabic
                                ? "اكتشف فن الحرف اليدوية"
                                : "Discover Handcraft Art",
                            style: GoogleFonts.arefRuqaa(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic
                                ? "تواصل مع أمهر الحرفيين المحليين وفصّل ما تحلم به"
                                : "Connect with top local artisans and craft your dream piece",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              _buildHeroStat(
                                isArabic ? "500+" : "500+",
                                isArabic ? "حرفي" : "Artisans",
                              ),
                              const SizedBox(width: 20),
                              _buildHeroStat(
                                isArabic ? "20+" : "20+",
                                isArabic ? "حرفة" : "Crafts",
                              ),
                              const SizedBox(width: 20),
                              _buildHeroStat(
                                isArabic ? "98%" : "98%",
                                isArabic ? "رضا الزبائن" : "Satisfaction",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Header title
                    Text(
                      isArabic
                          ? "ابحث عن الفن الجميل"
                          : "Explore Beautiful Craft",
                      style: GoogleFonts.arefRuqaa(
                        color: primaryTextColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isArabic
                          ? "تواصل مع أمهر الحرفيين في منطقتك"
                          : "Connect with the finest local craftsmen",
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search Bar + Advanced Filter Button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: cardBorderColor,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              style: TextStyle(color: primaryTextColor),
                              decoration: InputDecoration(
                                hintText: isArabic
                                    ? "ابحث عن حرفة أو حرفي..."
                                    : "Search for a craft or craftsman...",
                                hintStyle: TextStyle(
                                  color: secondaryTextColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: secondaryTextColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.purpleAccent),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(isArabic ? 'جاري فتح الكاميرا للبحث بالصور 📷' : 'Opening camera for visual search 📷', style: GoogleFonts.cairo()), backgroundColor: Colors.purpleAccent),
                                    );
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onSubmitted: (query) {
                                if (query.trim().isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SearchResultsScreen(
                                        isArabic: isArabic,
                                        isDarkMode: isDarkMode,
                                        query: query.trim(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Advanced search / filter button with a badge showing active filter count
                        GestureDetector(
                          onTap: _openAdvancedSearch,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: activeFilterCount > 0
                                      ? const Color(0xFFD4A017)
                                      : (isDarkMode
                                            ? Colors.white.withValues(
                                                alpha: 0.04,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.02,
                                              )),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: activeFilterCount > 0
                                        ? const Color(0xFFD4A017)
                                        : cardBorderColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.tune,
                                  color: activeFilterCount > 0
                                      ? Colors.black
                                      : topIconColor,
                                ),
                              ),
                              if (activeFilterCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      "$activeFilterCount",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Stories Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? "القصص" : "Stories",
                          style: GoogleFonts.cairo(
                            color: primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isArabic ? "قصصي" : "My Stories",
                          style: GoogleFonts.cairo(
                            color: Colors.purpleAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildLiveStoryCircle(),
                          _buildStoryCircle(
                            imageUrl: "assets/images/user3.jpg",
                            name: "User 3",
                            isAdd: false,
                          ),
                          _buildStoryCircle(
                            imageUrl: "assets/images/user2.jpg",
                            name: "User 2",
                            isAdd: false,
                          ),
                          _buildStoryCircle(
                            imageUrl: "assets/images/user1.jpg",
                            name: "User 1",
                            isAdd: false,
                          ),
                          _buildStoryCircle(
                            imageUrl: "assets/images/bayan.jpg",
                            name: "Bayan",
                            isAdd: false,
                          ),
                          _buildStoryCircle(
                            imageUrl: "",
                            name: isArabic ? "استكشف +" : "Explore +",
                            isAdd: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Circular Categories Row
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected =
                              selectedFilterIndex == index ||
                              (selectedFilterIndex == null && index == 0);
                          return GestureDetector(
                            onTap: () => setState(() {
                              selectedFilterIndex = index == 0 ? null : index;
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(left: 14),
                              child: Column(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(0xFFD4A017)
                                          : (isDarkMode
                                                ? Colors.white.withValues(
                                                    alpha: 0.07,
                                                  )
                                                : Colors.white),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFD4A017)
                                            : cardBorderColor,
                                        width: 1.5,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFD4A017,
                                                ).withValues(alpha: 0.3),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Icon(
                                      cat["icon"],
                                      size: 24,
                                      color: isSelected
                                          ? Colors.black
                                          : (isDarkMode
                                                ? Colors.white70
                                                : Colors.black54),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isArabic ? cat["titleAr"] : cat["titleEn"],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFFD4A017)
                                          : secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                      height: 255,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: craftsmen.length,
                          itemBuilder: (context, index) {
                            final maker = craftsmen[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArtisanProfilePage(
                                    artisan: maker,
                                    isArabic: isArabic,
                                    isDarkMode: isDarkMode,
                                    isGuest: widget.isGuest,
                                  ),
                                ),
                              ),
                              child: _buildCraftsmanCard(
                                name: isArabic
                                    ? maker["nameAr"]
                                    : maker["nameEn"],
                                craft: isArabic
                                    ? maker["craftAr"]
                                    : maker["craftEn"],
                                rating: maker["rating"],
                                jobs: maker["jobs"],
                                imagePath: maker["image"],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Section 2: Products (Popular / New / Recommended)
                    Text(
                      isArabic ? "المنتجات" : "Products",
                      style: GoogleFonts.arefRuqaa(
                        color: primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Tab switcher
                    Row(
                      children: [
                        _buildProductTab(
                          0,
                          isArabic ? "الأكثر طلباً" : "Popular",
                        ),
                        const SizedBox(width: 10),
                        _buildProductTab(1, isArabic ? "جديد" : "New"),
                        const SizedBox(width: 10),
                        _buildProductTab(
                          2,
                          isArabic ? "موصى به" : "Recommended",
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Product grid — wrapped in a non-scrollable GridView since the
                    // parent is already a SingleChildScrollView (lets the whole
                    // page, search bar and all, scroll together).
                    // Product list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsPage(
                                product: product,
                                isArabic: isArabic,
                                isDarkMode: isDarkMode,
                                isGuest: widget.isGuest,
                              ),
                            ),
                          ),
                          child: _buildProductCard(product),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductTab(int index, String title) {
    final isSelected = productTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => productTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4A017)
              : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.02)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4A017) : cardBorderColor,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.black
                : (isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD4A017),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Image
          Stack(
            children: [
              Container(
                width: 140,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A017).withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    product["icon"],
                    size: 40,
                    color: const Color(0xFFD4A017),
                  ),
                ),
              ),
              // Discount Tag
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE88A74), // Orange-ish red from Figma
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "15% OFF",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          
          // Right side: Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artisan info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const AssetImage('assets/images/user1.jpg'), // Mock
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "rafa",
                            style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Artisan",
                            style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Product Name & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? product["nameAr"] : product["nameEn"],
                              style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isArabic ? "حرفة يدوية" : "Handmade craft",
                              style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${(product["price"] * 1.15).toStringAsFixed(0)} JOD",
                            style: const TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            "${product["price"].toStringAsFixed(0)} JOD",
                            style: const TextStyle(color: Color(0xFFE88A74), fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags (COLOR: RED)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: isDarkMode ? Colors.white12 : Colors.black.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      isArabic ? "اللون: أحمر" : "COLOR: RED",
                      style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Actions row (Likes, Comments, Bookmark, Share)
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 4),
                      Text("4", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          _showComments();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline, color: secondaryTextColor, size: 16),
                            const SizedBox(width: 4),
                            Text("12", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.bookmark, color: const Color(0xFFE88A74), size: 18),
                      const SizedBox(width: 12),
                      Icon(Icons.share, color: secondaryTextColor, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE88A74),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        isArabic ? "أضف للسلة" : "Add to cart",
                        style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.02)),
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
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with rounded top corners
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
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
                        const Icon(
                          Icons.star,
                          color: Color(0xFFF7B500),
                          size: 14,
                        ),
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
                      style: TextStyle(color: secondaryTextColor, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 24, left: 24, right: 24,
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0D1420).withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: cardBorderColor, width: 1.5),
            ),
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? "التعليقات (12)" : "Comments (12)",
                        style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: secondaryTextColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildCommentRow(
                          "User 1",
                          "8 days ago",
                          isArabic ? "منتج رائع جداً، هل يتوفر لون أزرق؟" : "Nice product, is it available in blue?",
                          true,
                        ),
                        // Mock Smart Reply AI block
                        if (!widget.isGuest)
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 16, right: 40),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      isArabic ? "الرد الذكي (AI)" : "Smart Reply (AI)",
                                      style: GoogleFonts.cairo(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isArabic ? "نعم يتوفر لون أزرق، يمكنك طلبه من خيارات الألوان." : "Yes blue is available, you can choose it from the colors option.",
                                  style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      minimumSize: const Size(60, 26),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(isArabic ? "إرسال" : "Send", style: const TextStyle(color: Colors.white, fontSize: 10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        _buildCommentRow(
                          "rafa",
                          "7 days ago",
                          isArabic ? "شكراً لك 🤍" : "Thank you 🤍",
                          false,
                        ),
                        // Hidden Comment Example
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.security, color: Colors.grey, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? "تم إخفاء هذا التعليق بواسطة الـ AI لمخالفته الشروط." : "Comment hidden by AI for violating rules.",
                                style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(radius: 18, backgroundColor: const Color(0xFFD4A017), child: const Text("U", style: TextStyle(color: Colors.white))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: isArabic ? "اكتب تعليقاً..." : "Write a comment...",
                            hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
                            filled: true,
                            fillColor: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            suffixIcon: const Icon(Icons.send, color: Color(0xFFE88A74), size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentRow(String user, String time, String text, bool canReply) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Text(user[0].toUpperCase(), style: const TextStyle(color: Colors.black54, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user, style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time, style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(text, style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 13)),
                if (canReply)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      isArabic ? "رد" : "Reply",
                      style: GoogleFonts.cairo(color: const Color(0xFFE88A74), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.favorite_border, color: Colors.grey, size: 14),
        ],
      ),
    );
  }

  void _showStoryViewer(String name, String imageUrl, bool isAdd) {
    if (isAdd) {
      _showStoryCreatorSheet();
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Story Background (mocked as dark container with image)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  image: imageUrl.isNotEmpty ? DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.darken)) : null,
                ),
                child: Center(
                  child: Text(
                    isArabic ? "قصة من $name" : "Story by $name",
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Close Button
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // AI Shoppable Product Link
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.checkroom, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isArabic ? "اكتشفه الذكاء الاصطناعي 🤖" : "AI Detected Product 🤖",
                              style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isArabic ? "حقيبة جلدية مطرزة" : "Embroidered Leather Bag",
                              style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "45.0 JOD",
                              style: GoogleFonts.cairo(color: const Color(0xFFD4A017), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE88A74),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(isArabic ? "شراء" : "Buy", style: GoogleFonts.cairo(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStoryCreatorSheet() {
    int selectedType = 0; // 0=product, 1=offer, 2=behind scenes
    bool captionGenerated = false;
    final List<String> typeLabelsAr = ['منتج جديد', 'عرض خاص', 'وراء الكواليس'];
    final List<String> typeLabelsEn = ['New Product', 'Special Offer', 'Behind the Scenes'];
    final List<IconData> typeIcons = [Icons.inventory_2_outlined, Icons.local_offer_outlined, Icons.videocam_outlined];
    final List<String> aiCaptionsAr = [
      '✨ أطلّت بإبداع جديد! هذا المنتج اليدوي نُسِج بحب وشغف، ليحمل قصة فريدة بين يديك. 🧵 #حرف_يدوية #صنع_بحب',
      '🔥 عرض لا يُفوّت! احجز الآن واستمتع بخصم رائع على أجمل منتجاتنا اليدوية المميزة ✂️ #عروض #خصومات',
      '🎬 وراء كل تحفة فنية، جهد وإبداع. هذه لمحة من عملي اليومي لأقدم لكم أجمل ما صنعته يداي 🤲 #خلف_الكواليس',
    ];
    final List<String> aiCaptionsEn = [
      '✨ A new creation just dropped! This handcrafted piece was made with love and passion 🧵 #handmade #craftwork',
      '🔥 Limited time offer! Grab amazing deals on our finest handmade products ✂️ #sale #deals',
      '🎬 Behind every masterpiece is hard work. Here is a peek into my daily creative process 🤲 #behindthescenes',
    ];
    final List<String> bestTimesAr = ['6:00 - 8:00 م (أعلى تفاعل)', '12:00 - 1:00 م', '9:00 - 10:00 ص'];
    final List<String> bestTimesEn = ['6:00 - 8:00 PM (Peak engagement)', '12:00 - 1:00 PM', '9:00 - 10:00 AM'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  top: 24, left: 24, right: 24,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF0D1420).withValues(alpha: 0.97) : Colors.white.withValues(alpha: 0.97),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(color: cardBorderColor),
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isArabic ? 'منشئ القصص الذكي' : 'AI Story Creator',
                                style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: secondaryTextColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Story Type Selector
                      Text(
                        isArabic ? 'نوع القصة' : 'Story Type',
                        style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(3, (i) {
                          final sel = selectedType == i;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() { selectedType = i; captionGenerated = false; }),
                              child: Container(
                                margin: EdgeInsets.only(left: i > 0 ? 8 : 0),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: sel ? Colors.purpleAccent.withValues(alpha: 0.15) : (isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: sel ? Colors.purpleAccent : cardBorderColor),
                                ),
                                child: Column(
                                  children: [
                                    Icon(typeIcons[i], color: sel ? Colors.purpleAccent : secondaryTextColor, size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      isArabic ? typeLabelsAr[i] : typeLabelsEn[i],
                                      style: GoogleFonts.cairo(color: sel ? Colors.purpleAccent : secondaryTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      // AI Caption Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => setModalState(() => captionGenerated = true),
                          icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                          label: Text(
                            isArabic ? 'اكتب لي النص بالذكاء الاصطناعي 🤖' : 'Generate AI Caption 🤖',
                            style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      if (captionGenerated) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    isArabic ? 'النص المقترح' : 'AI Suggested Caption',
                                    style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isArabic ? aiCaptionsAr[selectedType] : aiCaptionsEn[selectedType],
                                style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A017).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule, color: Color(0xFFD4A017), size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic ? '⏰ أفضل وقت للنشر اليوم' : '⏰ Best Time to Post Today',
                                      style: GoogleFonts.cairo(color: const Color(0xFFD4A017), fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      isArabic ? bestTimesAr[selectedType] : bestTimesEn[selectedType],
                                      style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isArabic ? '✅ تم نشر القصة بنجاح!' : '✅ Story published successfully!', style: GoogleFonts.cairo()),
                                  backgroundColor: Colors.purpleAccent,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE88A74),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                              isArabic ? 'نشر القصة الآن 🚀' : 'Publish Story Now 🚀',
                              style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStoryCircle({required String imageUrl, required String name, required bool isAdd}) {
    return GestureDetector(
      onTap: () {
        _showStoryViewer(name, imageUrl, isAdd);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isAdd ? const Color(0xFFE88A74) : Colors.purpleAccent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: isAdd
                    ? Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE88A74).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Color(0xFFE88A74), size: 28),
                      )
                    : CircleAvatar(
                        backgroundImage: imageUrl.isNotEmpty ? AssetImage(imageUrl) : null,
                        backgroundColor: Colors.grey.shade300,
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                color: isAdd ? const Color(0xFFE88A74) : secondaryTextColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStoryCircle() {
    return GestureDetector(
      onTap: () => _showLiveCommerceViewer(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.redAccent, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.redAccent.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/user1.jpg'),
                  backgroundColor: Colors.grey.shade300,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                      child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isArabic ? 'أمجد الخطيب' : 'Amjad',
              style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showLiveCommerceViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              // Fake live video background
              Positioned.fill(
                child: Image.asset('assets/images/plate.jpg', fit: BoxFit.cover, color: Colors.black45, colorBlendMode: BlendMode.darken),
              ),
              // Top Bar
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: const AssetImage('assets/images/user1.jpg'), radius: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أمجد الخطيب', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                          child: const Row(
                            children: [
                              Icon(Icons.visibility, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('1,204', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              // Product Overlay
              Positioned(
                bottom: 120,
                right: 20,
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Image.asset('assets/images/plate.jpg', height: 80, fit: BoxFit.cover),
                      const SizedBox(height: 4),
                      Text('طقم خشبي', style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('45 JOD', style: const TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A017),
                          minimumSize: const Size(double.infinity, 30),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(isArabic ? 'شراء' : 'Buy', style: GoogleFonts.cairo(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              // Chat Fake
              Positioned(
                bottom: 20,
                left: 20,
                right: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سارة: هل يتوفر بلون آخر؟', style: GoogleFonts.cairo(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('أحمد: عمل رائع!', style: GoogleFonts.cairo(color: Colors.white)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: Text(isArabic ? 'اكتب تعليقاً...' : 'Add a comment...', style: GoogleFonts.cairo(color: Colors.white54)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVoiceAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: sheetBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: cardBorderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent.withValues(alpha: 0.1),
                  boxShadow: [BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Icon(Icons.mic, color: Colors.purpleAccent, size: 60),
              ),
              const SizedBox(height: 30),
              Text(
                isArabic ? 'أنا أستمع...' : 'I am listening...',
                style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                isArabic ? 'جرب أن تقول: "أبحث عن وشاح أحمر هدية لأمي"' : 'Try saying: "I am looking for a red scarf for my mother"',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 14),
              ),
              const SizedBox(height: 30),
              // Animated waveform
              const _AnimatedWaveform(),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedWaveform extends StatefulWidget {
  const _AnimatedWaveform();

  @override
  State<_AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<_AnimatedWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(15, (index) {
            final factor = (index % 3 == 0) ? 0.6 : (index % 2 == 0 ? 0.3 : 1.0);
            final currentHeight = 10.0 + (25.0 * _controller.value * factor);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: currentHeight,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
