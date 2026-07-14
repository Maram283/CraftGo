import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/exhibitions_service.dart';
import 'services/api_service.dart';

class ExploreExhibitionsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const ExploreExhibitionsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<ExploreExhibitionsScreen> createState() => _ExploreExhibitionsScreenState();
}

class _ExploreExhibitionsScreenState extends State<ExploreExhibitionsScreen> {
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.1);
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  late Future<List<dynamic>> _exhibitionsFuture;

  @override
  void initState() {
    super.initState();
    _exhibitionsFuture = ExhibitionsService.getAllExhibitions();
  }

  void _refresh() {
    setState(() {
      _exhibitionsFuture = ExhibitionsService.getAllExhibitions();
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
            icon: Icon(Icons.arrow_back_ios_new, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('استكشاف المعارض', 'Explore Exhibitions'),
            style: GoogleFonts.cairo(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: text),
              onPressed: _refresh,
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: TextStyle(color: text),
                decoration: InputDecoration(
                  hintText: t('ابحث عن معارض قريبة...', 'Search nearby exhibitions...'),
                  hintStyle: TextStyle(color: dim),
                  prefixIcon: Icon(Icons.search, color: dim),
                  filled: true,
                  fillColor: surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _exhibitionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: accent));
                  }

                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, color: dim, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            t('لا توجد معارض متاحة حالياً\nتأكد من تشغيل السيرفر',
                                'No exhibitions found.\nMake sure the server is running.'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(color: dim, fontSize: 14, height: 1.6),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: Text(t('إعادة المحاولة', 'Retry'), style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final exhibitions = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: exhibitions.length,
                    itemBuilder: (context, index) {
                      final ex = exhibitions[index] as Map<String, dynamic>;
                      final isFull = ex['isFull'] == true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Card Header with Status Badge
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isFull
                                    ? Colors.amber.withValues(alpha: 0.05)
                                    : Colors.green.withValues(alpha: 0.05),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                border: Border(bottom: BorderSide(color: border)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isFull ? Icons.hourglass_empty : Icons.check_circle_outline,
                                        color: isFull ? Colors.amber.shade700 : Colors.green,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isFull
                                            ? t('ممتلئ - متاح للاحتياط', 'Full - Standby Available')
                                            : t('متاح للتسجيل الأساسي', 'Available for Registration'),
                                        style: GoogleFonts.cairo(
                                          color: isFull ? Colors.amber.shade700 : Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isFull
                                          ? Colors.amber.withValues(alpha: 0.2)
                                          : Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isFull
                                          ? t('احتياط متاح', 'Standby Open')
                                          : t('مقاعد متاحة', 'Seats Available'),
                                      style: GoogleFonts.cairo(
                                        color: isFull ? Colors.amber.shade700 : Colors.green.shade700,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(Icons.event, color: accent, size: 30),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ex['name']?.toString() ?? t('معرض', 'Exhibition'),
                                          style: GoogleFonts.cairo(
                                            color: text,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_month, color: dim, size: 12),
                                            const SizedBox(width: 4),
                                            Text(
                                              ex['startDate'] != null
                                                  ? ex['startDate'].toString().substring(0, 10)
                                                  : t('لم يحدد بعد', 'TBD'),
                                              style: GoogleFonts.cairo(color: dim, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, color: dim, size: 12),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                ex['location']?.toString() ?? '',
                                                style: GoogleFonts.cairo(color: dim, fontSize: 11),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _showRegistrationDialog(ex, isFull),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isFull ? Colors.amber.withValues(alpha: 0.1) : accent,
                                    foregroundColor:
                                        isFull ? Colors.amber.shade700 : Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: isFull
                                          ? BorderSide(color: Colors.amber.shade700)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Text(
                                    isFull
                                        ? t('تسجيل في قائمة الاحتياط', 'Join Standby List')
                                        : t('تسجيل كحرفي أساسي', 'Register as Main Craftsman'),
                                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegistrationDialog(Map<String, dynamic> ex, bool isFull) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(
                isFull ? Icons.hourglass_empty : Icons.check_circle,
                color: isFull ? Colors.amber.shade700 : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                isFull ? t('تأكيد الاحتياط', 'Confirm Standby') : t('تأكيد التسجيل', 'Confirm Registration'),
                style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isFull
                    ? t('سيتم تسجيلك في قائمة الاحتياط. إذا اعتذر أحد الحرفيين الأساسيين، سيقوم الذكاء الاصطناعي بترشيحك.',
                        'You will be added to the standby list. If a main craftsman cancels, our AI will recommend you.')
                    : t('هل أنت متأكد من رغبتك بالتسجيل كحرفي أساسي؟ سيتم حجز مقعدك فوراً.',
                        'Are you sure you want to register as a main craftsman? Your seat will be reserved immediately.'),
                style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5),
              ),
              if (isFull) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber.shade700, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t('سيحدد الذكاء الاصطناعي ترتيبك بناءً على تقييمك وتخصصك',
                              'AI will rank you based on your rating and specialty'),
                          style: GoogleFonts.cairo(
                            color: Colors.amber.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إلغاء', 'Cancel'), style: GoogleFonts.cairo(color: dim)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final token = await ApiService.getToken();
                final craftsmanId = token ?? 'demo-user';
                final result = await ExhibitionsService.registerForExhibition(
                  ex['id'].toString(),
                  craftsmanId,
                  'Crochet & Knitting', // Send the category to check capacity correctly
                );
                if (!mounted) return;
                if (result != null) {
                  final isStandby = result['registration']?['status'] == 'standby';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isStandby ? Colors.amber.shade700 : Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      content: Text(
                        isStandby
                            ? t('✅ تم تسجيلك في قائمة الاحتياط!', '✅ Added to standby list!')
                            : t('✅ تم التسجيل بنجاح كحرفي أساسي!', '✅ Registered successfully!'),
                        style: GoogleFonts.cairo(color: Colors.white),
                      ),
                    ),
                  );
                  _refresh();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      content: Text(
                        t('فشل التسجيل. حاول مجدداً.', 'Registration failed. Please try again.'),
                        style: GoogleFonts.cairo(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.amber.shade700 : Colors.green,
                foregroundColor: isFull ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(t('تأكيد', 'Confirm'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}