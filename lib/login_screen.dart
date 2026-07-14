import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'main.dart';
import 'services/api_service.dart';
import 'craftsman_shell.dart';
import 'exhibition_owner_shell.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const LoginScreen({
    super.key,
    this.isArabic = true,
    this.isDarkMode = true,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool isLoading = false;
  String selectedRole = 'customer';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = CraftGoApp.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';

    final bg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF8F6F0);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0x66FFFFFF) : const Color(0xFF999999);
    final inpBg = isDark ? const Color(0x0DFFFFFF) : Colors.white;
    final inpBorder = isDark
        ? const Color(0x1FFFFFFF)
        : const Color(0xFFE5E0D8);
    final togBg = isDark ? const Color(0x12FFFFFF) : const Color(0xFFEDE9E1);
    final togInactive = isDark
        ? const Color(0x4DFFFFFF)
        : const Color(0xFFAAAAAA);
    final glassyBg = isDark ? const Color(0x0DFFFFFF) : Colors.white;
    final glassyBorder = isDark
        ? const Color(0x1FFFFFFF)
        : const Color(0xFFE5E0D8);
    final divColor = isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
    final ghostBorder = isDark
        ? const Color(0x33FFFFFF)
        : const Color(0xFFCCC5BB);

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFFE8B84B),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Theme toggle
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _MiniToggle(
                isDark: isDark,
                isAr: isAr,
                onTheme: () => appState?.toggleTheme(),
                onLang: () => appState?.toggleLocale(),
              ),
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Gold accent line
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8B84B), Color(0xFFC9962A)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Align(
                    alignment: isAr
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      isLogin
                          ? (isAr ? 'مرحباً بعودتك' : 'Welcome Back')
                          : (isAr ? 'أنشئ حساباً' : 'Create Account'),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: isAr
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      isLogin
                          ? (isAr
                                ? 'سجّل دخولك للمتابعة'
                                : 'Sign in to continue')
                          : (isAr
                                ? 'انضم إلى CraftGo اليوم'
                                : 'Join CraftGo today'),
                      style: TextStyle(fontSize: 13, color: subColor),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Toggle Login/Signup
                  Container(
                    decoration: BoxDecoration(
                      color: togBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE8B84B).withValues(alpha: 0.15),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ToggleBtn(
                            label: isAr ? 'تسجيل الدخول' : 'Sign In',
                            isActive: isLogin,
                            onTap: () => setState(() => isLogin = true),
                            inactiveColor: togInactive,
                          ),
                        ),
                        Expanded(
                          child: _ToggleBtn(
                            label: isAr ? 'حساب جديد' : 'Sign Up',
                            isActive: !isLogin,
                            onTap: () => setState(() => isLogin = false),
                            inactiveColor: togInactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Role selector (signup only)
                  if (!isLogin) ...[
                    Align(
                      alignment: isAr
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        isAr ? 'أنا...' : 'I am...',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            icon: Icons.person_rounded,
                            label: isAr ? 'زبون' : 'Customer',
                            isSelected: selectedRole == 'customer',
                            onTap: () =>
                                setState(() => selectedRole = 'customer'),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleCard(
                            icon: Icons.handyman_rounded,
                            label: isAr ? 'حرفي' : 'Artisan',
                            isSelected: selectedRole == 'artisan',
                            onTap: () =>
                                setState(() => selectedRole = 'artisan'),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],

                  // Email
                  _InputField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    label: isAr ? 'البريد الإلكتروني' : 'Email Address',
                    bg: inpBg,
                    border: inpBorder,
                    labelColor: subColor,
                  ),
                  const SizedBox(height: 12),

                  // Password
                  _InputField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    label: isAr ? 'كلمة المرور' : 'Password',
                    isPassword: true,
                    bg: inpBg,
                    border: inpBorder,
                    labelColor: subColor,
                  ),

                  // Full name (signup)
                  if (!isLogin) ...[
                    const SizedBox(height: 12),
                    _InputField(
                      controller: _nameController,
                      icon: Icons.person_outline,
                      label: isAr ? 'الاسم الكامل' : 'Full Name',
                      bg: inpBg,
                      border: inpBorder,
                      labelColor: subColor,
                    ),
                  ],

                  // Forgot password (login)
                  if (isLogin) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: isAr
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        isAr ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE8B84B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() => isLoading = true);
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              final name = _nameController.text.trim();

                              Map<String, dynamic>? result;
                              if (isLogin) {
                                result = await ApiService.login(email, password);
                              } else {
                                // role in DB is enum: [customer, craftsman, exhibition_owner, admin]
                                final role = selectedRole == 'artisan' ? 'craftsman' : 'customer';
                                result = await ApiService.signup(name, email, password, role);
                              }

                              setState(() => isLoading = false);

                              if (!mounted) return;

                              if (result != null) {
                                final role = result['role'] as String? ?? '';
                                final userName = result['name'] as String? ?? 'مستخدم';

                                if (role == 'exhibition_owner') {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (ctx, a, b) => ExhibitionOwnerShell(
                                        isArabic: widget.isArabic,
                                        isDarkMode: widget.isDarkMode,
                                        onToggleLanguage: widget.onToggleLanguage,
                                        onToggleTheme: widget.onToggleTheme,
                                        ownerName: userName,
                                      ),
                                      transitionDuration: const Duration(milliseconds: 400),
                                      transitionsBuilder: (ctx, a, b, child) => FadeTransition(opacity: a, child: child),
                                    ),
                                  );
                                } else if (role == 'craftsman') {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (ctx, a, b) => CraftsmanShell(
                                        isArabic: widget.isArabic,
                                        isDarkMode: widget.isDarkMode,
                                        onToggleLanguage: widget.onToggleLanguage,
                                        onToggleTheme: widget.onToggleTheme,
                                        craftsmanName: userName,
                                        craftsmanCategoryAr: 'حرفي',
                                        craftsmanCategoryEn: 'Craftsman',
                                        craftsmanCity: '',
                                        craftsmanBio: '',
                                        craftsmanExperience: '',
                                      ),
                                      transitionDuration: const Duration(milliseconds: 400),
                                      transitionsBuilder: (ctx, a, b, child) => FadeTransition(opacity: a, child: child),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (ctx, a, b) => const HomeScreen(),
                                      transitionDuration: const Duration(milliseconds: 400),
                                      transitionsBuilder: (ctx, a, b, child) => FadeTransition(opacity: a, child: child),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isAr ? 'فشلت العملية، تأكد من البيانات' : 'Failed. Check your credentials.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8B84B),
                        foregroundColor: const Color(0xFF0A0A0A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF0A0A0A),
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              isLogin
                                  ? (isAr ? 'تسجيل الدخول' : 'Sign In')
                                  : (isAr ? 'إنشاء الحساب' : 'Create Account'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: divColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          isAr ? 'أو' : 'or',
                          style: TextStyle(fontSize: 11, color: subColor),
                        ),
                      ),
                      Expanded(child: Divider(color: divColor)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Google button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: glassyBg,
                        border: Border.all(color: glassyBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.g_mobiledata_rounded,
                            size: 24,
                            color: Color(0xFFE8B84B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isAr ? 'متابعة بـ Google' : 'Continue with Google',
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Guest button
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: ghostBorder, width: 1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        isAr ? 'تصفح كزائر' : 'Browse as Guest',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: subColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mini Toggle in AppBar ────────────────────────────────────────────────────

class _MiniToggle extends StatelessWidget {
  final bool isDark;
  final bool isAr;
  final VoidCallback onTheme;
  final VoidCallback onLang;

  const _MiniToggle({
    required this.isDark,
    required this.isAr,
    required this.onTheme,
    required this.onLang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTheme,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE8B84B).withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              size: 16,
              color: const Color(0xFFE8B84B),
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onLang,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE8B84B).withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAr ? 'EN' : 'عربي',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFE8B84B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Toggle Button ────────────────────────────────────────────────────────────

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color inactiveColor;

  const _ToggleBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFE8B84B), Color(0xFFC9962A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? const Color(0xFF0A0A0A) : inactiveColor,
          ),
        ),
      ),
    );
  }
}

// ── Role Card ────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A1A1A)
              : (isDark ? Colors.transparent : Colors.white),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE8B84B)
                : (isDark ? const Color(0x1FFFFFFF) : const Color(0xFFE5E0D8)),
            width: isSelected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE8B84B).withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE8B84B) : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? const Color(0xFFE8B84B) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color border;
  final Color labelColor;
  final bool isPassword;
  final TextEditingController? controller;

  const _InputField({
    required this.icon,
    required this.label,
    required this.bg,
    required this.border,
    required this.labelColor,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFE8B84B), size: 20),
        filled: true,
        fillColor: bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8B84B), width: 1.5),
        ),
      ),
    );
  }
}
