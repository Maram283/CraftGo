import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/exhibitions_service.dart';
import 'services/ai_service.dart';
import 'services/api_service.dart';

class AdminExhibitionScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AdminExhibitionScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AdminExhibitionScreen> createState() => _AdminExhibitionScreenState();
}

class _AdminExhibitionScreenState extends State<AdminExhibitionScreen> {
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

  Future<void> _runAIMatching(String exhibitionId, String exhibitionName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
              const SizedBox(width: 8),
              Text(
                t('ترشيح بالذكاء الاصطناعي', 'AI Matching'),
                style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.purpleAccent),
              const SizedBox(height: 16),
              Text(
                t('جاري تحليل قائمة الاحتياط لاختيار أفضل بديل...', 'Analyzing standby list to find the best replacement...'),
                style: GoogleFonts.cairo(color: dim, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    final matchResult = await AiService.matchStandby(exhibitionId);
    
    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (matchResult != null && matchResult['match'] != null) {
      final match = matchResult['match'];
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  t('تم اختيار بديل!', 'Replacement Selected!'),
                  style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t('الذكاء الاصطناعي يوصي بـ:', 'AI Recommends:'),
                          style: GoogleFonts.cairo(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  match['name']?.toString() ?? match['username']?.toString() ?? 'حرفي',
                  style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  match['specialty'] != null ? '${t('التخصص:', 'Specialty:')} ${match['specialty']}' : '',
                  style: GoogleFonts.cairo(color: dim, fontSize: 14),
                ),
                Text(
                  match['rating'] != null ? '${t('التقييم:', 'Rating:')} ⭐ ${match['rating']}' : '',
                  style: GoogleFonts.cairo(color: Colors.amber, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Text(
                  t('تم إرسال إشعار للحرفي لتأكيد مشاركته بدلاً من المعتذر.', 'A notification has been sent to the craftsman to confirm their participation.'),
                  style: GoogleFonts.cairo(color: dim, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _refresh();
                },
                child: Text(t('إغلاق', 'Close'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('لا يوجد بدلاء في قائمة الاحتياط أو حدث خطأ', 'No standby replacements available or an error occurred')),
          backgroundColor: Colors.redAccent,
        ),
      );
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
            icon: Icon(Icons.arrow_back_ios_new, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('إدارة معارضي', 'Manage My Exhibitions'),
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
        body: FutureBuilder<List<dynamic>>(
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
                    Icon(Icons.business_center, color: dim, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      t('لا توجد معارض لعرضها', 'No exhibitions to show'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            final exhibitions = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exhibitions.length,
              itemBuilder: (context, index) {
                final ex = exhibitions[index] as Map<String, dynamic>;
                
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
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.event, color: accent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex['name']?.toString() ?? 'معرض',
                                    style: GoogleFonts.cairo(
                                      color: text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ex['startDate'] != null
                                        ? ex['startDate'].toString().substring(0, 10)
                                        : 'TBD',
                                    style: GoogleFonts.cairo(color: dim, fontSize: 12),
                                  ),
                                  Text(
                                    ex['location']?.toString() ?? '',
                                    style: GoogleFonts.cairo(color: dim, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Actions
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.people, size: 18),
                                    label: Text(
                                      t('إدارة الحرفيين', 'Manage Craftsmen'),
                                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: surface,
                                      foregroundColor: text,
                                      side: BorderSide(color: border),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _runAIMatching(ex['id'].toString(), ex['name'].toString()),
                                icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                                label: Text(
                                  t('إيجاد بديل بالذكاء الاصطناعي', 'Find AI Replacement'),
                                  style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}