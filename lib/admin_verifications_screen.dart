import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminVerificationsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AdminVerificationsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AdminVerificationsScreen> createState() => _AdminVerificationsScreenState();
}

class _AdminVerificationsScreenState extends State<AdminVerificationsScreen> {
  String t(String ar, String en) => widget.isArabic ? ar : en;

  Color get bgColor => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surfaceColor => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get accentColor => widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);
  Color get textColor => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get subtitleColor => widget.isDarkMode ? Colors.white70 : Colors.black54;

  final List<Map<String, dynamic>> requests = [
    {
      'nameAr': 'أحمد محمود',
      'nameEn': 'Ahmed Mahmoud',
      'craftAr': 'نجار',
      'craftEn': 'Carpenter',
      'date': '2026-10-12',
      'expanded': false,
    },
    {
      'nameAr': 'خالد عبدالله',
      'nameEn': 'Khalid Abdullah',
      'craftAr': 'كهربائي',
      'craftEn': 'Electrician',
      'date': '2026-10-14',
      'expanded': false,
    },
    {
      'nameAr': 'يوسف علي',
      'nameEn': 'Yousef Ali',
      'craftAr': 'سباك',
      'craftEn': 'Plumber',
      'date': '2026-10-15',
      'expanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Text(
                t('طلبات التوثيق', 'Verification Requests'),
                style: GoogleFonts.arefRuqaa(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];
                  return _buildRequestCard(req, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req, int index) {
    final bool isExpanded = req['expanded'];
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                req['expanded'] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: accentColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t(req['nameAr'], req['nameEn']),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${t(req['craftAr'], req['craftEn'])} • ${req['date']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: subtitleColor,
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 24),
                    Divider(color: textColor.withValues(alpha: 0.1)),
                    const SizedBox(height: 16),
                    Text(
                      t('المستندات المرفقة', 'Attached Documents'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDocPlaceholder(Icons.badge_outlined, t('الهوية الوطنية', 'National ID')),
                        const SizedBox(width: 16),
                        _buildDocPlaceholder(Icons.workspace_premium_outlined, t('شهادة الحرفة', 'Craft Certificate')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                requests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(t('تم رفض طلب التوثيق', 'Verification request rejected')),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              t('رفض', 'Reject'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  accentColor,
                                  widget.isDarkMode ? const Color(0xFFE8B632) : const Color(0xFF1E3A6D),
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  requests.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(t('تم قبول طلب التوثيق بنجاح', 'Verification request approved successfully')),
                                    backgroundColor: accentColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: widget.isDarkMode ? Colors.black87 : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                t('قبول التوثيق', 'Approve'),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocPlaceholder(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: subtitleColor),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
