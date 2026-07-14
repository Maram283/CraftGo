import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../custom_order/custom_order_provider.dart';
import '../custom_order/custom_order_request.dart';
import 'artisan_response_screen.dart';
import '../customer/chat_detail_screen.dart';
import 'craftsman_review_customer_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CraftsmanOrdersScreen — إدارة الطلبات الواردة للحرفي
//
// Tabs:
//   1. واردة (Incoming) — طلبات جديدة تحتاج رد
//   2. مفاوضة (Negotiating) — رد الحرفي قيد انتظار موافقة الزبون
//   3. قيد التنفيذ (In Progress) — طلبات معتمدة قيد العمل
//   4. مكتملة (Completed) — طلبات منتهية
// ─────────────────────────────────────────────────────────────────────────────

class CraftsmanOrdersScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String artisanId; // The logged-in artisan's ID

  const CraftsmanOrdersScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.artisanId,
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
  Color get gold => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  String localizeNumber(String value) {
    if (!widget.isArabic) return value;
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const ar = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    for (int i = 0; i < en.length; i++) {
      value = value.replaceAll(en[i], ar[i]);
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Status Helpers ──────────────────────────────────────────────────────────
  String statusText(String status) {
    final map = {
      'pending_artisan': t('في انتظار ردك', 'Awaiting Your Response'),
      'pending_customer': t('في انتظار الزبون', 'Awaiting Customer'),
      'in_progress': t('قيد التنفيذ', 'In Progress'),
      'completed': t('مكتمل', 'Completed'),
      'rejected': t('مرفوض', 'Rejected'),
      'cancelled': t('ملغي', 'Cancelled'),
    };
    return map[status] ?? status;
  }

  Color statusColor(String status) {
    final map = {
      'pending_artisan': Colors.orange,
      'pending_customer': Colors.blue,
      'in_progress': gold,
      'completed': Colors.green,
      'rejected': Colors.red,
      'cancelled': Colors.grey,
    };
    return map[status] ?? Colors.grey;
  }

  // ── Filtered Lists ──────────────────────────────────────────────────────────
  List<CustomOrderRequest> _incomingRequests(CustomOrderProvider prov) {
    return prov.requestsForArtisan(widget.artisanId)
        .where((r) => r.status == 'pending_artisan')
        .toList();
  }

  List<CustomOrderRequest> _negotiatingRequests(CustomOrderProvider prov) {
    return prov.requestsForArtisan(widget.artisanId)
        .where((r) => r.status == 'pending_customer')
        .toList();
  }

  List<CustomOrderRequest> _inProgressRequests(CustomOrderProvider prov) {
    return prov.requestsForArtisan(widget.artisanId)
        .where((r) => r.status == 'in_progress')
        .toList();
  }

  List<CustomOrderRequest> _completedRequests(CustomOrderProvider prov) {
    return prov.requestsForArtisan(widget.artisanId)
        .where((r) => r.status == 'completed' || r.status == 'rejected' || r.status == 'cancelled')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CustomOrderProvider>();
    final incoming = _incomingRequests(prov);
    final negotiating = _negotiatingRequests(prov);
    final inProgress = _inProgressRequests(prov);
    final completed = _completedRequests(prov);

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          title: Text(
            t('الطلبات', 'Orders'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: dim,
            indicatorColor: accent,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: [
              Tab(text: t('واردة (${incoming.length})', 'Incoming (${incoming.length})')),
              Tab(text: t('مفاوضة (${negotiating.length})', 'Negotiating (${negotiating.length})')),
              Tab(text: t('قيد التنفيذ (${inProgress.length})', 'In Progress (${inProgress.length})')),
              Tab(text: t('مكتملة (${completed.length})', 'Done (${completed.length})')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildIncomingTab(incoming, prov),
            _buildNegotiatingTab(negotiating, prov),
            _buildInProgressTab(inProgress, prov),
            _buildCompletedTab(completed, prov),
          ],
        ),
      ),
    );
  }

  // ── 1. INCOMING TAB ─────────────────────────────────────────────────────────
  Widget _buildIncomingTab(List<CustomOrderRequest> requests, CustomOrderProvider prov) {
    if (requests.isEmpty) {
      return _buildEmptyState(
        Icons.inbox_outlined,
        t('لا توجد طلبات واردة', 'No incoming requests'),
        t('ستظهر هنا الطلبات الجديدة من الزبائن', 'New customer requests will appear here'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, i) => _IncomingRequestCard(
        request: requests[i],
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
        onRespond: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArtisanResponseScreen(
                isArabic: widget.isArabic,
                isDarkMode: widget.isDarkMode,
                request: requests[i],
                artisanId: widget.artisanId,
              ),
            ),
          ).then((_) => prov.notifyListeners());
        },
        onDecline: () => _showDeclineDialog(context, requests[i], prov),
      ),
    );
  }

  // ── 2. NEGOTIATING TAB ──────────────────────────────────────────────────────
  Widget _buildNegotiatingTab(List<CustomOrderRequest> requests, CustomOrderProvider prov) {
    if (requests.isEmpty) {
      return _buildEmptyState(
        Icons.hourglass_empty,
        t('لا توجد طلبات قيد المفاوضة', 'No negotiations in progress'),
        t('الطلبات التي ردّ عليها الحرفي تظهر هنا', 'Requests you\'ve responded to appear here'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, i) => _NegotiatingCard(
        request: requests[i],
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
        onViewDetails: () {
          _showNegotiationDetails(context, requests[i]);
        },
        onCancel: () => _showCancelDialog(context, requests[i], prov),
      ),
    );
  }

  // ── 3. IN PROGRESS TAB ─────────────────────────────────────────────────────
  Widget _buildInProgressTab(List<CustomOrderRequest> requests, CustomOrderProvider prov) {
    if (requests.isEmpty) {
      return _buildEmptyState(
        Icons.build_outlined,
        t('لا توجد طلبات قيد التنفيذ', 'No orders in progress'),
        t('الطلبات المعتمدة تظهر هنا', 'Approved orders appear here'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, i) => _InProgressCard(
        request: requests[i],
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
        onUpdateProgress: () => _showProgressUpdateDialog(context, requests[i], prov),
        onComplete: () => _showCompleteDialog(context, requests[i], prov),
      ),
    );
  }

  // ── 4. COMPLETED TAB ───────────────────────────────────────────────────────
  Widget _buildCompletedTab(List<CustomOrderRequest> requests, CustomOrderProvider prov) {
    if (requests.isEmpty) {
      return _buildEmptyState(
        Icons.check_circle_outline,
        t('لا توجد طلبات مكتملة', 'No completed orders'),
        t('الطلبات المنجزة تظهر هنا', 'Completed orders appear here'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, i) => _CompletedCard(
        request: requests[i],
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
        onReview: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CraftsmanReviewCustomerScreen(
                isArabic: widget.isArabic,
                isDarkMode: widget.isDarkMode,
                customerName: requests[i].customerName,
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────
  void _showDeclineDialog(BuildContext context, CustomOrderRequest request, CustomOrderProvider prov) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text(t('رفض الطلب', 'Decline Order'), style: TextStyle(color: text)),
        content: Text(
          t('هل أنت متأكد من رفض هذا الطلب؟', 'Are you sure you want to decline this order?'),
          style: TextStyle(color: dim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: dim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              prov.customerReject(request.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t('تم رفض الطلب', 'Order declined')),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(t('رفض', 'Decline'), style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, CustomOrderRequest request, CustomOrderProvider prov) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text(t('إلغاء المفاوضة', 'Cancel Negotiation'), style: TextStyle(color: text)),
        content: Text(
          t('هل تريد إلغاء هذه المفاوضة؟', 'Do you want to cancel this negotiation?'),
          style: TextStyle(color: dim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: dim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              prov.customerCancel(request.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t('تم إلغاء المفاوضة', 'Negotiation cancelled')),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNegotiationDetails(BuildContext context, CustomOrderRequest request) {
    final response = request.artisanResponse;
    if (response == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(
              t('تفاصيل العرض', 'Bid Details'),
              style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Price Breakdown
            Text(t('توزيع السعر', 'Price Breakdown'), style: TextStyle(color: dim, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...response.breakdown.map((row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.isArabic ? row.labelAr : row.labelEn, style: TextStyle(color: text)),
                  Text('${row.amount.toStringAsFixed(0)} JOD', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
                ],
              ),
            )),
            Divider(color: border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t('المجموع', 'Total'), style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${response.total.toStringAsFixed(0)} JOD', style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Text(t('المهام', 'Tasks'), style: TextStyle(color: dim, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...response.tasks.map((task) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(task, style: TextStyle(color: text, fontSize: 13))),
                ],
              ),
            )),
            const SizedBox(height: 12),
            Text(
              '${t('تاريخ التسليم:', 'Delivery:')} ${response.deliveryDate.day}/${response.deliveryDate.month}/${response.deliveryDate.year}',
              style: TextStyle(color: dim, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              widget.isArabic ? response.notesAr : response.notesEn,
              style: TextStyle(color: dim, fontSize: 13, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  t('إغلاق', 'Close'),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProgressUpdateDialog(BuildContext context, CustomOrderRequest request, CustomOrderProvider prov) {
    // Get the stages from the request's fields or use default stages
    final stages = ['materials_received', 'execution_started', 'quality_review', 'ready_for_delivery'];
    final stageLabels = {
      'materials_received': t('تم استلام المواد', 'Materials Received'),
      'execution_started': t('بدأ التنفيذ', 'Execution Started'),
      'quality_review': t('مراجعة الجودة', 'Quality Review'),
      'ready_for_delivery': t('جاهز للتسليم', 'Ready for Delivery'),
    };

    // Find current stage index
    int currentIndex = 0;
    // We would need to track this in the database; for now, we'll let artisan select

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(
              t('تحديث مرحلة التنفيذ', 'Update Progress'),
              style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              request.templateTitleAr,
              style: TextStyle(color: dim, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...stages.asMap().entries.map((entry) {
              final idx = entry.key;
              final stage = entry.value;
              return RadioListTile<int>(
                title: Text(
                  stageLabels[stage] ?? stage,
                  style: TextStyle(color: text),
                ),
                value: idx,
                groupValue: currentIndex,
                onChanged: (val) {
                  setState(() => currentIndex = val!);
                },
                activeColor: gold,
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t('تم تحديث المرحلة ✅', 'Stage updated ✅')),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(
                  t('تحديث', 'Update'),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, CustomOrderRequest request, CustomOrderProvider prov) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text(t('تأكيد الإتمام', 'Confirm Completion'), style: TextStyle(color: text, fontWeight: FontWeight.bold)),
        content: Text(
          t('هل اكتملت الخدمة وترغب في إغلاق هذا الطلب؟', 'Has the service been completed? Close this order?'),
          style: TextStyle(color: dim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('لا', 'No'), style: TextStyle(color: dim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              prov.artisanUpdateStatus(request.id, 'completed');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t('✅ تم إكمال الطلب', '✅ Order completed')),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(t('نعم، اكتمل', 'Yes, Done'), style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
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
          Text(title, style: GoogleFonts.cairo(color: text, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: GoogleFonts.cairo(color: dim, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Incoming Request Card ──────────────────────────────────────────────────
class _IncomingRequestCard extends StatelessWidget {
  final CustomOrderRequest request;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onRespond;
  final VoidCallback onDecline;

  const _IncomingRequestCard({
    required this.request,
    required this.isArabic,
    required this.isDarkMode,
    required this.onRespond,
    required this.onDecline,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get dim => isDarkMode ? Colors.white60 : Colors.black54;
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08);
  Color get gold => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final customerName = request.customerName;
    final templateTitle = isArabic ? request.templateTitleAr : request.templateTitleEn;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: gold.withValues(alpha: 0.15),
                child: Text(
                  customerName.isNotEmpty ? customerName[0] : '?',
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: TextStyle(color: text, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      templateTitle,
                      style: TextStyle(color: dim, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t('جديد', 'New'),
                  style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fields summary
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: request.filledFields.entries.take(3).map((entry) {
              final value = entry.value.toString();
              if (value.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.length > 30 ? '${value.substring(0, 30)}...' : value,
                  style: TextStyle(color: dim, fontSize: 11),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    t('رفض', 'Decline'),
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onRespond,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    t('رد على الطلب', 'Respond'),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Negotiating Card ──────────────────────────────────────────────────────
class _NegotiatingCard extends StatelessWidget {
  final CustomOrderRequest request;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;

  const _NegotiatingCard({
    required this.request,
    required this.isArabic,
    required this.isDarkMode,
    required this.onViewDetails,
    required this.onCancel,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get dim => isDarkMode ? Colors.white60 : Colors.black54;
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08);
  Color get gold => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final response = request.artisanResponse;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isArabic ? request.templateTitleAr : request.templateTitleEn,
                style: TextStyle(color: text, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  t('بانتظار الزبون', 'Waiting'),
                  style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.customerName,
            style: TextStyle(color: dim, fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (response != null)
            Row(
              children: [
                Icon(Icons.attach_money, size: 14, color: gold),
                const SizedBox(width: 4),
                Text(
                  '${response.total.toStringAsFixed(0)} JOD',
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule_outlined, size: 14, color: dim),
                const SizedBox(width: 4),
                Text(
                  '${response.deliveryDate.day}/${response.deliveryDate.month}/${response.deliveryDate.year}',
                  style: TextStyle(color: dim, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.task_alt_outlined, size: 14, color: dim),
                const SizedBox(width: 4),
                Text(
                  '${response.tasks.length} ${t('مهام', 'tasks')}',
                  style: TextStyle(color: dim, fontSize: 12),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    t('عرض التفاصيل', 'View Details'),
                    style: TextStyle(color: text, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    t('إلغاء', 'Cancel'),
                    style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── In Progress Card ──────────────────────────────────────────────────────
class _InProgressCard extends StatelessWidget {
  final CustomOrderRequest request;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onUpdateProgress;
  final VoidCallback onComplete;

  const _InProgressCard({
    required this.request,
    required this.isArabic,
    required this.isDarkMode,
    required this.onUpdateProgress,
    required this.onComplete,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get dim => isDarkMode ? Colors.white60 : Colors.black54;
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08);
  Color get gold => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final response = request.artisanResponse;
    final totalTasks = response?.tasks.length ?? 0;
    final completedTasks = 0; // Would need to track this in DB

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isArabic ? request.templateTitleAr : request.templateTitleEn,
                style: TextStyle(color: text, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  t('قيد التنفيذ', 'In Progress'),
                  style: TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.customerName,
            style: TextStyle(color: dim, fontSize: 13),
          ),
          const SizedBox(height: 12),
          // Progress bar
          Row(
            children: [
              Text(t('التقدم', 'Progress'), style: TextStyle(color: dim, fontSize: 12)),
              const Spacer(),
              Text(
                '${totalTasks > 0 ? (completedTasks / totalTasks * 100).toInt() : 0}%',
                style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalTasks > 0 ? completedTasks / totalTasks : 0,
              backgroundColor: gold.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(gold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onUpdateProgress,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: gold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    t('تحديث التقدم', 'Update Progress'),
                    style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    t('إتمام', 'Complete'),
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Completed Card ────────────────────────────────────────────────────────
class _CompletedCard extends StatelessWidget {
  final CustomOrderRequest request;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onReview;

  const _CompletedCard({
    required this.request,
    required this.isArabic,
    required this.isDarkMode,
    required this.onReview,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get dim => isDarkMode ? Colors.white60 : Colors.black54;
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08);
  Color get gold => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final status = request.status;
    final isCompleted = status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.green.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.cancel_outlined,
                  color: isCompleted ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? request.templateTitleAr : request.templateTitleEn,
                      style: TextStyle(color: text, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      request.customerName,
                      style: TextStyle(color: dim, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isCompleted ? t('مكتمل', 'Completed') : t('ملغي', 'Cancelled'),
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: border),
          const SizedBox(height: 12),
          if (isCompleted)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReview,
                    icon: Icon(Icons.star_rate, size: 18, color: gold),
                    label: Text(
                      t('تقييم الزبون', 'Rate Customer'),
                      style: TextStyle(color: text, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}