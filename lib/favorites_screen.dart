import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FavoritesScreen — المفضلة
// ─────────────────────────────────────────────────────────────────────────────

class FavoritesScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const FavoritesScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Craftsmen
  final List<Map<String, dynamic>> _craftsmen = [
    {
      'id': '1',
      'name': 'محمد الحرفي',
      'categoryAr': 'نجار ممتاز',
      'categoryEn': 'Excellent Carpenter',
      'rating': 4.9,
      'jobs': 124,
      'avatar': 'assets/carpenter.png',
    },
    {
      'id': '2',
      'name': 'سالم النحاس',
      'categoryAr': 'حرفي نحاسيات',
      'categoryEn': 'Copper Artisan',
      'rating': 4.8,
      'jobs': 89,
      'avatar': 'assets/copper.png',
    },
  ];

  // Mock Products
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'p1',
      'nameAr': 'طاولة خشبية يدوية',
      'nameEn': 'Handmade Wooden Table',
      'craftsman': 'محمد الحرفي',
      'price': 120.0,
      'rating': 4.9,
    },
    {
      'id': 'p2',
      'nameAr': 'مصباح نحاسي تقليدي',
      'nameEn': 'Traditional Copper Lamp',
      'craftsman': 'سالم النحاس',
      'price': 45.0,
      'rating': 4.7,
    },
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removeCraftsman(int index) {
    setState(() {
      _craftsmen.removeAt(index);
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
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
            t('المفضلة', 'My Favorites'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: accent,
            labelColor: accent,
            unselectedLabelColor: dim,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: t('الحرفيين', 'Craftsmen')),
              Tab(text: t('المنتجات', 'Products')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCraftsmenList(),
            _buildProductsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftsmenList() {
    if (_craftsmen.isEmpty) {
      return _buildEmptyState(t('لا يوجد حرفيين مفضلين حالياً', 'No favorite craftsmen yet.'));
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _craftsmen.length,
      itemBuilder: (context, index) {
        final c = _craftsmen[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: accent.withValues(alpha: 0.15),
                child: Icon(Icons.person, color: accent, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['name'],
                      style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      t(c['categoryAr'], c['categoryEn']),
                      style: GoogleFonts.cairo(color: dim, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${c['rating']}',
                          style: GoogleFonts.cairo(color: text, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${c['jobs']} ${t('عمل', 'jobs')})',
                          style: GoogleFonts.cairo(color: dim, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                onPressed: () => _removeCraftsman(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsList() {
    if (_products.isEmpty) {
      return _buildEmptyState(t('لا يوجد منتجات مفضلة حالياً', 'No favorite products yet.'));
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final p = _products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: accent, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(p['nameAr'], p['nameEn']),
                      style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      t('صنع بواسطة ${p['craftsman']}', 'By ${p['craftsman']}'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${p['price']} JD',
                          style: GoogleFonts.cairo(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            Text('${p['rating']}', style: GoogleFonts.cairo(color: dim, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                onPressed: () => _removeProduct(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: border,
            ),
            child: Icon(Icons.favorite_border, size: 60, color: dim),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: dim, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
