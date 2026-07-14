// ============================================================
// ReviewSendScreen — Customer reviews filled form before sending
// Called from: CustomOrderFormScreen ("Review & Send" button)
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'custom_order_provider.dart';
import 'custom_order_template.dart';

class ReviewSendScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final CustomOrderTemplate template;
  final Map<String, dynamic> filledFields;

  const ReviewSendScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.template,
    required this.filledFields,
  });

  @override
  State<ReviewSendScreen> createState() => _ReviewSendScreenState();
}

class _ReviewSendScreenState extends State<ReviewSendScreen> {
  bool _isSubmitting = false;

  bool get isArabic => widget.isArabic;
  bool get isDarkMode => widget.isDarkMode;
  String t(String ar, String en) => isArabic ? ar : en;

  Color get bg => isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surf => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get sub => isDarkMode ? Colors.white60 : Colors.black54;
  Color get bord => isDarkMode ? Colors.white12 : Colors.black12;
  Color get gold => const Color(0xFFD4A017);

  void _sendRequest() async {
    setState(() => _isSubmitting = true);

    final prov = context.read<CustomOrderProvider>();
    await prov.submitRequest(
      template: widget.template,
      filledFields: widget.filledFields,
      customerId: 'customer-demo', // TODO: Replace with actual user ID
      customerName: 'أحمد محمد', // TODO: Replace with actual user name
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t('✅ تم إرسال طلبك بنجاح!', '✅ Your request was sent successfully!')),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('مراجعة الطلب', 'Review Order'),
            style: GoogleFonts.arefRuqaa(color: text, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t('الرجاء مراجعة التفاصيل', 'Please review the details'),
                          style: TextStyle(color: text, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          t('سيتم إرسال الطلب إلى الحرفي', 'The request will be sent to the artisan'),
                          style: TextStyle(color: sub, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Template Info
            Text(
              t('نوع الطلب', 'Request Type'),
              style: GoogleFonts.cairo(color: sub, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              isArabic ? widget.template.titleAr : widget.template.titleEn,
              style: GoogleFonts.cairo(color: text, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? widget.template.categoryAr : widget.template.categoryEn,
              style: GoogleFonts.cairo(color: gold, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Artisan Info
            Text(
              t('الحرفي', 'Artisan'),
              style: GoogleFonts.cairo(color: sub, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              widget.template.artisanName,
              style: GoogleFonts.cairo(color: text, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Filled Fields
            Text(
              t('التفاصيل', 'Details'),
              style: GoogleFonts.cairo(color: sub, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...widget.template.fields.map((field) {
              final value = widget.filledFields[field.id];
              if (value == null || value.toString().isEmpty) return const SizedBox.shrink();

              String displayValue = value.toString();
              if (field.type == 'color_picker' && value is Color) {
                displayValue = '#${value.value.toRadixString(16).padLeft(8, '0').substring(2, 8)}';
              }
              if (field.type == 'checkbox') {
                displayValue = value == true
                    ? (isArabic ? '✅ نعم' : '✅ Yes')
                    : (isArabic ? '❌ لا' : '❌ No');
              }
              if (field.type == 'image_upload' && value is List) {
                displayValue = '${value.length} ${t('صور', 'images')}';
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        color: gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? field.labelAr : field.labelEn,
                            style: GoogleFonts.cairo(color: sub, fontSize: 12),
                          ),
                          Text(
                            displayValue,
                            style: GoogleFonts.cairo(color: text, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // Submit Button
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF7B500), Color(0xFFD89A00)]),
                borderRadius: BorderRadius.circular(27),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: _isSubmitting ? null : _sendRequest,
                child: _isSubmitting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                )
                    : Text(
                  t('إرسال الطلب', 'Send Request'),
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t('سيتم إخطارك عندما يرد الحرفي على طلبك', 'You will be notified when the artisan responds'),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: sub, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}