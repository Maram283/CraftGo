import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'review_submission_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OrderDetailScreen — تفاصيل طلب العميل
// ─────────────────────────────────────────────────────────────────────────────

class OrderDetailScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final Map<String, dynamic> order;

  const OrderDetailScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.order,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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

  // For visual timeline (mock logic based on status)
  int get currentStep {
    final status = widget.order['status'];
    if (status == 'delivered' || status == 'مكتمل') return 4;
    if (status == 'ready' || status == 'جاهز للتسليم') return 3;
    if (status == 'in_progress' || status == 'قيد التنفيذ') return 2;
    if (status == 'accepted' || status == 'تم قبول الطلب') return 1;
    return 0; // new / received
  }

  Color getStatusColor() {
    switch (currentStep) {
      case 0: return Colors.blue;
      case 1: return Colors.teal;
      case 2: return Colors.orange;
      case 3: return Colors.purple;
      case 4: return const Color(0xFF4CAF50);
      default: return Colors.red;
    }
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
            t('تفاصيل الطلب', 'Order Details'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Card ────────────────────────────────────────────────
              _buildHeaderCard(),
              const SizedBox(height: 24),

              // ── Timeline ──────────────────────────────────────────────────
              Text(
                t('حالة الطلب', 'Order Status'),
                style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTimeline(),
              const SizedBox(height: 24),

              // ── Service Details ───────────────────────────────────────────
              Text(
                t('تفاصيل الخدمة', 'Service Details'),
                style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildServiceDetails(),
              const SizedBox(height: 24),

              // ── Pricing ───────────────────────────────────────────────────
              Text(
                t('ملخص الدفع', 'Payment Summary'),
                style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildPricing(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomActions(),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getStatusColor().withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long, color: getStatusColor(), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order['id'] ?? '#CR-2026-001',
                  style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.order['date'] ?? '2026-12-28',
                  style: GoogleFonts.cairo(color: dim, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              t(widget.order['statusAr'] ?? 'غير معروف', widget.order['statusEn'] ?? 'Unknown'),
              style: GoogleFonts.cairo(color: getStatusColor(), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = [
      {'ar': 'تم استلام الطلب', 'en': 'Order Received', 'time': '10:00 AM'},
      {'ar': 'تم قبول الطلب', 'en': 'Order Accepted', 'time': '10:30 AM'},
      {'ar': 'قيد التنفيذ', 'en': 'In Progress', 'time': '12:00 PM'},
      {'ar': 'جاهز للتسليم', 'en': 'Ready for Delivery', 'time': '--:--'},
      {'ar': 'تم التسليم', 'en': 'Delivered', 'time': '--:--'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final isDone = index <= currentStep;
          final isCurrent = index == currentStep;
          final isLast = index == steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Line
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? accent : Colors.transparent,
                      border: Border.all(color: isDone ? accent : border, width: 2),
                    ),
                    child: isDone
                        ? const Icon(Icons.check, color: Colors.black, size: 14)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isDone && !isCurrent ? accent : border,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(steps[index]['ar']!, steps[index]['en']!),
                        style: GoogleFonts.cairo(
                          color: isDone ? text : dim,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        steps[index]['time']!,
                        style: GoogleFonts.cairo(color: dim, fontSize: 12),
                      ),
                      if (!isLast) const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.build_outlined, color: accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(widget.order['serviceAr'] ?? 'خدمة', widget.order['serviceEn'] ?? 'Service'),
                      style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      t('النجارة', 'Carpentry'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: border),
          const SizedBox(height: 16),
          // Craftsman Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: accent.withValues(alpha: 0.2),
                child: Text('ح', style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('محمد الحرفي', 'Mohammed Craftsman'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text('4.8', style: GoogleFonts.cairo(color: dim, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Icon(Icons.chat_bubble_outline, size: 18, color: text),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: border),
          const SizedBox(height: 16),
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: dim, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('موقع التسليم', 'Delivery Location'), style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                    Text(
                      t('نابلس، فلسطين - شارع رفيديا، عمارة 45', 'Nablus, Palestine - Rafidia St, Bldg 45'),
                      style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricing() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _buildPriceRow(t('تكلفة الخدمة', 'Service Fee'), '150 JD'),
          const SizedBox(height: 12),
          _buildPriceRow(t('المواد', 'Materials'), '45 JD'),
          const SizedBox(height: 12),
          _buildPriceRow(t('التوصيل', 'Delivery'), '10 JD'),
          const SizedBox(height: 16),
          Divider(color: border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t('الإجمالي', 'Total'),
                style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '205 JD',
                style: GoogleFonts.cairo(color: const Color(0xFF4CAF50), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.cairo(color: dim, fontSize: 14)),
        Text(amount, style: GoogleFonts.cairo(color: text, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          if (currentStep < 4) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  t('إلغاء الطلب', 'Cancel Order'),
                  style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  t('تتبع الحرفي', 'Track Craftsman'),
                  style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewSubmissionScreen(
                        isArabic: widget.isArabic,
                        isDarkMode: widget.isDarkMode,
                        order: widget.order,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  t('تقييم', 'Rate'),
                  style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  t('إعادة الطلب', 'Reorder'),
                  style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
