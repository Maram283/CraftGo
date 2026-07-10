import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CraftsmanReviewCustomerScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String customerName;

  const CraftsmanReviewCustomerScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.customerName,
  });

  @override
  State<CraftsmanReviewCustomerScreen> createState() => _CraftsmanReviewCustomerScreenState();
}

class _CraftsmanReviewCustomerScreenState extends State<CraftsmanReviewCustomerScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('يرجى اختيار التقييم بالنجوم', 'Please select a star rating')),
          backgroundColor: accent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFD4A017))),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Close review screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('تم تقييم الزبون بنجاح!', 'Customer rated successfully!')),
          backgroundColor: Colors.green,
        ),
      );
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
            t('تقييم الزبون', 'Rate Customer'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: accent.withValues(alpha: 0.1),
                child: Icon(Icons.person, size: 40, color: accent),
              ),
              const SizedBox(height: 16),
              Text(
                t('كيف كانت تجربتك مع الزبون؟', 'How was your experience with the customer?'),
                style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.customerName,
                style: GoogleFonts.cairo(color: dim, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: accent,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _commentController,
                style: TextStyle(color: text),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: t('أضف تعليقاً (اختياري)', 'Add a comment (Optional)'),
                  hintStyle: TextStyle(color: dim),
                  filled: true,
                  fillColor: surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    t('إرسال التقييم', 'Submit Review'),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
