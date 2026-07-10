import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exhibition_owner_shell.dart';

class ExhibitionOwnerLoginScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const ExhibitionOwnerLoginScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<ExhibitionOwnerLoginScreen> createState() => _ExhibitionOwnerLoginScreenState();
}

class _ExhibitionOwnerLoginScreenState extends State<ExhibitionOwnerLoginScreen>
    with TickerProviderStateMixin {
  late bool isArabic;
  late bool isDarkMode;

  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _showAiPrediction = false;
  List<String> _aiNameSuggestions = [];
  bool _loadingNames = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _phoneController = TextEditingController();
  final _exhibitionTypeController = TextEditingController();

  late AnimationController _entranceController;
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  String? _exhibitionTypeSelection;
  final List<String> _exhibitionTypesAr = ['حرف تراثية', 'مجوهرات', 'خزف وفخار', 'نسيج وتطريز', 'خشبيات', 'متعدد التخصصات'];
  final List<String> _exhibitionTypesEn = ['Heritage Crafts', 'Jewelry', 'Ceramics & Pottery', 'Textile & Embroidery', 'Woodwork', 'Multi-Specialty'];

  String t(String ar, String en) => isArabic ? ar : en;
  Color get bg => isDarkMode ? const Color(0xFF0A0F1E) : const Color(0xFFF5F0FF);
  Color get surface => isDarkMode ? const Color(0xFF131929) : Colors.white;
  Color get surface2 => isDarkMode ? const Color(0xFF1C2640) : const Color(0xFFF8F5FF);
  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white60 : Colors.black45;
  Color get borderColor => isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
  static const Color exAccent = Color(0xFF7B5EA7);

  // AI Prediction data
  String _predictedVisitors = '350–480';
  String _bestDay = '';
  String _trendingCraft = '';

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _glowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _exhibitionTypeController.dispose();
    super.dispose();
  }

  void _generateAiNames() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('أدخل اسم المنظم أولاً', 'Please enter organizer name first'), style: GoogleFonts.cairo()),
          backgroundColor: exAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() { _loadingNames = true; _aiNameSuggestions = []; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final name = _nameController.text.trim();
    setState(() {
      _loadingNames = false;
      _aiNameSuggestions = isArabic
          ? [
              'معرض $name للحرف الأصيلة',
              'إرث $name للإبداع اليدوي',
              'بصمة $name الحرفية',
            ]
          : [
              '$name Craft Heritage Fair',
              '$name Artisan Showcase',
              '$name Creative Hands Exhibition',
            ];
    });
  }

  void _handleSubmit() async {
    setState(() { _isLoading = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (!_isLogin) {
      // Build AI prediction based on selected type
      final idx = _exhibitionTypesAr.indexOf(_exhibitionTypeSelection ?? '');
      final predictions = [
        {'visitors': '400–550', 'day': t('الجمعة والسبت', 'Fri & Sat'), 'craft': t('حرف تراثية 🏺', 'Heritage Crafts 🏺')},
        {'visitors': '300–420', 'day': t('نهاية الأسبوع', 'Weekend'), 'craft': t('مجوهرات 💍', 'Jewelry 💍')},
        {'visitors': '250–380', 'day': t('السبت', 'Saturday'), 'craft': t('خزف 🏺', 'Ceramics 🏺')},
        {'visitors': '350–500', 'day': t('الجمعة', 'Friday'), 'craft': t('تطريز 🧵', 'Embroidery 🧵')},
        {'visitors': '280–400', 'day': t('نهاية الأسبوع', 'Weekend'), 'craft': t('خشبيات 🪵', 'Woodwork 🪵')},
        {'visitors': '450–650', 'day': t('الجمعة والسبت', 'Fri & Sat'), 'craft': t('متعدد 🎨', 'Multi 🎨')},
      ];
      final pred = idx >= 0 && idx < predictions.length ? predictions[idx] : predictions[5];
      setState(() {
        _isLoading = false;
        _showAiPrediction = true;
        _predictedVisitors = pred['visitors']!;
        _bestDay = pred['day']!;
        _trendingCraft = pred['craft']!;
      });
    } else {
      setState(() { _isLoading = false; });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ExhibitionOwnerShell(
            isArabic: isArabic,
            isDarkMode: isDarkMode,
            onToggleLanguage: widget.onToggleLanguage,
            onToggleTheme: widget.onToggleTheme,
            ownerName: isArabic ? 'رزان العمري' : 'Razan Al-Omari',
          ),
        ),
        (route) => false,
      );
    }
  }

  void _proceedToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ExhibitionOwnerShell(
          isArabic: isArabic,
          isDarkMode: isDarkMode,
          onToggleLanguage: widget.onToggleLanguage,
          onToggleTheme: widget.onToggleTheme,
          ownerName: _nameController.text.isNotEmpty ? _nameController.text : (isArabic ? 'رزان العمري' : 'Razan Al-Omari'),
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
            // Gradient background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [const Color(0xFF0A0F1E), const Color(0xFF130D22), const Color(0xFF0A0F1E)]
                        : [const Color(0xFFF5F0FF), const Color(0xFFFDF9FF), const Color(0xFFF5F0FF)],
                  ),
                ),
              ),
            ),
            // Glow blobs
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedBuilder(
                animation: _glowAnim,
                builder: (context, snapshot) => Opacity(
                  opacity: _glowAnim.value * 0.15,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: exAccent,
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
                  color: exAccent.withValues(alpha: 0.06),
                ),
              ),
            ),

            SafeArea(
              child: _showAiPrediction
                  ? _buildAiPredictionScreen()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: FadeTransition(
                        opacity: _entranceController,
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
                            const SizedBox(height: 28),

                            // Logo
                            AnimatedBuilder(
                              animation: _glowAnim,
                              builder: (context, snapshot) => Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF9B73D1), exAccent],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: exAccent.withValues(alpha: _glowAnim.value * 0.55),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.museum, color: Colors.white, size: 42),
                              ),
                            ),
                            const SizedBox(height: 18),

                            Text(
                              t('بوابة صاحب المعرض', 'Exhibition Owner Portal'),
                              style: GoogleFonts.cairo(
                                color: primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t('نظام AI ذكي لإدارة معارضك 🏛️', 'AI-Powered Exhibition Management 🏛️'),
                              style: GoogleFonts.cairo(color: exAccent, fontSize: 12),
                            ),
                            const SizedBox(height: 28),

                            // Login / Register tabs
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: _buildTab(t('تسجيل الدخول', 'Login'), _isLogin, () => setState(() => _isLogin = true))),
                                  Expanded(child: _buildTab(t('حساب جديد', 'Sign Up'), !_isLogin, () => setState(() => _isLogin = false))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: surface.withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: exAccent.withValues(alpha: 0.25)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (!_isLogin) ...[
                                        // Organizer name + AI button
                                        _buildLabel(t('اسم المنظم / الشركة', 'Organizer / Company Name')),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildField(
                                                controller: _nameController,
                                                hint: t('مثال: مؤسسة إرث الأردن', 'e.g. Jordan Heritage Foundation'),
                                                icon: Icons.business_outlined,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: _generateAiNames,
                                              child: Container(
                                                width: 52,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: exAccent,
                                                  borderRadius: BorderRadius.circular(14),
                                                  boxShadow: [
                                                    BoxShadow(color: exAccent.withValues(alpha: 0.4), blurRadius: 12),
                                                  ],
                                                ),
                                                child: _loadingNames
                                                    ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))
                                                    : const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // AI name suggestions
                                        if (_aiNameSuggestions.isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: exAccent.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(color: exAccent.withValues(alpha: 0.3)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.auto_awesome, color: exAccent, size: 14),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      t('🤖 اقتراحات AI لتسمية معرضك', '🤖 AI Exhibition Name Suggestions'),
                                                      style: GoogleFonts.cairo(color: exAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                ..._aiNameSuggestions.map((name) => GestureDetector(
                                                      onTap: () => setState(() {
                                                        _nameController.text = name;
                                                        _aiNameSuggestions = [];
                                                      }),
                                                      child: Container(
                                                        margin: const EdgeInsets.only(bottom: 6),
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: surface2,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: borderColor),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const Icon(Icons.museum_outlined, color: exAccent, size: 16),
                                                            const SizedBox(width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                name,
                                                                style: GoogleFonts.cairo(color: primaryText, fontSize: 13),
                                                              ),
                                                            ),
                                                            Icon(Icons.touch_app, color: secondaryText, size: 14),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 14),

                                        // License
                                        _buildLabel(t('رقم الرخصة / السجل التجاري', 'License / Commercial Register No.')),
                                        const SizedBox(height: 8),
                                        _buildField(
                                          controller: _licenseController,
                                          hint: t('مثال: JO-2024-78901', 'e.g. JO-2024-78901'),
                                          icon: Icons.verified_outlined,
                                        ),
                                        const SizedBox(height: 14),

                                        // Phone
                                        _buildLabel(t('رقم الهاتف', 'Phone Number')),
                                        const SizedBox(height: 8),
                                        _buildField(
                                          controller: _phoneController,
                                          hint: t('+962 7XXXXXXXX', '+962 7XXXXXXXX'),
                                          icon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 14),

                                        // Exhibition type dropdown
                                        _buildLabel(t('تخصص المعرض', 'Exhibition Specialty')),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: surface2,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: borderColor),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _exhibitionTypeSelection,
                                              isExpanded: true,
                                              dropdownColor: surface,
                                              hint: Text(
                                                t('اختر التخصص', 'Choose specialty'),
                                                style: GoogleFonts.cairo(color: secondaryText),
                                              ),
                                              icon: const Icon(Icons.keyboard_arrow_down, color: exAccent),
                                              items: (isArabic ? _exhibitionTypesAr : _exhibitionTypesEn).map((type) {
                                                return DropdownMenuItem(
                                                  value: type,
                                                  child: Text(type, style: GoogleFonts.cairo(color: primaryText)),
                                                );
                                              }).toList(),
                                              onChanged: (v) => setState(() => _exhibitionTypeSelection = v),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                      ],

                                      // Email
                                      _buildLabel(t('البريد الإلكتروني', 'Email Address')),
                                      const SizedBox(height: 8),
                                      _buildField(
                                        controller: _emailController,
                                        hint: t('example@gallery.com', 'example@gallery.com'),
                                        icon: Icons.alternate_email,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 14),

                                      // Password
                                      _buildLabel(t('كلمة المرور', 'Password')),
                                      const SizedBox(height: 8),
                                      _buildPasswordField(
                                        controller: _passwordController,
                                        obscure: _obscurePassword,
                                        onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                                      ),

                                      if (!_isLogin) ...[
                                        const SizedBox(height: 14),
                                        _buildLabel(t('تأكيد كلمة المرور', 'Confirm Password')),
                                        const SizedBox(height: 8),
                                        _buildPasswordField(
                                          controller: _confirmController,
                                          obscure: _obscureConfirm,
                                          onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                        ),
                                      ],

                                      const SizedBox(height: 24),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 54,
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _handleSubmit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: exAccent,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            elevation: 0,
                                          ),
                                          child: _isLoading
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      t('🤖 AI يحلل معرضك...', '🤖 AI analyzing your exhibition...'),
                                                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  _isLogin
                                                      ? t('تسجيل الدخول 🏛️', 'Login 🏛️')
                                                      : t('إنشاء الحساب + توقعات AI ✨', 'Create Account + AI Forecast ✨'),
                                                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiPredictionScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: exAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: exAccent.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.psychology, color: exAccent, size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            t('🎉 تم إنشاء حسابك بنجاح!', '🎉 Account Created Successfully!'),
            style: GoogleFonts.cairo(color: primaryText, fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            t('إليك توقعات الذكاء الاصطناعي لمعرضك القادم 🤖', 'Here are AI predictions for your upcoming exhibition 🤖'),
            style: GoogleFonts.cairo(color: secondaryText, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Prediction Cards
          _buildPredictionCard(
            icon: Icons.people_outline,
            title: t('الجمهور المتوقع', 'Predicted Audience'),
            value: _predictedVisitors,
            subtitle: t('زائر', 'visitors'),
            color: exAccent,
          ),
          const SizedBox(height: 14),
          _buildPredictionCard(
            icon: Icons.calendar_today_outlined,
            title: t('أفضل أيام للمعرض', 'Best Exhibition Days'),
            value: _bestDay,
            subtitle: t('أعلى تفاعل', 'Peak engagement'),
            color: const Color(0xFFD4A017),
          ),
          const SizedBox(height: 14),
          _buildPredictionCard(
            icon: Icons.whatshot,
            title: t('الأعلى طلباً في منطقتك', 'Trending Craft in Your Area'),
            value: _trendingCraft,
            subtitle: t('+40% هذا الشهر', '+40% this month'),
            color: Colors.redAccent,
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.green, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t(
                      '💡 نصيحة AI: جهّز خصومات حصرية لأول 50 زائر لرفع التفاعل الاجتماعي بمعدل 3x',
                      '💡 AI Tip: Prepare exclusive discounts for the first 50 visitors to boost social engagement by 3x',
                    ),
                    style: GoogleFonts.cairo(color: Colors.green, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _proceedToDashboard,
              icon: const Icon(Icons.dashboard_outlined, color: Colors.white),
              label: Text(
                t('انطلق إلى لوحة التحكم 🚀', 'Go to Dashboard 🚀'),
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: exAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPredictionCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.cairo(color: secondaryText, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.cairo(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.cairo(color: secondaryText, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? exAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: selected ? Colors.white : secondaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: GoogleFonts.cairo(color: secondaryText, fontSize: 13, fontWeight: FontWeight.w600),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.cairo(color: primaryText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: secondaryText),
        prefixIcon: Icon(icon, color: exAccent, size: 20),
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: exAccent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.cairo(color: primaryText),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: GoogleFonts.cairo(color: secondaryText),
        prefixIcon: const Icon(Icons.lock_outline, color: exAccent, size: 20),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: secondaryText, size: 20),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: exAccent, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
