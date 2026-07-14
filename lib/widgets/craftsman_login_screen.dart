import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/artisan/craftsman_dashboard.dart';

class CraftsmanLoginScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const CraftsmanLoginScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<CraftsmanLoginScreen> createState() => _CraftsmanLoginScreenState();
}

class _CraftsmanLoginScreenState extends State<CraftsmanLoginScreen> {
  late bool isArabic;
  late bool isDarkMode;

  final _formKey = GlobalKey<FormState>();

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

  Color get secondaryTextColor => isDarkMode ? Colors.white70 : Colors.black54;

  Color get inputFillColor =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get borderColor => isDarkMode ? Colors.white12 : Colors.black12;

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

  @override
  Widget build(BuildContext context) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topBarButton(
                      icon: isArabic
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
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
              ),

              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              // Header Icon
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFFD4A017,
                                    ).withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFD4A017,
                                      ).withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.login,
                                    size: 40,
                                    color: Color(0xFFD4A017),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Title
                              Text(
                                isArabic ? "تسجيل الدخول" : "Login",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.arefRuqaa(
                                  color: primaryTextColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isArabic
                                    ? "أهلاً بك مجدداً في مجتمع الحرفيين"
                                    : "Welcome back to the craftsmen community",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Fields
                              _buildTextField(
                                label: isArabic
                                    ? "البريد الإلكتروني أو رقم الهاتف"
                                    : "Email or Phone",
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label: isArabic ? "كلمة المرور" : "Password",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              const SizedBox(height: 15),

                              // Forgot Password
                              Align(
                                alignment: isArabic
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    isArabic
                                        ? "نسيت كلمة المرور؟"
                                        : "Forgot Password?",
                                    style: const TextStyle(
                                      color: Color(0xFFD4A017),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Login Button
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF7B500),
                                      Color(0xFFD89A00),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFF7B500,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CraftsmanDashboard(
                                          isArabic: isArabic,
                                          isDarkMode: isDarkMode,
                                          onToggleLanguage:
                                              widget.onToggleLanguage,
                                          onToggleTheme: widget.onToggleTheme,
                                          categoryTitleAr: 'حرفي', // Dummy data
                                          categoryTitleEn: 'Craftsman',
                                          name: 'حرفي مبدع',
                                          city: 'فلسطين',
                                          experience: '5 سنوات',
                                          bio: 'شغوف بصناعة أجمل القطع الفنية',
                                          isVerified: true,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    isArabic ? "دخول" : "Login",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      style: TextStyle(color: primaryTextColor),
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryTextColor),
        prefixIcon: Icon(icon, color: secondaryTextColor),
        filled: true,
        fillColor: inputFillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
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
