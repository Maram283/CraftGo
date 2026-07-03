import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_details_page.dart';

class SearchResultsScreen extends StatelessWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.query,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
    final surface = isDarkMode ? const Color(0xFF1C2431) : Colors.white;
    final text = isDarkMode ? Colors.white : Colors.black87;
    final dim = isDarkMode ? Colors.white60 : Colors.black54;
    final border = isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
    final accent = const Color(0xFFD4A017);

    // Mock search results
    final List<Map<String, dynamic>> results = [
      {
        "nameAr": "سجادة صوفية مطرزة",
        "nameEn": "Embroidered Wool Rug",
        "price": 52.0,
        "rating": "4.9",
        "icon": Icons.checkroom_outlined,
        "craftsmanAr": "منى حداد",
        "craftsmanEn": "Mona Haddad",
      },
      {
        "nameAr": "إبريق فخاري تقليدي",
        "nameEn": "Traditional Clay Pitcher",
        "price": 28.0,
        "rating": "4.7",
        "icon": Icons.local_cafe_outlined,
        "craftsmanAr": "أحمد فخوري",
        "craftsmanEn": "Ahmed Fakhouri",
      },
      {
        "nameAr": "وشاح صوف منسوج يدوياً",
        "nameEn": "Hand-Woven Wool Scarf",
        "price": 22.0,
        "rating": "4.6",
        "icon": Icons.checkroom_outlined,
        "craftsmanAr": "سارة ناصر",
        "craftsmanEn": "Sara Naser",
      },
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '${t("نتائج البحث عن", "Results for")} "$query"',
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final p = results[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      product: p,
                      isArabic: isArabic,
                      isDarkMode: isDarkMode,
                      isGuest: false,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(p["icon"], color: accent, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t(p["nameAr"], p["nameEn"]),
                            style: GoogleFonts.cairo(
                              color: text,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, size: 14, color: dim),
                              const SizedBox(width: 4),
                              Text(
                                t(p["craftsmanAr"], p["craftsmanEn"]),
                                style: GoogleFonts.cairo(color: dim, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${p["price"]} JD',
                                style: GoogleFonts.cairo(
                                  color: accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    p["rating"],
                                    style: GoogleFonts.cairo(
                                      color: text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
