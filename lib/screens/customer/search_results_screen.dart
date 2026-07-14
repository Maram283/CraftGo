import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_details_page.dart';

class SearchResultsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.query,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _aiModeActive = false;

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
    final surface = widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
    final text = widget.isDarkMode ? Colors.white : Colors.black87;
    final dim = widget.isDarkMode ? Colors.white60 : Colors.black54;
    final border = widget.isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
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
      {
        "nameAr": "طوق مزخرف بالفضة",
        "nameEn": "Silver Embellished Necklace",
        "price": 45.0,
        "rating": "4.8",
        "icon": Icons.watch_outlined,
        "craftsmanAr": "نور عبد الرحمن",
        "craftsmanEn": "Nour Abdel Rahman",
      }
    ];

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
            '${t("نتائج البحث عن", "Results for")} "${widget.query}"',
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.auto_awesome, color: _aiModeActive ? Colors.purpleAccent : dim),
              onPressed: () {
                setState(() {
                  _aiModeActive = !_aiModeActive;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (_aiModeActive)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purpleAccent.withValues(alpha: 0.1),
                      Colors.purpleAccent.withValues(alpha: 0.05),
                    ]
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t('الذكاء الاصطناعي يفهم: "${widget.query}" ويقترح منتجات مشابهة 🤖', 'AI understands "${widget.query}" and suggests similar products 🤖'),
                        style: GoogleFonts.cairo(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: _aiModeActive ? 0 : 20),
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
                            isArabic: widget.isArabic,
                            isDarkMode: widget.isDarkMode,
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
                      child: Stack(
                        children: [
                          Row(
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
                                    if (_aiModeActive)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: Text(
                                          t('لأنك بحثت عن منتجات مصنوعة يدوياً', 'Because you searched for handmade products'),
                                          style: GoogleFonts.cairo(color: dim, fontSize: 10, fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    else
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
                          if (_aiModeActive)
                            Positioned(
                              top: 0,
                              right: widget.isArabic ? null : 0,
                              left: widget.isArabic ? 0 : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  t('🤖 AI اقترح', '🤖 AI Pick'),
                                  style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
