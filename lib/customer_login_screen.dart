import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'api_service.dart';
import 'main_shell.dart';

class CustomerLoginScreen extends StatefulWidget {
  // These are still accepted so screens that already pass them compile,
  // but theme/language are now read from AppState, not stored locally.
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  // Kept for backwards compat with callers that still pass these callbacks.
  // They're no longer used — AppState drives navigation after login.
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onGuestAccess;

  const CustomerLoginScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    this.onLoginSuccess,
    this.onGuestAccess,
  });

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Read live from AppState so toggles actually work
  bool get isArabic => context.watch<AppState>().isArabic;
  bool get isDarkMode => context.watch<AppState>().isDarkMode;

  Color get bg => isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white70 : Colors.black54;
  Color get borderColor => isDarkMode ? Colors.white12 : Colors.black12;
  Color get topBtnBg => isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  // ─── Main action ─────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError(isArabic ? 'يرجى ملء جميع الحقول' : 'Please fill all fields');
      return;
    }

    if (!_isLogin) {
      if (_nameController.text.trim().isEmpty) {
        _showError(isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name');
        return;
      }
      if (password != _confirmController.text) {
        _showError(isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match');
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> result;

      if (_isLogin) {
        result = await ApiService.login(email: email, password: password);
      } else {
        result = await ApiService.register(
          email: email,
          password: password,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          role: 'customer',
        );
      }

      if (!mounted) return;

      // Store auth in AppState — every screen can now read the token and user
      context.read<AppState>().setAuth(
        user: result['user'],
        token: result['token'],
      );

      // Navigate to the customer shell, removing everything below it
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainShell(
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            onToggleLanguage: widget.onToggleLanguage,
            onToggleTheme: widget.onToggleTheme,
            userName: result['user']['full_name'] ?? result['user']['email'],
            isGuest: false,
          ),
        ),
            (route) => false, // clear entire back stack
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      // Map common backend messages to Arabic equivalents
      String msg = e.message;
      if (isArabic) {
        if (msg == 'User already exists') msg = 'هذا البريد الإلكتروني مستخدم بالفعل';
        if (msg == 'Invalid credentials') msg = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
        if (msg == 'Server error') msg = 'خطأ في الخادم، حاول مرة أخرى';
      }
      _showError(msg);
    } catch (e) {
      if (!mounted) return;
      _showError(isArabic
          ? 'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت.'
          : 'Could not reach the server. Check your internet connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueAsGuest() {
    context.read<AppState>().setGuest();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainShell(
          isArabic: isArabic,
          isDarkMode: isDarkMode,
          onToggleLanguage: widget.onToggleLanguage,
          onToggleTheme: widget.onToggleTheme,
          isGuest: true,
        ),
      ),
          (route) => false,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final direction = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _topBtn(
                      icon: Icons.language,
                      label: isArabic ? 'EN' : 'عربي',
                      onTap: appState.toggleLanguage,
                    ),
                    _topBtn(
                      icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      label: '',
                      onTap: appState.toggleTheme,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ── Logo & Title ───────────────────────────────────────
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A017).withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.storefront_outlined, size: 40, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'CraftGo',
                        style: GoogleFonts.arefRuqaa(
                          color: const Color(0xFFD4A017),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic
                            ? 'منصة الحرف اليدوية الأولى في المنطقة'
                            : 'The #1 handcraft marketplace in the region',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: secondaryText, fontSize: 13),
                      ),
                      const SizedBox(height: 35),

                      // ── Login / Register toggle ────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: _tabToggle(
                              label: isArabic ? 'تسجيل الدخول' : 'Login',
                              active: _isLogin,
                              onTap: () => setState(() => _isLogin = true),
                            )),
                            Expanded(child: _tabToggle(
                              label: isArabic ? 'حساب جديد' : 'Sign Up',
                              active: !_isLogin,
                              onTap: () => setState(() => _isLogin = false),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ── Form Fields ───────────────────────────────────────
                      if (!_isLogin) ...[
                        _field(
                          controller: _nameController,
                          label: isArabic ? 'الاسم الكامل' : 'Full Name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        _field(
                          controller: _phoneController,
                          label: isArabic ? 'رقم الهاتف' : 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 15),
                      ],
                      _field(
                        controller: _emailController,
                        label: isArabic ? 'البريد الإلكتروني' : 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      _passwordField(
                        controller: _passwordController,
                        label: isArabic ? 'كلمة المرور' : 'Password',
                        obscure: _obscurePassword,
                        onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      if (!_isLogin) ...[
                        const SizedBox(height: 15),
                        _passwordField(
                          controller: _confirmController,
                          label: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
                          obscure: _obscureConfirm,
                          onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ],
                      if (_isLogin) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _showForgotPasswordDialog(),
                            child: Text(
                              isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                              style: const TextStyle(color: Color(0xFFD4A017), fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),

                      // ── Submit button ─────────────────────────────────────
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A017).withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          // Show spinner while loading; call _submit otherwise
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            _isLogin
                                ? (isArabic ? 'تسجيل الدخول' : 'Login')
                                : (isArabic ? 'إنشاء حساب' : 'Create Account'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // ── Divider ───────────────────────────────────────────
                      Row(
                        children: [
                          Expanded(child: Divider(color: borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              isArabic ? 'أو' : 'OR',
                              style: TextStyle(color: secondaryText, fontSize: 13),
                            ),
                          ),
                          Expanded(child: Divider(color: borderColor)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Continue as Guest ──────────────────────────────────
                      GestureDetector(
                        onTap: _continueAsGuest,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, color: secondaryText, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? 'تصفح كزائر (بدون تسجيل)' : 'Continue as Guest',
                                style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Shared widget helpers ────────────────────────────────────────────────────

  Widget _tabToggle({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD4A017) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: active ? Colors.black : secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: primaryText),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryText),
        prefixIcon: Icon(icon, color: secondaryText),
        filled: true,
        fillColor: surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: primaryText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryText),
        prefixIcon: Icon(Icons.lock_outline, color: secondaryText),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: secondaryText,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _topBtn({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: topBtnBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: primaryText),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: primaryText, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1C2431) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isArabic ? 'استعادة كلمة المرور' : 'Reset Password',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic
                    ? 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.'
                    : 'Enter your email and we will send you a password reset link.',
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                  prefixIcon: Icon(Icons.email_outlined, color: isDarkMode ? Colors.white54 : Colors.black45),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF0D1420) : Colors.grey.shade100,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDarkMode ? Colors.white12 : Colors.black12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isArabic ? 'إلغاء' : 'Cancel', style: const TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(isArabic ? 'تم إرسال رابط الاستعادة إلى بريدك ✅' : 'Reset link sent to your email ✅'),
                ));
              },
              child: Text(isArabic ? 'إرسال' : 'Send', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}