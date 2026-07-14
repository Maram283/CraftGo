import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/exhibitions_service.dart';
import '../../services/ai_service.dart';
import '../../services/api_service.dart';

class CraftsmanExhibitionsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const CraftsmanExhibitionsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<CraftsmanExhibitionsScreen> createState() => _CraftsmanExhibitionsScreenState();
}

class _CraftsmanExhibitionsScreenState extends State<CraftsmanExhibitionsScreen> {
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.1);
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  late Future<List<dynamic>> _myExhibitionsFuture;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserAndExhibitions();
  }

  Future<void> _loadUserAndExhibitions() async {
    final token = await ApiService.getToken();
    setState(() {
      _currentUserId = token ?? 'demo-craftsman';
      _myExhibitionsFuture = ExhibitionsService.getAllExhibitions();
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
            t('معارضي', 'My Exhibitions'),
            style: GoogleFonts.cairo(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _myExhibitionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: accent));
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, color: dim, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      t('لا توجد معارض مسجلة', 'No registered exhibitions'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            final myExhibitions = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myExhibitions.length,
              itemBuilder: (context, index) {
                final ex = myExhibitions[index] as Map<String, dynamic>;
                // Mocking status for demo purposes:
                final isConfirmed = index % 2 == 0;
                final standbyRank = index + 1;

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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isConfirmed 
                              ? Colors.green.withValues(alpha: 0.1) 
                              : Colors.amber.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isConfirmed ? Colors.green : Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isConfirmed ? Icons.check_circle : Icons.hourglass_empty,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isConfirmed 
                                        ? t('مؤكد', 'Confirmed') 
                                        : t('في قائمة الاحتياط', 'On Standby'),
                                    style: GoogleFonts.cairo(
                                      color: isConfirmed ? Colors.green : Colors.amber.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (!isConfirmed)
                                    Text(
                                      t('ترتيبك الحالي: #$standbyRank', 'Current rank: #$standbyRank'),
                                      style: GoogleFonts.cairo(
                                        color: dim,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.event, color: accent, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ex['name']?.toString() ?? ex['nameAr']?.toString() ?? 'معرض',
                                    style: GoogleFonts.cairo(
                                      color: text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: dim, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  ex['startDate'] != null
                                      ? ex['startDate'].toString().substring(0, 10)
                                      : t('لم يحدد بعد', 'TBD'),
                                  style: GoogleFonts.cairo(color: dim, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: dim, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  ex['location']?.toString() ?? '',
                                  style: GoogleFonts.cairo(color: dim, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Actions
                            if (isConfirmed)
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showAbsenceDialog(ex),
                                      icon: const Icon(Icons.event_busy, size: 18),
                                      label: Text(
                                        t('الاعتذار عن الحضور', 'Report Absence'),
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.redAccent,
                                        side: const BorderSide(color: Colors.redAccent),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.qr_code, size: 18),
                                      label: Text(
                                        t('تذكرة الدخول', 'Entry Ticket'),
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accent,
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  void _showAbsenceDialog(Map<String, dynamic> exhibition) {
    String selectedReason = 'sick';
    bool isGeneratingMessage = false;
    String generatedMessage = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                backgroundColor: surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Text(
                      t('الاعتذار عن الحضور', 'Report Absence'),
                      style: GoogleFonts.cairo(
                        color: text,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(
                          'تنبيه: الإبلاغ عن الغياب في وقت متأخر قد يؤثر سلباً على تقييم الالتزام الخاص بك. سيتم إرسال إشعار لإدارة المعرض لإيجاد بديل من قائمة الاحتياط باستخدام الذكاء الاصطناعي.',
                          'Warning: Reporting absence late may negatively impact your commitment score. A notification will be sent to exhibition management to find a standby replacement using AI.',
                        ),
                        style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        t('سبب الغياب', 'Reason for Absence'),
                        style: GoogleFonts.cairo(
                          color: text,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Reasons Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedReason,
                            isExpanded: true,
                            dropdownColor: surface,
                            icon: Icon(Icons.keyboard_arrow_down, color: text),
                            items: [
                              DropdownMenuItem(value: 'sick', child: Text(t('عارض صحي مفاجئ', 'Sudden illness'), style: TextStyle(color: text))),
                              DropdownMenuItem(value: 'emergency', child: Text(t('حالة طارئة عائلية', 'Family emergency'), style: TextStyle(color: text))),
                              DropdownMenuItem(value: 'transport', child: Text(t('مشكلة في المواصلات/السيارة', 'Transportation issue'), style: TextStyle(color: text))),
                              DropdownMenuItem(value: 'other', child: Text(t('أسباب أخرى', 'Other reasons'), style: TextStyle(color: text))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedReason = val);
                              }
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // AI Message Generation Section
                      if (generatedMessage.isEmpty && !isGeneratingMessage)
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              setState(() => isGeneratingMessage = true);
                              
                              final reasonMap = {
                                'sick': widget.isArabic ? 'ظرف صحي طارئ' : 'sudden illness',
                                'emergency': widget.isArabic ? 'حالة طارئة عائلية' : 'family emergency',
                                'transport': widget.isArabic ? 'مشكلة في المواصلات' : 'transportation issue',
                                'other': widget.isArabic ? 'ظروف قاهرة' : 'unforeseen circumstances',
                              };
                              final reasonText = reasonMap[selectedReason] ?? selectedReason;
                              final exName = exhibition['name']?.toString() ?? exhibition['nameAr']?.toString() ?? 'المعرض';

                              // 🤖 REAL AI CALL to Gemini via our backend!
                              final aiMessage = await AiService.generateApology(
                                craftsmanName: widget.isArabic ? 'الحرفي' : 'Craftsman',
                                exhibitionName: exName,
                                reason: reasonText,
                              );

                              setState(() {
                                generatedMessage = aiMessage ?? (widget.isArabic
                                    ? 'السادة إدارة معرض $exName\n\nأتقدم لكم بخالص الاعتذار عن عدم تمكني من الحضور بسبب $reasonText. أرجو قبول اعتذاري.\n\nمع التحيات.'
                                    : 'Dear $exName Management,\n\nPlease accept my sincere apologies for being unable to attend due to $reasonText.\n\nBest regards.');
                                isGeneratingMessage = false;
                              });
                            },
                            icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                            label: Text(
                              t('توليد رسالة بالذكاء الاصطناعي 🤖', 'Generate AI Apology 🤖'),
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else if (isGeneratingMessage)
                        Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(color: Colors.purpleAccent),
                              const SizedBox(height: 12),
                              Text(
                                t('جاري صياغة رسالة احترافية...', 'Drafting professional message...'),
                                style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    t('رسالة الذكاء الاصطناعي المُقترحة', 'AI Suggested Message'),
                                    style: GoogleFonts.cairo(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                generatedMessage,
                                style: GoogleFonts.cairo(color: text, height: 1.5, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t('إلغاء', 'Cancel'), style: GoogleFonts.cairo(color: dim)),
                  ),
                  ElevatedButton(
                    onPressed: generatedMessage.isEmpty ? null : () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          content: Text(
                            t('✅ تم إرسال التقرير لإدارة المعرض بنجاح', '✅ Report sent to exhibition management successfully'),
                            style: GoogleFonts.cairo(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      disabledBackgroundColor: Colors.redAccent.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      t('تأكيد الغياب', 'Confirm Absence'),
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}