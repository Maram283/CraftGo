import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/artisan/craftsman_category_screen.dart';
import 'customer_login_screen.dart';
import '../../core/main_shell.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/exhibitions/exhibition_owner_login_screen.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const RoleSelectionScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late bool isArabic;
  late bool isDarkMode;

  // Animation controllers
  late AnimationController _entranceController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
    isDarkMode = widget.isDarkMode;
    
    _checkAutoLogin();

    // Entrance Animation (Slide + Fade)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Shimmer effect for the title
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Start entrance animation immediately
    _entranceController.forward();
  }

  Future<void> _checkAutoLogin() async {
    final token = await ApiService.getToken();
    if (token != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // Staggered Entrance Animations definitions
  Animation<double> get _titleFade => CurvedAnimation(
    parent: _entranceController,
    curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
  );
  Animation<Offset> get _titleSlide =>
      Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
        ),
      );

  Animation<double> get _card1Fade => CurvedAnimation(
    parent: _entranceController,
    curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
  );
  Animation<Offset> get _card1Slide =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
        ),
      );

  Animation<double> get _card2Fade => CurvedAnimation(
    parent: _entranceController,
    curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
  );
  Animation<Offset> get _card2Slide =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
        ),
      );

  Animation<double> get _card3Fade => CurvedAnimation(
    parent: _entranceController,
    curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
  );
  Animation<Offset> get _card3Slide =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
        ),
      );

  Animation<double> get _card4Fade => CurvedAnimation(
    parent: _entranceController,
    curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
  );
  Animation<Offset> get _card4Slide =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
        ),
      );

  // Colors mapping
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor => isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.08);

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
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Top Bar: Back button + Language & Theme Toggles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button styled like other glass buttons
                      _topBarButton(
                        icon: isArabic
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios,
                        label: "",
                        onTap: () => Navigator.pop(context),
                      ),
                      // Toggles
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
                  const Spacer(flex: 1),

                  // Title Area with Fade + Slide + Gold Shimmer Animation
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            final dx = _shimmerController.value;
                            return ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    primaryTextColor,
                                    const Color(0xFFD4A017),
                                    Colors.white,
                                    primaryTextColor,
                                  ],
                                  begin: Alignment(-1.0 + dx * 2, -0.5),
                                  end: Alignment(1.0 + dx * 2, 0.5),
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds);
                              },
                              child: Text(
                                isArabic
                                    ? "أهلاً بك في عالم الحرف"
                                    : "Welcome to the Craft World",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.arefRuqaa(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? "حدد طبيعة حسابك للمتابعة"
                              : "Select your account type to proceed",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFD4A017),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Cards List (Staggered Entrance animations)
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _card1Fade,
                        child: SlideTransition(
                          position: _card1Slide,
                          child: child,
                        ),
                      );
                    },
                    child: RoleCard(
                      icon: Icons.construction_outlined,
                      title: isArabic ? "أنا حرفي" : "I am a Craftsman",
                      description: isArabic
                          ? "سجل لتقديم خدماتك، تلقي الطلبات، وعرض أعمالك الإبداعية المميزة."
                          : "Register to offer your services, receive orders, and showcase your work.",
                      isDarkMode: isDarkMode,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBorderColor: cardBorderColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CraftsmanCategoryScreen(
                              isArabic: isArabic,
                              isDarkMode: isDarkMode,
                              onToggleLanguage: toggleLanguage,
                              onToggleTheme: toggleTheme,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _card2Fade,
                        child: SlideTransition(
                          position: _card2Slide,
                          child: child,
                        ),
                      );
                    },
                    child: RoleCard(
                      icon: Icons.search_outlined,
                      title: isArabic
                          ? "أبحث عن حرفي"
                          : "I am looking for a Craftsman",
                      description: isArabic
                          ? "تصفح أمهر الحرفيين في منطقتك، واطلب خدمات تناسب احتياجاتك."
                          : "Browse the most skilled craftsmen in your area and request matching services.",
                      isDarkMode: isDarkMode,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBorderColor: cardBorderColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (loginCtx) => CustomerLoginScreen(
                              isArabic: isArabic,
                              isDarkMode: isDarkMode,
                              onToggleLanguage: toggleLanguage,
                              onToggleTheme: toggleTheme,
                              onLoginSuccess: () {
                                Navigator.of(loginCtx).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => MainShell(
                                      isArabic: isArabic,
                                      isDarkMode: isDarkMode,
                                      onToggleLanguage: toggleLanguage,
                                      onToggleTheme: toggleTheme,
                                      isGuest: false,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              onGuestAccess: () {
                                Navigator.of(loginCtx).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => MainShell(
                                      isArabic: isArabic,
                                      isDarkMode: isDarkMode,
                                      onToggleLanguage: toggleLanguage,
                                      onToggleTheme: toggleTheme,
                                      isGuest: true,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _card3Fade,
                        child: SlideTransition(
                          position: _card3Slide,
                          child: child,
                        ),
                      );
                    },
                    child: RoleCard(
                      icon: Icons.admin_panel_settings_outlined,
                      title: isArabic
                          ? "إدارة النظام"
                          : "System Administration",
                      description: isArabic
                          ? "الدخول بصلاحيات الأدمن لإدارة التطبيق والتحكم بالمستخدمين."
                          : "Access with admin privileges to manage the application and users.",
                      isDarkMode: isDarkMode,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBorderColor: cardBorderColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminLoginScreen(
                              isArabic: isArabic,
                              isDarkMode: isDarkMode,
                              onToggleLanguage: toggleLanguage,
                              onToggleTheme: toggleTheme,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Exhibition Owner Card
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _card4Fade,
                        child: SlideTransition(
                          position: _card4Slide,
                          child: child,
                        ),
                      );
                    },
                    child: RoleCard(
                      icon: Icons.museum_outlined,
                      title: isArabic ? "صاحب معرض" : "Exhibition Owner",
                      description: isArabic
                          ? "أنشئ معارض حرفية ودعوة الحرفيين للمشاركة فيها وإدارة الطلبات بذكاء."
                          : "Create craft exhibitions, invite artisans, and manage participation requests smartly.",
                      isDarkMode: isDarkMode,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBorderColor: cardBorderColor,
                      accentColor: const Color(0xFF7B5EA7),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExhibitionOwnerLoginScreen(
                              isArabic: isArabic,
                              isDarkMode: isDarkMode,
                              onToggleLanguage: toggleLanguage,
                              onToggleTheme: toggleTheme,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
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

class RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool isDarkMode;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color cardBorderColor;

  final Color? accentColor;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.isDarkMode,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.cardBorderColor,
    this.accentColor,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _currentScale {
    if (_isPressed) return 0.96; // Shrink slightly on tap
    if (_isHovered) return 1.03; // Grow on hover
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _currentScale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              0,
              _isHovered && !_isPressed ? -8 : 0,
              0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFFD4A017)
                    : widget.cardBorderColor,
                width: _isHovered ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? const Color(0xFFD4A017).withValues(alpha: 0.25)
                      : (widget.isDarkMode
                            ? const Color(0xFFD4A017).withValues(alpha: 0.03)
                            : Colors.black.withValues(alpha: 0.04)),
                  blurRadius: _isHovered ? 25 : 15,
                  spreadRadius: _isHovered ? 1 : 0,
                  offset: _isHovered ? const Offset(0, 10) : const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isDarkMode
                          ? [
                              Colors.white.withValues(alpha: 0.06),
                              Colors.white.withValues(alpha: 0.015),
                            ]
                          : [
                              Colors.black.withValues(alpha: 0.03),
                              Colors.black.withValues(alpha: 0.005),
                            ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon box with gold gradient
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              widget.accentColor ?? const Color(0xFFF7B500),
                              (widget.accentColor ?? const Color(0xFFD89A00)).withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (widget.accentColor ?? const Color(0xFFF7B500)).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 26,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 18),

                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: widget.primaryTextColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.description,
                              style: TextStyle(
                                color: widget.secondaryTextColor,
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
