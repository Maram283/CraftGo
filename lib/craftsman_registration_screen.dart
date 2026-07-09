import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'craftsman_login_screen.dart';
import 'pending_verification_screen.dart';

class CraftsmanRegistrationScreen extends StatefulWidget {
  final Map<String, dynamic> selectedCategory;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const CraftsmanRegistrationScreen({
    super.key,
    required this.selectedCategory,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<CraftsmanRegistrationScreen> createState() =>
      _CraftsmanRegistrationScreenState();
}

class _CraftsmanRegistrationScreenState
    extends State<CraftsmanRegistrationScreen> {
  late bool isArabic;
  late bool isDarkMode;

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final int _totalSteps = 4;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  double _passwordStrength = 0.0;
  bool _isIdUploaded = false;
  bool _isPortfolioUploaded = false;
  String? _selectedCity;
  int _otpCountdown = 59;
  Timer? _otpTimer;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;

    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _otpTimer?.cancel();
    super.dispose();
  }

  void _startOtpTimer() {
    setState(() => _otpCountdown = 59);
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_otpCountdown > 0) {
        setState(() => _otpCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _checkPasswordStrength() {
    String p = _passwordController.text;
    double strength = 0;
    if (p.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(p)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(p)) strength += 0.25;
    if (RegExp(r'[!@#\$&*~]').hasMatch(p)) strength += 0.25;
    setState(() {
      _passwordStrength = strength;
    });
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrength == 0) return Colors.transparent;
    if (_passwordStrength <= 0.25) return Colors.red;
    if (_passwordStrength <= 0.75) return Colors.orange;
    return Colors.green;
  }

  String _getPasswordStrengthText() {
    if (_passwordStrength == 0) return "";
    if (_passwordStrength <= 0.25) return isArabic ? "ضعيفة" : "Weak";
    if (_passwordStrength <= 0.75) return isArabic ? "متوسطة" : "Medium";
    return isArabic ? "قوية" : "Strong";
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

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      if (_currentStep == 1) {
        _startOtpTimer();
      }
    } else {
      // Submit Action -> Go to pending verification
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PendingVerificationScreen(
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            onToggleLanguage: widget.onToggleLanguage,
            onToggleTheme: widget.onToggleTheme,
            selectedCategory: widget.selectedCategory,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final catTitle = isArabic
        ? widget.selectedCategory['titleAr']
        : widget.selectedCategory['titleEn'];
    final catIcon = widget.selectedCategory['icon'];

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topBarButton(
                      icon: isArabic
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      label: "",
                      onTap: _prevStep,
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

              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: List.generate(_totalSteps, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? const Color(0xFFD4A017)
                              : borderColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        const Color(0xFFD4A017).withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: const Color(0xFFD4A017)
                                          .withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    catIcon,
                                    size: 30,
                                    color: const Color(0xFFD4A017),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                isArabic ? "حساب جديد" : "Create Account",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.arefRuqaa(
                                  color: primaryTextColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isArabic
                                    ? "للانضمام كحرفي في مجال: $catTitle"
                                    : "Join as a craftsman in: $catTitle",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFD4A017),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Dynamic Steps
                              _buildCurrentStep(),

                              const SizedBox(height: 40),

                              // Action Buttons
                              Row(
                                children: [
                                  if (_currentStep > 0) ...[
                                    Expanded(
                                      flex: 1,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          side: BorderSide(color: borderColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: _prevStep,
                                        child: Text(
                                          isArabic ? "السابق" : "Back",
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                  Expanded(
                                    flex: 2,
                                    child: Container(
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
                                            color: const Color(0xFFF7B500)
                                                .withValues(alpha: 0.3),
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: _nextStep,
                                        child: Text(
                                          _currentStep == _totalSteps - 1
                                              ? (isArabic
                                                  ? "إنشاء الحساب"
                                                  : "Sign Up")
                                              : (isArabic ? "التالي" : "Next"),
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
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Already have an account
                              if (_currentStep == 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isArabic
                                          ? "لديك حساب بالفعل؟"
                                          : "Already have an account?",
                                      style:
                                          TextStyle(color: secondaryTextColor),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CraftsmanLoginScreen(
                                              isArabic: isArabic,
                                              isDarkMode: isDarkMode,
                                              onToggleLanguage: toggleLanguage,
                                              onToggleTheme: toggleTheme,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        isArabic ? "تسجيل الدخول" : "Login",
                                        style: const TextStyle(
                                          color: Color(0xFFD4A017),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(isArabic ? "البيانات الأساسية" : "Basic Info"),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "الاسم الرباعي" : "Full Name",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "رقم الهاتف" : "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          controller: _phoneController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "البريد الإلكتروني" : "Email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),
        _buildCitySelector(),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "كلمة المرور" : "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
        ),
        // Password Strength Indicator
        if (_passwordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12, left: 12),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      backgroundColor: borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _getPasswordStrengthColor()),
                      minHeight: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _getPasswordStrengthText(),
                  style: TextStyle(
                    color: _getPasswordStrengthColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "تأكيد كلمة المرور" : "Confirm Password",
          icon: Icons.lock_reset_outlined,
          isPassword: true,
          controller: _confirmPasswordController,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(isArabic ? "تأكيد رقم الهاتف" : "Verify Phone"),
        const SizedBox(height: 15),
        Text(
          isArabic
              ? "الرجاء إدخال رمز التحقق (OTP) المرسل إلى الرقم\n${_phoneController.text.isEmpty ? '****' : _phoneController.text}"
              : "Please enter the OTP sent to\n${_phoneController.text.isEmpty ? '****' : _phoneController.text}",
          style: TextStyle(color: secondaryTextColor, fontSize: 14),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: 60,
              height: 60,
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: inputFillColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFFD4A017), width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 1 && index < 3) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: _otpCountdown == 0 ? _startOtpTimer : null,
            child: Text(
              _otpCountdown > 0
                  ? (isArabic
                      ? "إعادة الإرسال بعد $_otpCountdown ثانية"
                      : "Resend code in ${_otpCountdown}s")
                  : (isArabic ? "إعادة إرسال الرمز" : "Resend Code"),
              style: TextStyle(
                color: _otpCountdown > 0
                    ? secondaryTextColor
                    : const Color(0xFFD4A017),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    String titleEn = widget.selectedCategory['titleEn'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(isArabic ? "تفاصيل الحرفة" : "Craft Details"),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "سنوات الخبرة" : "Years of Experience",
          icon: Icons.history,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          label: isArabic ? "نبذة عنك وعن أعمالك" : "Bio & Work Description",
          icon: Icons.info_outline,
          maxLines: 4,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: isArabic ? "توقع السعر (من)" : "Price from",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTextField(
                label: isArabic ? "إلى" : "To",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (titleEn == "Crochet & Knitting")
          _buildTextField(
            label: isArabic
                ? "هل توفر خدمة التفصيل حسب المقاس؟"
                : "Do you offer custom sizing?",
            icon: Icons.straighten,
          ),
        if (titleEn == "Pottery & Ceramics")
          _buildTextField(
            label:
                isArabic ? "ما هي أنواع الطين المستخدمة؟" : "Types of clay used?",
            icon: Icons.layers_outlined,
          ),
        if (titleEn == "Jewelry & Accessories")
          _buildTextField(
            label: isArabic
                ? "ما هي المعادن التي تعمل بها؟"
                : "Metals you work with?",
            icon: Icons.diamond_outlined,
          ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(isArabic ? "التوثيق والأمان" : "Verification"),
        const SizedBox(height: 10),
        Text(
          isArabic
              ? "تحميل صور أعمالك إلزامي لبدء استقبال الطلبات. أما صورة الهوية فهي اختيارية وتساعدك فقط في الحصول على شارة «أيدٍ موثوقة» لزيادة ثقة الزبائن."
              : "Uploading portfolio samples is required to start receiving orders. The National ID is optional and only needed to earn the \"Trusted Hands\" verification badge.",
          style: TextStyle(color: secondaryTextColor, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 16),
        
        // ── Visual Comparison for Trusted Hands ──
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: inputFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_outline, color: secondaryTextColor, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      isArabic ? "حساب عادي" : "Standard",
                      style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.5), width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.verified, color: Color(0xFFD4A017), size: 28),
                    const SizedBox(height: 6),
                    Text(
                      isArabic ? "أيدٍ موثوقة" : "Trusted Hands",
                      style: const TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Optional badge for ID
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFD4A017).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFD4A017), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isArabic
                      ? "صورة الهوية اختيارية — تمنحك شارة \u00abأيدٍ موثوقة\u00bb عند الموافقة عليها."
                      : "ID is optional — submitting it earns you the \"Trusted Hands\" badge after admin approval.",
                  style: const TextStyle(color: Color(0xFFD4A017), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildUploadButton(
          label: isArabic
              ? "صورة الهوية الوطنية (اختياري)"
              : "National ID Image (Optional)",
          icon: Icons.badge_outlined,
          isUploaded: _isIdUploaded,
          isOptional: true,
          onTap: _startAIVerification,
        ),
        const SizedBox(height: 15),
        _buildUploadButton(
          label:
              isArabic ? "صور نماذج من أعمالك" : "Portfolio Sample Images",
          icon: Icons.image_outlined,
          isUploaded: _isPortfolioUploaded,
          isOptional: false,
          onTap: () {
            setState(() => _isPortfolioUploaded = true);
          },
        ),
      ],
    );
  }

  void _startAIVerification() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: inputFillColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.document_scanner, size: 48, color: Color(0xFFD4A017)),
                const SizedBox(height: 16),
                Text(
                  isArabic ? "الذكاء الاصطناعي يتحقق من الهوية..." : "AI is verifying ID...",
                  style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: Color(0xFFD4A017)),
              ],
            ),
          ),
        );
      }
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pop(context); // close scanning dialog
      
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: inputFillColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? "تم التحقق بنجاح!" : "Verified Successfully!",
                    style: TextStyle(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic 
                        ? "دقة التطابق: 98%\nتم توثيق الهوية عبر الذكاء الاصطناعي وتقليل وقت المراجعة." 
                        : "Match Confidence: 98%\nID verified by AI, reducing admin review time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _isIdUploaded = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isArabic ? "متابعة" : "Continue",
                      style: const TextStyle(color: Color(0xFF0D1420), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A017),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: primaryTextColor),
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded
              ? const Color(0xFFD4A017).withValues(alpha: 0.05)
              : inputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isUploaded ? const Color(0xFFD4A017) : borderColor,
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon,
                      color: isUploaded
                          ? const Color(0xFFD4A017)
                          : secondaryTextColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: isUploaded
                                ? const Color(0xFFD4A017)
                                : primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isOptional)
                          Text(
                            isArabic
                                ? "سيمنحك شارة «أيدٍ موثوقة»"
                                : "Earns \"Trusted Hands\" badge",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isUploaded)
              const Icon(Icons.check_circle, color: Colors.green),
            if (!isUploaded)
              Icon(Icons.upload_file, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    return InkWell(
      onTap: _showCityPickerSheet,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: inputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: secondaryTextColor),
                const SizedBox(width: 12),
                Text(
                  _selectedCity ?? (isArabic ? "المدينة" : "City"),
                  style: TextStyle(
                    color: _selectedCity != null ? primaryTextColor : secondaryTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, color: secondaryTextColor),
          ],
        ),
      ),
    );
  }

  void _showCityPickerSheet() {
    final List<String> cities = isArabic
        ? ["نابلس", "رام الله", "الخليل", "جنين", "بيت لحم", "طولكرم", "أريحا", "قلقيلية", "سلفيت", "طوباس", "غزة", "القدس"]
        : ["Nablus", "Ramallah", "Hebron", "Jenin", "Bethlehem", "Tulkarm", "Jericho", "Qalqilya", "Salfit", "Tubas", "Gaza", "Jerusalem"];

    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        bool localLocating = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isArabic ? "تحديد المدينة" : "Select City",
                    style: GoogleFonts.cairo(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Option 1: GPS Auto Detect
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017).withValues(alpha: 0.15),
                      foregroundColor: const Color(0xFFD4A017),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFD4A017), width: 1.5),
                      ),
                    ),
                    onPressed: localLocating
                        ? null
                         : () {
                            setModalState(() => localLocating = true);
                            final nav = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            Future.delayed(const Duration(milliseconds: 1500), () {
                              if (!mounted) return;
                              if (nav.canPop()) {
                                nav.pop();
                                setState(() {
                                  _selectedCity = isArabic ? "نابلس" : "Nablus";
                                });
                                messenger.showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    content: Text(
                                      isArabic
                                          ? "تم تحديد موقعك تلقائياً: نابلس"
                                          : "Location resolved automatically: Nablus",
                                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                    icon: localLocating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Color(0xFFD4A017))),
                          )
                        : const Icon(Icons.gps_fixed),
                    label: Text(
                      localLocating
                          ? (isArabic ? "جاري تحديد الموقع..." : "Detecting Location...")
                          : (isArabic ? "تحديد تلقائي عبر GPS" : "Auto-detect via GPS"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: borderColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          isArabic ? "أو اختر المدينة يدوياً" : "Or select city manually",
                          style: TextStyle(color: secondaryTextColor, fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: borderColor)),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Option 2: Cities Dropdown/Grid
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: false,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          final isSel = _selectedCity == city;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCity = city;
                              });
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFD4A017).withValues(alpha: 0.15) : inputFillColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSel ? const Color(0xFFD4A017) : borderColor),
                              ),
                              child: Text(
                                city,
                                style: GoogleFonts.cairo(
                                  color: isSel ? const Color(0xFFD4A017) : primaryTextColor,
                                  fontSize: 13,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                    ),
                  ),
                ],
              ),
            ),
            );
          },
        );
      },
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
