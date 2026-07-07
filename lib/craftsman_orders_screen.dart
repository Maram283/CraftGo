import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CraftsmanOrdersScreen — إدارة الطلبات الواردة للحرفي
// Tabs: جديد / قيد التنفيذ / مكتمل / ملغى
// ─────────────────────────────────────────────────────────────────────────────

class CraftsmanOrdersScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const CraftsmanOrdersScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<CraftsmanOrdersScreen> createState() => _CraftsmanOrdersScreenState();
}

class _CraftsmanOrdersScreenState extends State<CraftsmanOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Colors ──────────────────────────────────────────────────────────────────
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.10)
      : Colors.black.withValues(alpha: 0.08);
  Color get accent => widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  /// Convert English digits to Eastern Arabic digits when isArabic is true
  String localizeNumber(String value) {
    if (!widget.isArabic) return value;
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const ar = ['\u0660','\u0661','\u0662','\u0663','\u0664','\u0665','\u0666','\u0667','\u0668','\u0669'];
    for (int i = 0; i < en.length; i++) {
      value = value.replaceAll(en[i], ar[i]);
    }
    return value;
  }

  // ── Mock data ────────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _newOrders = [
    {
      'id': '#CR-2026-045',
      'clientName': 'محمد العمري',
      'clientNameEn': 'Mohammed Al-Omari',
      'service': 'تركيب أرضيات خشبية',
      'serviceEn': 'Wooden Floor Installation',
      'location': 'عمّان، فلسطين',
      'locationEn': 'Nablus, Palestine',
      'budget': '250 JD',
      'date': '2026-12-28',
      'urgent': true,
      'description': 'تركيب أرضية خشبية في غرفة المعيشة، المساحة 30 متر مربع، خشب بلوط فاتح.',
      'descriptionEn': 'Install wooden flooring in living room, 30 sqm, light oak wood.',
    },
    {
      'id': '#CR-2026-046',
      'clientName': 'سارة الخالدي',
      'clientNameEn': 'Sara Al-Khalidi',
      'service': 'دهان غرف نوم',
      'serviceEn': 'Bedroom Painting',
      'location': 'الزرقاء، فلسطين',
      'locationEn': 'Ramallah, Palestine',
      'budget': '120 JD',
      'date': '2026-12-27',
      'urgent': false,
      'description': 'دهان ثلاث غرف نوم بألوان هادئة، مع تشطيب الأسقف.',
      'descriptionEn': 'Paint three bedrooms with calm colors, including ceiling finish.',
    },
    {
      'id': '#CR-2026-047',
      'clientName': 'أحمد السلمان',
      'clientNameEn': 'Ahmed Al-Salman',
      'service': 'صيانة كهربائية',
      'serviceEn': 'Electrical Maintenance',
      'location': 'إربد، فلسطين',
      'locationEn': 'Hebron, Palestine',
      'budget': '80 JD',
      'date': '2026-12-26',
      'urgent': true,
      'description': 'مشكلة في لوحة التوزيع الكهربائية وبعض المنافذ لا تعمل.',
      'descriptionEn': 'Issue with electrical distribution panel and some outlets not working.',
    },
  ];

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'id': '#CR-2026-039',
      'clientName': 'نور الدين',
      'clientNameEn': 'Nour El-Din',
      'service': 'تركيب مطبخ',
      'serviceEn': 'Kitchen Installation',
      'price': '850 JD',
      'progress': 0.6,
      'dueDate': '2026-01-05',
      'chatCount': 3,
    },
    {
      'id': '#CR-2026-041',
      'clientName': 'ليلى الحسن',
      'clientNameEn': 'Layla Al-Hassan',
      'service': 'ديكور حديقة',
      'serviceEn': 'Garden Decoration',
      'price': '320 JD',
      'progress': 0.3,
      'dueDate': '2026-01-10',
      'chatCount': 0,
    },
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {
      'id': '#CR-2026-031',
      'clientName': 'خالد المنصور',
      'clientNameEn': 'Khalid Al-Mansour',
      'service': 'تركيب أبواب',
      'serviceEn': 'Door Installation',
      'price': '180 JD',
      'rating': 5,
      'completedDate': '2026-12-20',
    },
    {
      'id': '#CR-2026-028',
      'clientName': 'هند العواد',
      'clientNameEn': 'Hind Al-Awad',
      'service': 'تصليح سباكة',
      'serviceEn': 'Plumbing Repair',
      'price': '95 JD',
      'rating': 4,
      'completedDate': '2026-12-15',
    },
    {
      'id': '#CR-2026-025',
      'clientName': 'فارس النمر',
      'clientNameEn': 'Fares Al-Namir',
      'service': 'تركيب تكييف',
      'serviceEn': 'AC Installation',
      'price': '210 JD',
      'rating': 5,
      'completedDate': '2026-12-10',
    },
  ];

  Color inputFillColor(BuildContext context) => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.grey.shade100;

  String _sortMethod = 'date_asc';

  double _parsePrice(dynamic val) {
    if (val == null) return 0;
    return double.tryParse(val.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    try {
      return DateTime.parse(val.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  void _applySort(String method) {
    setState(() {
      _sortMethod = method;
      
      int compareDates(dynamic a, dynamic b) {
        final d1 = _parseDate(a);
        final d2 = _parseDate(b);
        return method == 'date_asc' ? d1.compareTo(d2) : d2.compareTo(d1);
      }
      
      int comparePrices(dynamic a, dynamic b) {
        final p1 = _parsePrice(a);
        final p2 = _parsePrice(b);
        return p2.compareTo(p1);
      }

      void sortList(List<Map<String, dynamic>> list, String dateKey, String priceKey) {
        list.sort((a, b) {
          if (method == 'price_desc') {
            return comparePrices(a[priceKey], b[priceKey]);
          } else {
            return compareDates(a[dateKey], b[dateKey]);
          }
        });
      }

      sortList(_newOrders, 'date', 'budget');
      sortList(_activeOrders, 'dueDate', 'price');
      sortList(_completedOrders, 'completedDate', 'price');
    });
  }

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
            t('الطلبات', 'Orders'),
            style: GoogleFonts.cairo(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list, color: accent),
              color: surface,
              onSelected: _applySort,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'date_asc',
                  child: Text(t('الأقرب موعداً', 'Closest Deadline'), style: GoogleFonts.cairo(color: text, fontWeight: _sortMethod == 'date_asc' ? FontWeight.bold : FontWeight.normal)),
                ),
                PopupMenuItem(
                  value: 'date_desc',
                  child: Text(t('الأبعد موعداً', 'Furthest Deadline'), style: GoogleFonts.cairo(color: text, fontWeight: _sortMethod == 'date_desc' ? FontWeight.bold : FontWeight.normal)),
                ),
                PopupMenuItem(
                  value: 'price_desc',
                  child: Text(t('الأعلى سعراً', 'Highest Price'), style: GoogleFonts.cairo(color: text, fontWeight: _sortMethod == 'price_desc' ? FontWeight.bold : FontWeight.normal)),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: dim,
            indicatorColor: accent,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: t('جديد (${_newOrders.length})', 'New (${_newOrders.length})')),
              Tab(text: t('نشط (${_activeOrders.length})', 'Active (${_activeOrders.length})')),
              Tab(text: t('مكتمل', 'Done')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNewOrders(),
            _buildActiveOrders(),
            _buildCompletedOrders(),
          ],
        ),
      ),
    );
  }

  // ── New Orders Tab ────────────────────────────────────────────────────────────
  Widget _buildNewOrders() {
    if (_newOrders.isEmpty) return _buildEmptyState(Icons.inbox_outlined, t('لا توجد طلبات جديدة', 'No new orders'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _newOrders.length,
      itemBuilder: (context, i) => _newOrderCard(_newOrders[i]),
    );
  }

  Widget _newOrderCard(Map<String, dynamic> order) {
    final urgent = order['urgent'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: urgent ? const Color(0xFFD4A017).withValues(alpha: 0.5) : border,
          width: urgent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: urgent
                  ? const Color(0xFFD4A017).withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(
                  order['id'],
                  style: GoogleFonts.cairo(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                if (urgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      t('عاجل', 'Urgent'),
                      style: GoogleFonts.cairo(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client info row (name tappable, budget always visible)
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showClientProfileSheet(
                        context,
                        t(order['clientName'], order['clientNameEn']),
                        t(order['location'], order['locationEn']),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: accent.withValues(alpha: 0.15),
                            child: Text(
                              widget.isArabic
                                  ? (order['clientName'] as String)[0]
                                  : (order['clientNameEn'] as String)[0],
                              style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t(order['clientName'], order['clientNameEn']),
                                style: GoogleFonts.cairo(
                                  color: text,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: accent,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 12, color: dim),
                                  const SizedBox(width: 2),
                                  Text(
                                    t(order['location'], order['locationEn']),
                                    style: GoogleFonts.cairo(color: dim, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order['budget'],
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          t('الميزانية', 'Budget'),
                          style: GoogleFonts.cairo(color: dim, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Service
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.build_outlined, size: 14, color: accent),
                      const SizedBox(width: 6),
                      Text(
                        t(order['service'], order['serviceEn']),
                        style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  t(order['description'], order['descriptionEn']),
                  style: GoogleFonts.cairo(color: dim, fontSize: 12, height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Deadline
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: urgent ? Colors.red.withValues(alpha: 0.1) : inputFillColor(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: urgent ? Colors.red.withValues(alpha: 0.3) : border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_available_outlined, size: 14, color: urgent ? Colors.red : text),
                      const SizedBox(width: 6),
                      Text(
                        '${t("الموعد النهائي:", "Deadline:")} ${order["date"]}',
                        style: GoogleFonts.cairo(color: urgent ? Colors.red : text, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showRejectDialog(order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          t('رفض', 'Decline'),
                          style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _showAcceptDialog(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A017),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          t('قبول وإرسال عرض', 'Accept & Bid'),
                          style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Orders Tab ────────────────────────────────────────────────────────
  Widget _buildActiveOrders() {
    if (_activeOrders.isEmpty) return _buildEmptyState(Icons.work_outline, t('لا توجد طلبات نشطة', 'No active orders'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _activeOrders.length,
      itemBuilder: (context, i) => _activeOrderCard(_activeOrders[i]),
    );
  }

  Widget _activeOrderCard(Map<String, dynamic> order) {
    final progress = order['progress'] as double;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order['id'], style: GoogleFonts.cairo(color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              if ((order['chatCount'] as int) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${order['chatCount']} ${t('رسائل', 'msgs')}',
                        style: GoogleFonts.cairo(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t(order['service'], order['serviceEn']),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _showClientProfileSheet(
              context,
              t(order['clientName'], order['clientNameEn']),
              t('نابلس، فلسطين', 'Nablus, Palestine'),
            ),
            child: Text(
              t(order['clientName'], order['clientNameEn']),
              style: GoogleFonts.cairo(
                color: dim,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: accent,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Progress bar
          Row(
            children: [
              Text(t('التقدم', 'Progress'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
              const Spacer(),
              Text(
                localizeNumber('${(progress * 100).toInt()}%'),
                style: GoogleFonts.cairo(color: accent, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 13, color: dim),
              const SizedBox(width: 4),
              Text(
                '${t('موعد التسليم:', 'Due:')} ${localizeNumber(order['dueDate'])}',
                style: GoogleFonts.cairo(color: dim, fontSize: 12),
              ),
              const Spacer(),
              Text(
                order['price'],
                style: GoogleFonts.cairo(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          isArabic: widget.isArabic,
                          isDarkMode: widget.isDarkMode,
                          name: widget.isArabic ? order['clientName'] : order['clientNameEn'],
                          craft: widget.isArabic ? order['service'] : order['serviceEn'],
                          online: true,
                          orderTitle: widget.isArabic ? order['service'] : order['serviceEn'],
                          orderStatus: 'in_progress',
                          orderPrice: order['price'].toString(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.chat_bubble_outline, size: 14, color: accent),
                  label: Text(t('مراسلة', 'Message'), style: GoogleFonts.cairo(color: accent, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _markComplete(order),
                  icon: const Icon(Icons.check_circle_outline, size: 14, color: Colors.black),
                  label: Text(t('إتمام', 'Complete'), style: GoogleFonts.cairo(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A017),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Completed Orders Tab ─────────────────────────────────────────────────────
  Widget _buildCompletedOrders() {
    if (_completedOrders.isEmpty) return _buildEmptyState(Icons.check_circle_outline, t('لا توجد طلبات مكتملة', 'No completed orders'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _completedOrders.length,
      itemBuilder: (context, i) => _completedOrderCard(_completedOrders[i]),
    );
  }

  Widget _completedOrderCard(Map<String, dynamic> order) {
    final rating = order['rating'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
            ),
            child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t(order['service'], order['serviceEn']),
                    style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => _showClientProfileSheet(
                    context,
                    t(order['clientName'], order['clientNameEn']),
                    t('نابلس، فلسطين', 'Nablus, Palestine'),
                  ),
                  child: Text(
                    t(order['clientName'], order['clientNameEn']),
                    style: GoogleFonts.cairo(
                      color: dim,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: accent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: const Color(0xFFF7B500),
                  )),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(order['price'],
                  style: GoogleFonts.cairo(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
              Text(localizeNumber(order['completedDate']),
                  style: GoogleFonts.cairo(color: dim, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  void _showClientProfileSheet(BuildContext context, String name, String location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 36,
                backgroundColor: accent.withValues(alpha: 0.15),
                child: Text(name[0], style: GoogleFonts.cairo(color: accent, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Text(name, style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: dim),
                  const SizedBox(width: 4),
                  Text(location, style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t('عميل موثوق في كرافت جو. انضم منذ عام ٢٠٢٦.', 'Verified customer on CraftGo. Joined since 2026.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                  label: Text(t('بدء دردشة', 'Start Chat'), style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(ctx); // close sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          isArabic: widget.isArabic,
                          isDarkMode: widget.isDarkMode,
                          name: name,
                          craft: t('طلب مخصص', 'Custom request'),
                          online: true,
                          orderTitle: t('طلب مخصص', 'Custom request'),
                          orderStatus: 'bidding',
                          orderPrice: '—',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────
  void _showAcceptDialog(Map<String, dynamic> order) {
    final priceController = TextEditingController(text: order['budget'].toString().replaceAll(' JD', ''));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('إرسال عرض سعر', 'Send a Bid'),
                  style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(t('لطلب: ${order['service']}', 'For: ${order['serviceEn']}'),
                  style: GoogleFonts.cairo(color: dim, fontSize: 13)),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: text),
                decoration: InputDecoration(
                  labelText: t('سعرك المقترح (JD)', 'Your Price (JD)'),
                  labelStyle: TextStyle(color: dim),
                  prefixIcon: Icon(Icons.attach_money, color: accent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accent, width: 2),
                  ),
                  filled: true,
                  fillColor: bg,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A017),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(t('تم إرسال العرض بنجاح!', 'Bid sent successfully!')),
                      backgroundColor: const Color(0xFF4CAF50),
                    ));
                  },
                  child: Text(t('إرسال العرض', 'Send Bid'),
                      style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(t('رفض الطلب', 'Decline Order'),
              style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
          content: Text(
            t('هل أنت متأكد من رفض هذا الطلب؟', 'Are you sure you want to decline this order?'),
            style: GoogleFonts.cairo(color: dim),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: dim))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _newOrders.remove(order));
              },
              child: Text(t('رفض', 'Decline'), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _markComplete(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(t('تأكيد الإتمام', 'Confirm Completion'),
              style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
          content: Text(
            t('هل اكتملت الخدمة وتريد إغلاق هذا الطلب؟', 'Has the service been completed? Close this order?'),
            style: GoogleFonts.cairo(color: dim),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: Text(t('لا', 'No'), style: TextStyle(color: dim))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _activeOrders.remove(order);
                  _completedOrders.insert(0, {
                    ...order,
                    'rating': 5,
                    'completedDate': '2026-12-28',
                  });
                  _tabController.animateTo(2);
                });
              },
              child: Text(t('نعم، اكتمل', 'Yes, Done'), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.08),
            ),
            child: Icon(icon, size: 56, color: accent),
          ),
          const SizedBox(height: 16),
          Text(msg, style: GoogleFonts.cairo(color: dim, fontSize: 16)),
        ],
      ),
    );
  }
}
