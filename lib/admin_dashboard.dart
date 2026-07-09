import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_detail_screen.dart';

class AdminDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final Function(int)? onNavigateTab;

  const AdminDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    this.onNavigateTab,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  // Colors mapping
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => widget.isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      widget.isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      widget.isDarkMode ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08);

  Color get topIconColor => widget.isDarkMode ? Colors.white : Colors.black87;

  Color get topButtonBackground =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get chipBorderColor => widget.isDarkMode ? Colors.white12 : Colors.black12;

  late List<Map<String, String>> verifications;
  late List<Map<String, String>> disputes;

  @override
  void initState() {
    super.initState();
    verifications = [
      {
        "nameAr": "سمير القحطاني",
        "nameEn": "Sameer Al-Qahtani",
        "craftAr": "الفخار والخزف",
        "craftEn": "Pottery & Ceramics",
        "date": "أمس"
      },
      {
        "nameAr": "رنا العبدالله",
        "nameEn": "Rana Al-Abdullah",
        "craftAr": "خياطة وتطريز",
        "craftEn": "Crochet & Knitting",
        "date": "قبل يومين"
      }
    ];
    disputes = [
      {
        "orderAr": "تفصيل طاولة سفرة خشبية",
        "orderEn": "Custom wooden dining table",
        "amount": "400 JOD",
        "partiesAr": "منصور (زبون) 🆚 كمال (حرفي)",
        "partiesEn": "Mansour (Client) 🆚 Kamal (Craftsman)"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

                  // Header title
                  Text(
                    widget.isArabic ? "لوحة الإشراف العام" : "Admin Overview Dashboard",
                    style: GoogleFonts.arefRuqaa(
                      color: primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isArabic ? "إدارة الطلبات والنزاعات وتوثيق الحسابات" : "Manage orders, disputes, and verifications",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Analytics Stats Grid (2 columns)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard(
                        title: widget.isArabic ? "ودائع الضمان" : "Escrow Deposits",
                        value: "14,350 JOD",
                        icon: Icons.lock_clock_outlined,
                      ),
                      _buildStatCard(
                        title: widget.isArabic ? "عمولة النظام" : "Platform Income",
                        value: "1,435 JOD",
                        icon: Icons.account_balance_outlined,
                      ),
                      _buildStatCard(
                        title: widget.isArabic ? "حسابات الحرفيين" : "Craftsmen count",
                        value: "124",
                        icon: Icons.engineering_outlined,
                      ),
                      _buildStatCard(
                        title: widget.isArabic ? "الزبائن النشطين" : "Active Clients",
                        value: "830",
                        icon: Icons.people_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  // Section 1: Verification Requests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isArabic ? "طلبات توثيق أيدٍ موثوقة" : "Trusted Hands Requests",
                        style: GoogleFonts.arefRuqaa(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${verifications.length}",
                          style: const TextStyle(
                            color: Color(0xFFD4A017),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: verifications.length,
                    itemBuilder: (context, index) {
                      final item = verifications[index];
                      return _buildVerifyCard(
                        name: widget.isArabic ? item["nameAr"]! : item["nameEn"]!,
                        craft: widget.isArabic ? item["craftAr"]! : item["craftEn"]!,
                        date: item["date"]!,
                        index: index,
                      );
                    },
                  ),
                  const SizedBox(height: 35),

                  // Section: Pending Exhibitions (AI Analyzed)
                  Text(
                    widget.isArabic ? "معارض بانتظار الموافقة" : "Pending Exhibitions",
                    style: GoogleFonts.arefRuqaa(
                      color: primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildExhibitionApprovalCard(),
                  const SizedBox(height: 35),

                  // Section 2: Active Disputes
                  Text(
                    widget.isArabic ? "نزاعات تجارية معلقة" : "Ongoing Trade Disputes",
                    style: GoogleFonts.arefRuqaa(
                      color: primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: disputes.length,
                    itemBuilder: (context, index) {
                      final dispute = disputes[index];
                      return _buildDisputeCard(
                        order: widget.isArabic ? dispute["orderAr"]! : dispute["orderEn"]!,
                        amount: dispute["amount"]!,
                        parties: widget.isArabic ? dispute["partiesAr"]! : dispute["partiesEn"]!,
                      );
                    },
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFFD4A017), size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyCard({
    required String name,
    required String craft,
    required String date,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        if (widget.onNavigateTab != null) widget.onNavigateTab!(2);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cardBorderColor, width: 1.5),
          color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        craft,
                        style: const TextStyle(
                          color: Color(0xFFD4A017),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: TextStyle(
                          color: secondaryTextColor.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Accept/Reject buttons
                Row(
                  children: [
                    // Reject (Red border)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          verifications.removeAt(index);
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    // Accept (Gold circle)
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.check, color: Colors.black, size: 20),
                        onPressed: () {
                          setState(() {
                            verifications.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildDisputeCard({
    required String order,
    required String amount,
    required String parties,
  }) {
    return GestureDetector(
      onTap: () {
        if (widget.onNavigateTab != null) widget.onNavigateTab!(3);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cardBorderColor, width: 1.5),
          color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      parties,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Color(0xFFD4A017),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  order,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white12, thickness: 1),
                const SizedBox(height: 8),

                // Dispute Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isArabic ? "بانتظار تدخلك لحل النزاع" : "Awaiting your intervention",
                      style: TextStyle(
                        color: Colors.redAccent.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.isArabic ? "مراجعة التفاصيل" : "Review Details",
                          style: const TextStyle(
                            color: Color(0xFFD4A017),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFFD4A017),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildExhibitionApprovalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.storefront, color: Colors.blueAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isArabic ? "معرض ألوان الخريف" : "Autumn Colors Exhibition",
                      style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.isArabic ? "مقدم من: رامي خالد" : "By: Rami Khalid",
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // AI Analysis Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      widget.isArabic ? "تحليل الذكاء الاصطناعي (ثقة 65%)" : "AI Analysis (65% Trust)",
                      style: GoogleFonts.cairo(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.isArabic ? "الموقع ممتاز والتواريخ مناسبة لموسم العطلات." : "Great location and dates fit the holiday season.", style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 12))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.isArabic ? "حساب جديد ولم يرفق صور كافية لمساحة المعرض." : "New account, not enough photos of the exhibition space.", style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 12))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          isArabic: widget.isArabic,
                          isDarkMode: widget.isDarkMode,
                          name: widget.isArabic ? "رامي خالد" : "Rami Khalid",
                          craft: widget.isArabic ? "صاحب معرض" : "Exhibition Owner",
                          online: true,
                          orderTitle: widget.isArabic ? "معرض ألوان الخريف" : "Autumn Colors Exhibition",
                          orderStatus: "in_progress",
                          orderPrice: "-",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.blueAccent),
                  label: Text(widget.isArabic ? "مراسلة" : "Message", style: const TextStyle(color: Colors.blueAccent)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blueAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text(widget.isArabic ? "قبول" : "Approve", style: const TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
