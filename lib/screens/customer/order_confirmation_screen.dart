import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String orderNumber;

  const OrderConfirmationScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.orderNumber,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
    final surface = isDarkMode ? const Color(0xFF1C2431) : Colors.white;
    final text = isDarkMode ? Colors.white : Colors.black87;
    final dim = isDarkMode ? Colors.white60 : Colors.black54;
    final accent = const Color(0xFFD4A017);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: text),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated-like success icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  t('تم استلام طلبك بنجاح! ✅', 'Order Received Successfully! ✅'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: text,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Order Number Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t('رقم الطلب:', 'Order Number:'),
                        style: GoogleFonts.cairo(color: dim, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orderNumber,
                        style: GoogleFonts.cairo(color: accent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Estimated time
                Text(
                  t(
                    'عادةً ما يقوم الحرفي بالرد خلال ٢٤-٤٨ ساعة.\nسنقوم بإعلامك فور تحديث حالة الطلب.',
                    'The craftsman usually responds within 24-48 hours.\nWe will notify you when the order status updates.'
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(color: dim, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 48),
                
                // Actions
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to cart (or to orders screen in a real app)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      t('متابعة الطلب', 'Track Order'),
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {
                      // Pop back to root or home
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: dim.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      t('العودة للرئيسية', 'Back to Home'),
                      style: GoogleFonts.cairo(
                        color: text,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
