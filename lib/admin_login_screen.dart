import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_shell.dart';

class AdminLoginScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const AdminLoginScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  late bool isArabic;
  late bool isDarkMode;

  final _adminIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _showOtp = false;
  bool _isVerifying = false;
  bool _otpVerified = false;
  String _aiSecurityMessage = '';
  Color _aiSecurityColor = Colors.green;
  IconData _aiSecurityIcon = Icons.verified_user;

  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnim;

  String t(String ar, String en) => isArabic ? ar : en;

  Color get bg => isDarkMode ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FF);
  Color get surface => isDarkMode ? const Color(0xFF131929) : Colors.white;
  Color get surface2 => isDarkMode ? const Color(0xFF1C2640) : const Color(0xFFF8F9FF);
  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white60 : Colors.black45;
  Color get borderColor => isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
  static const Color adminAccent = Color(0xFF3D7BFF);

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _adminIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyCredentials() async {
    setState(() { _isVerifying = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    // Simulate AI security check
    final isNight = DateTime.now().hour > 22 || DateTime.now().hour < 6;
    setState(() {
      _isVerifying = false;
      _showOtp = true;
      if (isNight) {
        _aiSecurityMessage = t(
          '⚠️ تسجيل دخول في ساعات غير معتادة! تم إرسال تنبيه للمراقب.',
          '⚠️ Login attempt at unusual hours! Security team has been notified.',
        );
        _aiSecurityColor = Colors.orange;
        _aiSecurityIcon = Icons.warning_amber_rounded;
      } else {
        _aiSecurityMessage = t(
          '✅ جهاز موثوق • تسجيل دخول آمن من عمّان، الأردن • لا تهديدات',
          '✅ Trusted device • Secure login from Amman, Jordan • No threats detected',
        );
        _aiSecurityColor = Colors.green;
        _aiSecurityIcon = Icons.verified_user;
      }
    });
  }

  void _verifyOtp() async {
    setState(() { _isVerifying = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isVerifying = false;
      _otpVerified = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AdminShell(
          isArabic: isArabic,
          isDarkMode: isDarkMode,
          onToggleLanguage: widget.onToggleLanguage,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            // Animated gradient background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                const Color(0xFF0A0F1E),
                                const Color(0xFF0D1B33),
                                const Color(0xFF0A0F1E),
                              ]
                            : [
                                const Color(0xFFEEF2FF),
                                const Color(0xFFF5F8FF),
                                const Color(0xFFEEF2FF),
                              ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Decorative circle glow
            Positioned(
              top: -80,
              right: -80,
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: adminAccent.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: adminAccent.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topBtn(
                          icon: isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            _topBtn(
                              icon: Icons.language,
                              label: isArabic ? 'EN' : 'عربي',
                              onTap: () => setState(() {
                                isArabic = !isArabic;
                                widget.onToggleLanguage();
                              }),
                            ),
                            const SizedBox(width: 8),
                            _topBtn(
                              icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              onTap: () => setState(() {
                                isDarkMode = !isDarkMode;
                                widget.onToggleTheme();
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Shield logo with glow
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnim.value * 0.97,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3D7BFF), Color(0xFF1A4FCC)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: adminAccent.withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 46),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      t('بوابة إدارة CraftGo', 'CraftGo Admin Portal'),
                      style: GoogleFonts.cairo(
                        color: primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t('دخول آمن محمي بالذكاء الاصطناعي 🛡️', 'AI-Secured Access 🛡️'),
                      style: GoogleFonts.cairo(color: adminAccent, fontSize: 13),
                    ),
                    const SizedBox(height: 36),

                    // Form Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surface.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: adminAccent.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Admin ID
                              _buildLabel(t('رمز معرّف الإدارة', 'Admin Staff ID')),
                              const SizedBox(height: 8),
                              _buildField(
                                controller: _adminIdController,
                                hint: t('مثال: AD-9042', 'e.g. AD-9042'),
                                icon: Icons.badge_outlined,
                                enabled: !_showOtp,
                              ),
                              const SizedBox(height: 16),

                              // Email
                              _buildLabel(t('البريد المهني', 'Work Email')),
                              const SizedBox(height: 8),
                              _buildField(
                                controller: _emailController,
                                hint: t('admin@craftgo.com', 'admin@craftgo.com'),
                                icon: Icons.alternate_email,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !_showOtp,
                              ),
                              const SizedBox(height: 16),

                              // Password
                              _buildLabel(t('كلمة المرور', 'Password')),
                              const SizedBox(height: 8),
                              _buildPasswordField(
                                controller: _passwordController,
                                enabled: !_showOtp,
                              ),
                              const SizedBox(height: 24),

                              // AI Security result banner
                              if (_aiSecurityMessage.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _aiSecurityColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: _aiSecurityColor.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_aiSecurityIcon, color: _aiSecurityColor, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _aiSecurityMessage,
                                          style: GoogleFonts.cairo(
                                            color: _aiSecurityColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // OTP field
                              if (_showOtp) ...[
                                _buildLabel(t('رمز التحقق (OTP)', 'Two-Factor OTP')),
                                const SizedBox(height: 4),
                                Text(
                                  t('🤖 Crafty AI يتحقق من هويتك... تم إرسال الرمز لبريدك', '🤖 Crafty AI is verifying... Code sent to your email'),
                                  style: GoogleFonts.cairo(color: adminAccent, fontSize: 11),
                                ),
                                const SizedBox(height: 8),
                                _buildField(
                                  controller: _otpController,
                                  hint: t('أدخل رمز التحقق المكون من 6 أرقام', 'Enter 6-digit OTP'),
                                  icon: Icons.security,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Action button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isVerifying
                                      ? null
                                      : (_showOtp ? _verifyOtp : _verifyCredentials),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _otpVerified ? Colors.green : adminAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isVerifying
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              t('🤖 AI يحلل بياناتك...', '🤖 AI analyzing your data...'),
                                              style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : _otpVerified
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.check_circle, color: Colors.white),
                                                const SizedBox(width: 8),
                                                Text(
                                                  t('تم التحقق! جاري الدخول...', 'Verified! Redirecting...'),
                                                  style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              _showOtp
                                                  ? t('تحقق من الرمز 🔐', 'Verify OTP 🔐')
                                                  : t('تحقق من الهوية 🛡️', 'Verify Identity 🛡️'),
                                              style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Security stats
                    Row(
                      children: [
                        Expanded(child: _buildStatCard(Icons.lock_outline, t('256-bit', '256-bit'), t('تشفير', 'Encryption'), Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard(Icons.shield_outlined, t('صفر', 'Zero'), t('خروقات أمنية', 'Breaches'), adminAccent)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard(Icons.psychology_outlined, t('AI', 'AI'), t('مراقبة', 'Monitoring'), Colors.purpleAccent)),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        color: secondaryText,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: GoogleFonts.cairo(color: primaryText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: secondaryText),
        prefixIcon: Icon(icon, color: adminAccent, size: 20),
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: adminAccent, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      enabled: enabled,
      style: GoogleFonts.cairo(color: primaryText),
      decoration: InputDecoration(
        hintText: t('••••••••', '••••••••'),
        hintStyle: GoogleFonts.cairo(color: secondaryText),
        prefixIcon: const Icon(Icons.lock_outline, color: adminAccent, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: secondaryText,
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: adminAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.cairo(color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(color: secondaryText, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _topBtn({required IconData icon, String? label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: label != null ? 12 : 10, vertical: 8),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: primaryText),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.cairo(color: primaryText, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }
}
