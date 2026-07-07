import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_detail_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const MyOrdersScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  // Theme colors
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      widget.isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      widget.isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);

  Color get surfaceColor =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  // Mock data for cart
  List<Map<String, dynamic>> get cartItems => [
    {
      'id': 'c1',
      'nameAr': 'سجادة صوفية مطرزة',
      'nameEn': 'Embroidered Wool Rug',
      'price': 52.0,
      'quantity': 1,
      'image': Icons.checkroom_outlined,
      'artisan': 'أمجد الخطيب',
    },
    {
      'id': 'c2',
      'nameAr': 'إبريق فخاري تقليدي',
      'nameEn': 'Traditional Clay Pitcher',
      'price': 28.0,
      'quantity': 2,
      'image': Icons.local_cafe_outlined,
      'artisan': 'إياد الكردي',
    },
  ];

  // Mock pending orders
  List<Map<String, dynamic>> get pendingOrders => [
    {
      'id': 'o1',
      'nameAr': 'خاتم فضة مصنوع يدوياً',
      'nameEn': 'Handmade Silver Ring',
      'price': 35.0,
      'status': t('قيد التصنيع', 'In Progress'),
      'date': '2026-07-10',
      'artisan': 'فاطمة محمود',
    },
    {
      'id': 'o2',
      'nameAr': 'صندوق خشبي محفور',
      'nameEn': 'Carved Wooden Box',
      'price': 60.0,
      'status': t('قيد التسليم', 'Shipping'),
      'date': '2026-07-12',
      'artisan': 'أمجد الخطيب',
    },
  ];

  // Mock order history
  List<Map<String, dynamic>> get orderHistory => [
    {
      'id': 'h1',
      'nameAr': 'طبق خزفي مرسوم',
      'nameEn': 'Hand-Painted Ceramic Plate',
      'price': 40.0,
      'status': t('تم التسليم', 'Delivered'),
      'date': '2026-06-28',
      'artisan': 'إياد الكردي',
    },
    {
      'id': 'h2',
      'nameAr': 'وشاح صوف منسوج يدوياً',
      'nameEn': 'Hand-Woven Wool Scarf',
      'price': 22.0,
      'status': t('تم الإلغاء', 'Cancelled'),
      'date': '2026-06-20',
      'artisan': 'فاطمة محمود',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          t('طلباتي', 'My Orders'),
          style: GoogleFonts.arefRuqaa(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: accent,
          labelColor: accent,
          unselectedLabelColor: secondaryTextColor,
          tabs: [
            Tab(text: t('السلة', 'Cart')),
            Tab(text: t('قيد التنفيذ', 'Pending')),
            Tab(text: t('السجل', 'History')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Cart tab
          _buildCartTab(),
          // Pending orders
          _buildOrderList(pendingOrders, isPending: true),
          // Order history
          _buildOrderList(orderHistory, isPending: false),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: secondaryTextColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              t('سلة التسوق فارغة', 'Your cart is empty'),
              style: TextStyle(color: secondaryTextColor, fontSize: 16),
            ),
          ],
        ),
      );
    }

    double total = cartItems.fold(0, (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int));

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (_, index) {
              final item = cartItems[index];
              return _CartItemCard(
                item: item,
                isArabic: widget.isArabic,
                isDarkMode: widget.isDarkMode,
                onRemove: () {
                  setState(() {
                    cartItems.removeAt(index);
                  });
                },
                onQuantityChanged: (newQty) {
                  setState(() {
                    cartItems[index]['quantity'] = newQty;
                  });
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(top: BorderSide(color: cardBorderColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('المجموع', 'Total'),
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} JOD',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
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
                    // Proceed to checkout
                  },
                  child: Text(
                    t('إتمام الشراء', 'Checkout'),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, {required bool isPending}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Icons.hourglass_empty : Icons.history,
              size: 64,
              color: secondaryTextColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isPending
                  ? t('لا توجد طلبات معلقة', 'No pending orders')
                  : t('لا توجد طلبات سابقة', 'No order history'),
              style: TextStyle(color: secondaryTextColor, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, index) {
        final order = orders[index];
        return _OrderCard(
          order: order,
          isArabic: widget.isArabic,
          isDarkMode: widget.isDarkMode,
          isPending: isPending,
        );
      },
    );
  }
}

// ── Cart Item Card ──────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.isArabic,
    required this.isDarkMode,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['image'], size: 30, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? item['nameAr'] : item['nameEn'],
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item['artisan'] ?? '',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item['price'].toStringAsFixed(2)} JOD',
                      style: TextStyle(
                        color: accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Quantity control
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 16, color: primaryText),
                            onPressed: () {
                              int qty = item['quantity'];
                              if (qty > 1) onQuantityChanged(qty - 1);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          ),
                          Text(
                            '${item['quantity']}',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 16, color: primaryText),
                            onPressed: () {
                              int qty = item['quantity'];
                              onQuantityChanged(qty + 1);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

// ── Order Card ──────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isArabic;
  final bool isDarkMode;
  final bool isPending;

  const _OrderCard({
    required this.order,
    required this.isArabic,
    required this.isDarkMode,
    required this.isPending,
  });

  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final statusColor = isPending ? accent : (order['status'] == t('تم التسليم', 'Delivered') ? Colors.green : Colors.redAccent);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(
              isArabic: isArabic,
              isDarkMode: isDarkMode,
              order: order,
            ),
          ),
        );
      },
      child: Container(
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long, size: 24, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? order['nameAr'] : order['nameEn'],
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${order['artisan']} • ${order['date']}',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${order['price'].toStringAsFixed(2)} JOD',
                      style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPending)
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 16, color: secondaryText),
              onPressed: () {
                // Navigate to order tracking
              },
            ),
        ],
      ),
    ));
  }
}
