import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model classes
class Dispute {
  final String id;
  final String orderName;
  final double escrowAmount;
  final String clientName;
  final String craftsmanName;
  final List<ChatMessage> messages;

  Dispute({
    required this.id,
    required this.orderName,
    required this.escrowAmount,
    required this.clientName,
    required this.craftsmanName,
    required this.messages,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isSystem;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    this.isSystem = false,
  });
}

// Main Widget
class AdminDisputesScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AdminDisputesScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AdminDisputesScreen> createState() => _AdminDisputesScreenState();
}

class _AdminDisputesScreenState extends State<AdminDisputesScreen> {
  Dispute? _selectedDispute;
  late List<Dispute> _disputes;

  @override
  void initState() {
    super.initState();
    _disputes = [
      Dispute(
        id: 'DSP-10024',
        orderName: widget.isArabic ? 'تركيب مطبخ خشبي' : 'Wooden Kitchen Installation',
        escrowAmount: 1500.0,
        clientName: widget.isArabic ? 'أحمد محمد' : 'Ahmed Mohammed',
        craftsmanName: widget.isArabic ? 'يوسف النجار' : 'Youssef Carpenter',
        messages: [
          ChatMessage(
            sender: 'System',
            text: widget.isArabic ? 'تم فتح نزاع بواسطة أحمد محمد' : 'Dispute opened by Ahmed Mohammed',
            time: '10:00 AM',
            isSystem: true,
          ),
          ChatMessage(
            sender: widget.isArabic ? 'أحمد محمد' : 'Ahmed Mohammed',
            text: widget.isArabic ? 'العمل لم يكتمل كما تم الاتفاق عليه، وهناك عيوب في التركيب.' : 'The work is not completed as agreed upon, and there are installation defects.',
            time: '10:05 AM',
          ),
          ChatMessage(
            sender: widget.isArabic ? 'يوسف النجار' : 'Youssef Carpenter',
            text: widget.isArabic ? 'لقد أنهيت العمل والخشب من أفضل الأنواع، يمكنكم التحقق.' : 'I finished the work and the wood is top quality, you can check.',
            time: '10:20 AM',
          ),
        ]
      ),
      Dispute(
        id: 'DSP-10025',
        orderName: widget.isArabic ? 'إصلاح تسريب مياه' : 'Water Leak Repair',
        escrowAmount: 200.0,
        clientName: widget.isArabic ? 'سارة علي' : 'Sarah Ali',
        craftsmanName: widget.isArabic ? 'محمود السباك' : 'Mahmoud Plumber',
        messages: [
           ChatMessage(
            sender: 'System',
            text: widget.isArabic ? 'تم فتح نزاع بواسطة سارة علي' : 'Dispute opened by Sarah Ali',
            time: '01:00 PM',
            isSystem: true,
          ),
          ChatMessage(
            sender: widget.isArabic ? 'سارة علي' : 'Sarah Ali',
            text: widget.isArabic ? 'التسريب عاد بعد مغادرة الحرفي بساعة.' : 'The leak returned an hour after the craftsman left.',
            time: '01:15 PM',
          ),
        ]
      )
    ];
  }

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    final bgColor = widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
    final surfaceColor = widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
    final accentColor = widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = widget.isDarkMode ? Colors.white70 : Colors.black54;

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 750;

    Widget listPane = Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Row(
              children: [
                Icon(Icons.gavel, color: accentColor),
                const SizedBox(width: 12),
                Text(
                  t('النزاعات النشطة', 'Active Disputes'),
                  style: GoogleFonts.arefRuqaa(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _disputes.length,
              itemBuilder: (context, index) {
                final dispute = _disputes[index];
                final isSelected = _selectedDispute?.id == dispute.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDispute = dispute;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? accentColor.withValues(alpha: 0.1) 
                        : bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? accentColor : Colors.transparent,
                        width: 1.5,
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dispute.id,
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${dispute.escrowAmount.toStringAsFixed(2)} JD',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          dispute.orderName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: subTextColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                dispute.clientName, 
                                style: TextStyle(color: subTextColor, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(t('ضد', 'vs'), style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Icon(Icons.handyman, size: 14, color: subTextColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                dispute.craftsmanName, 
                                style: TextStyle(color: subTextColor, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              t('مراجعـة المحادثـة ←', 'Review Chat ←'),
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    Widget detailsPane = Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: _selectedDispute == null 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.question_answer_rounded, size: 80, color: accentColor.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  Text(
                    t('اختر نزاعاً لمراجعة المحادثة وتفاصيل القضية', 'Select a dispute to review chat and case details'),
                    style: TextStyle(color: subTextColor, fontSize: 16),
                  ),
                ],
              ),
            )
          : _buildDisputeDetails(_selectedDispute!, textColor, subTextColor, accentColor, bgColor, surfaceColor, isMobile),
    );

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        color: bgColor,
        padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
        child: isMobile
            ? (_selectedDispute == null ? listPane : detailsPane)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: listPane,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: detailsPane,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDisputeDetails(Dispute dispute, Color textColor, Color subTextColor, Color accentColor, Color bgColor, Color surfaceColor, bool isMobile) {
    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isMobile) ...[
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: accentColor,
                        onPressed: () {
                          setState(() {
                            _selectedDispute = null;
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                t('تفاصيل النزاع', 'Dispute Details'),
                                style: GoogleFonts.arefRuqaa(
                                  color: textColor,
                                  fontSize: isMobile ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  dispute.id,
                                  style: TextStyle(color: subTextColor, fontSize: isMobile ? 11 : 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dispute.orderName,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: isMobile ? 14 : 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.2),
                      accentColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t('مبلغ الضمان', 'Escrow Amount'),
                      style: TextStyle(color: subTextColor, fontSize: isMobile ? 10 : 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dispute.escrowAmount.toStringAsFixed(2)} JD',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 16 : 20,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(color: textColor.withValues(alpha: 0.05), height: 1),
        // Chat Timeline
        Expanded(
          child: Container(
            color: bgColor.withValues(alpha: 0.5),
            child: ListView.builder(
              padding: EdgeInsets.all(isMobile ? 12 : 24),
              physics: const BouncingScrollPhysics(),
              itemCount: dispute.messages.length,
              itemBuilder: (context, index) {
                final msg = dispute.messages[index];
                if (msg.isSystem) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ),
                  );
                }
                
                final isClient = msg.sender == dispute.clientName;
                
                return Align(
                  alignment: isClient 
                      ? (widget.isArabic ? Alignment.centerRight : Alignment.centerLeft) 
                      : (widget.isArabic ? Alignment.centerLeft : Alignment.centerRight),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? MediaQuery.of(context).size.width * 0.75
                          : MediaQuery.of(context).size.width * 0.35,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isClient ? accentColor.withValues(alpha: 0.1) : surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isClient ? accentColor.withValues(alpha: 0.2) : textColor.withValues(alpha: 0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: isClient ? accentColor.withValues(alpha: 0.2) : textColor.withValues(alpha: 0.1),
                              child: Icon(isClient ? Icons.person : Icons.handyman, size: 14, color: isClient ? accentColor : subTextColor),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                msg.sender,
                                style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              msg.time,
                              style: TextStyle(color: subTextColor.withValues(alpha: 0.5), fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          msg.text,
                          style: TextStyle(color: textColor.withValues(alpha: 0.9), fontSize: 15, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Actions
        Container(
          padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            )
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final resolvedId = dispute.id;
                    setState(() {
                      _disputes.removeWhere((d) => d.id == resolvedId);
                      _selectedDispute = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t('تم إرجاع المبلغ للزبون وإنهاء النزاع', 'Amount refunded to client and dispute closed')),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.assignment_return, size: 18),
                  label: Text(
                    t('إرجاع للزبون', 'Refund Client'),
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDarkMode ? const Color(0xFF3B1A1A) : Colors.red.shade50,
                    foregroundColor: widget.isDarkMode ? Colors.redAccent : Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: widget.isDarkMode ? Colors.redAccent.withValues(alpha: 0.3) : Colors.red.shade200)
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final resolvedId = dispute.id;
                    setState(() {
                      _disputes.removeWhere((d) => d.id == resolvedId);
                      _selectedDispute = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t('تم تحرير الدفعة للحرفي بنجاح', 'Payment successfully released to craftsman')),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    t('تحرير للحرفي', 'Release Payment'),
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDarkMode ? const Color(0xFF1A3B2A) : Colors.green.shade50,
                    foregroundColor: widget.isDarkMode ? Colors.greenAccent : Colors.green.shade700,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: widget.isDarkMode ? Colors.greenAccent.withValues(alpha: 0.3) : Colors.green.shade200)
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
