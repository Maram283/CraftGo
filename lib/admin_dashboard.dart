import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const AdminDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late bool isArabic;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
  }

  // Colors mapping
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);

  Color get topIconColor => isDarkMode ? Colors.white : Colors.black87;

  Color get topButtonBackground =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get chipBorderColor => isDarkMode ? Colors.white12 : Colors.black12;

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
    widget.onToggleLanguage();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    widget.onToggleTheme();
  }

  // Mock pending verifications
  List<Map<String, String>> get verifications => [
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

  // Mock active disputes
  List<Map<String, String>> get disputes => [
        {
          "orderAr": "تفصيل طاولة سفرة خشبية",
          "orderEn": "Custom wooden dining table",
          "amount": "400 JOD",
          "partiesAr": "منصور (زبون) 🆚 كمال (حرفي)",
          "partiesEn": "Mansour (Client) 🆚 Kamal (Craftsman)"
        }
      ];

  @override
  Widget build(BuildContext context) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topBarButton(
                        icon: isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                        label: "",
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _topBarButton(
                            icon: Icons.language,
                            label: isArabic ? "EN" : "عربي",
                            onTap: toggleLanguage,
                          ),
                          const SizedBox(width: 10),
                          _topBarButton(
                            icon: isDarkMode
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            label: "",
                            onTap: toggleTheme,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Header title
                  Text(
                    isArabic ? "لوحة الإشراف العام" : "Admin Overview Dashboard",
                    style: GoogleFonts.arefRuqaa(
                      color: primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isArabic ? "إدارة الطلبات والنزاعات وتوثيق الحسابات" : "Manage orders, disputes, and verifications",
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
                        title: isArabic ? "ودائع الضمان" : "Escrow Deposits",
                        value: "14,350 JOD",
                        icon: Icons.lock_clock_outlined,
                      ),
                      _buildStatCard(
                        title: isArabic ? "عمولة النظام" : "Platform Income",
                        value: "1,435 JOD",
                        icon: Icons.account_balance_outlined,
                      ),
                      _buildStatCard(
                        title: isArabic ? "حسابات الحرفيين" : "Craftsmen count",
                        value: "124",
                        icon: Icons.engineering_outlined,
                      ),
                      _buildStatCard(
                        title: isArabic ? "الزبائن النشطين" : "Active Clients",
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
                        isArabic ? "طلبات توثيق أيدٍ موثوقة" : "Trusted Hands Requests",
                        style: GoogleFonts.arefRuqaa(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withOpacity(0.12),
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
                        name: isArabic ? item["nameAr"]! : item["nameEn"]!,
                        craft: isArabic ? item["craftAr"]! : item["craftEn"]!,
                        date: item["date"]!,
                        index: index,
                      );
                    },
                  ),
                  const SizedBox(height: 35),

                  // Section 2: Active Disputes
                  Text(
                    isArabic ? "نزاعات تجارية معلقة" : "Ongoing Trade Disputes",
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
                        order: isArabic ? dispute["orderAr"]! : dispute["orderEn"]!,
                        amount: dispute["amount"]!,
                        parties: isArabic ? dispute["partiesAr"]! : dispute["partiesEn"]!,
                      );
                    },
                  ),
                ],
              ),
            ),
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
        color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
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
                          color: secondaryTextColor.withOpacity(0.6),
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
    );
  }

  Widget _buildDisputeCard({
    required String order,
    required String amount,
    required String parties,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.5),
        color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
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
                const SizedBox(height: 16),

                // Dispute Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        isArabic ? "مراجعة التفاصيل" : "Review Details",
                        style: const TextStyle(
                          color: Color(0xFFD4A017),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: topButtonBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: topIconColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: topIconColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
