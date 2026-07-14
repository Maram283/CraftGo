// lib/features/artisan/screens/craftsman_offers_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_order/artisan_templates_screen.dart';
import 'add_product_screen.dart';
import '../hire_order/create_job_screen.dart';

class CraftsmanOffersScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String artisanId;

  const CraftsmanOffersScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.artisanId,
  });

  @override
  State<CraftsmanOffersScreen> createState() => _CraftsmanOffersScreenState();
}

class _CraftsmanOffersScreenState extends State<CraftsmanOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for ready-made products
  List<Map<String, dynamic>> _products = [
    {
      'id': 'p1',
      'titleAr': 'طقم أواني فخارية',
      'titleEn': 'Clay Pot Set',
      'price': 45,
      'isPublic': true,
      'image': null,
    },
    {
      'id': 'p2',
      'titleAr': 'لوحة سيراميك مزخرفة',
      'titleEn': 'Decorated Ceramic Plate',
      'price': 30,
      'isPublic': false,
      'image': null,
    },
  ];

  // Mock data for hire enablement
  bool _hireEnabled = true;

  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get border => widget.isDarkMode ? Colors.white12 : Colors.black12;
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(
          isArabic: widget.isArabic,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
    if (result == true) {
      // In real app, refresh list
      setState(() {
        _products.add({
          'id': 'p${DateTime.now().millisecondsSinceEpoch}',
          'titleAr': 'منتج جديد',
          'titleEn': 'New Product',
          'price': 0,
          'isPublic': true,
          'image': null,
        });
      });
    }
  }

  void _toggleProductVisibility(int index) {
    setState(() {
      _products[index]['isPublic'] = !_products[index]['isPublic'];
    });
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text(t('حذف المنتج', 'Delete Product'), style: TextStyle(color: text)),
        content: Text(t('هل أنت متأكد؟', 'Are you sure?'), style: TextStyle(color: dim)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: dim))),
          TextButton(
            onPressed: () {
              setState(() => _products.removeAt(index));
              Navigator.pop(ctx);
            },
            child: Text(t('حذف', 'Delete'), style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          title: Text(
            t('عروضي', 'My Offers'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: dim,
            indicatorColor: accent,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: t('جاهز', 'Ready-Made')),
              Tab(text: t('طلبات مخصصة', 'Custom Orders')),
              Tab(text: t('عمل في الموقع', 'Hire/On-Site')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 0: Ready-Made Products
            _buildReadyMadeTab(),
            // Tab 1: Custom Order Templates (reuse ArtisanTemplatesScreen)
            ArtisanTemplatesScreen(
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
              artisanId: widget.artisanId,
            ),
            // Tab 2: Hire/On-Site management
            _buildHireTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyMadeTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  t('منتجاتك الجاهزة للبيع', 'Your ready-made products'),
                  style: GoogleFonts.cairo(color: dim, fontSize: 14),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addProduct,
                icon: Icon(Icons.add, color: Colors.black),
                label: Text(t('إضافة منتج', 'Add Product'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _products.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 60, color: dim),
                const SizedBox(height: 16),
                Text(t('لا توجد منتجات', 'No products yet'), style: TextStyle(color: dim)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _products.length,
            itemBuilder: (ctx, i) {
              final p = _products[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.image, color: dim),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isArabic ? p['titleAr'] : p['titleEn'],
                            style: TextStyle(color: text, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${p['price']} JOD',
                            style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(
                                p['isPublic'] ? Icons.visibility : Icons.visibility_off,
                                size: 14,
                                color: p['isPublic'] ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p['isPublic'] ? t('عام', 'Public') : t('خاص', 'Private'),
                                style: TextStyle(color: p['isPublic'] ? Colors.green : Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: dim),
                      onPressed: () {
                        // TODO: edit product
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        p['isPublic'] ? Icons.visibility : Icons.visibility_off,
                        color: p['isPublic'] ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => _toggleProductVisibility(i),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteProduct(i),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHireTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enable/disable hire
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('تفعيل طلبات العمل في الموقع', 'Enable On-Site Hire'),
                      style: TextStyle(color: text, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      t('سيتمكن الزبائن من طلب خدماتك في موقعهم', 'Customers can request your services at their location'),
                      style: TextStyle(color: dim, fontSize: 12),
                    ),
                  ],
                ),
                Switch(
                  value: _hireEnabled,
                  onChanged: (v) => setState(() => _hireEnabled = v),
                  activeColor: accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_hireEnabled) ...[
            Text(
              t('طلبات واردة', 'Incoming Hire Requests'),
              style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Placeholder – in real app, show a list from HireOrderProvider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Icon(Icons.handshake_outlined, color: accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t('لا توجد طلبات واردة حالياً', 'No incoming hire requests'),
                      style: TextStyle(color: dim),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}