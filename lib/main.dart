import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/role_selection_screen.dart';
import 'screens/custom_order/custom_order_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomOrderProvider()),
      ],
      child: const CraftGoApp(),
    ),
  );
}

class CraftGoApp extends StatefulWidget {
  const CraftGoApp({super.key});

  static _CraftGoAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CraftGoAppState>();
  }

  @override
  State<CraftGoApp> createState() => _CraftGoAppState();
}

class _CraftGoAppState extends State<CraftGoApp> {
  bool isArabic = true;
  bool isDarkMode = true;

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  void toggleLocale() => toggleLanguage();

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CraftGo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D1420),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(
          isArabic: isArabic,
          isDarkMode: isDarkMode,
          onToggleLanguage: toggleLanguage,
          onToggleTheme: toggleTheme,
        ),
      },
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const OnboardingScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  bool get isArabic => widget.isArabic;
  bool get isDarkMode => widget.isDarkMode;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // ---------------- Text Dictionary (AR / EN) ----------------
  String get titleText =>
      isArabic ? "فن حقيقي بأيد موثوقة" : "Real Craft, Trusted Hands";

  String get startButtonText => isArabic ? "ابدأ رحلتك" : "Start Your Journey";

  String get aiOrdersText =>
      isArabic ? "طلبات ذكية بالـ AI" : "AI Smart Orders";

  String get bidsText => isArabic ? "عروض تنافسية" : "Competitive Bids";

  String get escrowText => isArabic ? "ضمان دفع آمن" : "Secure Escrow";

  // ---------------- Theme-aware colors ----------------
  // Gold tones: bright & vivid for dark mode, deep/rich for accents
  static const Color goldBright = Color(0xFFFFD700);
  static const Color goldBrightLight = Color(0xFFFFEC8B);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color navy = Color(0xFF0D1B33);
  static const Color navyLight = Color(0xFF1B3A66);

  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor => isDarkMode ? Colors.white70 : Colors.black54;

  Color get chipBackgroundColor =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get chipBorderColor => isDarkMode ? Colors.white12 : Colors.black12;

  Color get cardBorderColor => isDarkMode ? Colors.white24 : Colors.black26;

  Color get topIconColor => isDarkMode ? Colors.white : Colors.black87;

  Color get topButtonBackground =>
      isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  // Main CTA button: bright gold in dark mode, navy in light mode
  List<Color> get ctaGradient =>
      isDarkMode ? [goldBrightLight, goldBright] : [navyLight, navy];

  Color get ctaGlowColor => isDarkMode
      ? goldBright.withValues(alpha: 0.55)
      : navy.withValues(alpha: 0.35);

  Color get ctaTextColor => isDarkMode ? Colors.black : Colors.white;

  // Icon accent color for feature chips: bright gold in dark mode, navy in light mode
  Color get chipIconColor => isDarkMode ? goldBright : navy;

  // Shimmer base/highlight colors for the tagline (gold + navy theme)
  List<Color> get shimmerColors => isDarkMode
      ? [goldBright, Colors.white, navyLight, goldBright]
      : [navy, goldDark, Colors.white, navy];

  // Logo shimmer: same bright gold tones as the CTA button, in both themes
  List<Color> get logoShimmerColors => isDarkMode
      ? [goldBright, goldBrightLight, Colors.white, goldBrightLight, goldBright]
      : [goldDark, goldBright, Colors.white, goldBright, goldDark];

  // ── Hero Stat Helper ──────────────────────────────────────────────────────
  Widget _buildHeroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD4A017),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ---------------- Top Bar: Language + Theme toggles ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _topBarButton(
                          icon: Icons.language,
                          label: isArabic ? "EN" : "عربي",
                          onTap: widget.onToggleLanguage,
                        ),
                        const SizedBox(width: 10),
                        _topBarButton(
                          icon: isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          label: "",
                          onTap: widget.onToggleTheme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Logo — bright animated gold shimmer, matches the CTA button color
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        final dx = _shimmerController.value;
                        return ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: logoShimmerColors,
                              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                              begin: Alignment(-1.0 + dx * 3, -0.3),
                              end: Alignment(1.0 + dx * 3, 0.3),
                              tileMode: TileMode.clamp,
                            ).createShader(bounds);
                          },
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 200,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // Images Section
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            top: 65,
                            child: _glassCard(
                              'assets/images/plate.jpg',
                              width: 95,
                              height: 120,
                            ),
                          ),
                          Positioned(
                            left: 55,
                            top: 35,
                            child: _glassCard(
                              'assets/images/pottery.jpg',
                              width: 105,
                              height: 135,
                            ),
                          ),
                          Positioned(
                            left: 125,
                            top: 0,
                            child: _glassCard(
                              'assets/images/jewelry.jpg',
                              width: 130,
                              height: 180,
                            ),
                          ),
                          Positioned(
                            right: 55,
                            top: 35,
                            child: _glassCard(
                              'assets/images/basket.jpg',
                              width: 105,
                              height: 135,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 65,
                            child: _glassCard(
                              'assets/images/crochet.jpg',
                              width: 95,
                              height: 120,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── 🆕 HERO BANNER ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFF1A2840), Color(0xFF0D1420)],
                        ),
                        border: Border.all(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4A017).withValues(alpha: 0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFD4A017),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic
                                    ? "مرحباً بك في CraftGo"
                                    : "Welcome to CraftGo",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isArabic
                                ? "اكتشف فن الحرف اليدوية"
                                : "Discover Handcraft Art",
                            style: GoogleFonts.arefRuqaa(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic
                                ? "تواصل مع أمهر الحرفيين المحليين وفصّل ما تحلم به"
                                : "Connect with top local artisans and craft your dream piece",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              _buildHeroStat(
                                isArabic ? "500+" : "500+",
                                isArabic ? "حرفي" : "Artisans",
                              ),
                              const SizedBox(width: 20),
                              _buildHeroStat(
                                isArabic ? "20+" : "20+",
                                isArabic ? "حرفة" : "Crafts",
                              ),
                              const SizedBox(width: 20),
                              _buildHeroStat(
                                isArabic ? "98%" : "98%",
                                isArabic ? "رضا الزبائن" : "Satisfaction",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ---------------- Shimmering tagline ----------------
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            final dx = _shimmerController.value;
                            return LinearGradient(
                              colors: logoShimmerColors,
                              begin: Alignment(-1.0 + dx * 2, -0.5),
                              end: Alignment(1.0 + dx * 2, 0.5),
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              titleText,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: GoogleFonts.elMessiri(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FeatureChip(
                          icon: Icons.lightbulb_outline,
                          text: aiOrdersText,
                          backgroundColor: chipBackgroundColor,
                          borderColor: chipBorderColor,
                          textColor: primaryTextColor,
                          iconColor: chipIconColor,
                        ),
                        FeatureChip(
                          icon: Icons.balance,
                          text: bidsText,
                          backgroundColor: chipBackgroundColor,
                          borderColor: chipBorderColor,
                          textColor: primaryTextColor,
                          iconColor: chipIconColor,
                        ),
                        FeatureChip(
                          icon: Icons.shield_outlined,
                          text: escrowText,
                          backgroundColor: chipBackgroundColor,
                          borderColor: chipBorderColor,
                          textColor: primaryTextColor,
                          iconColor: chipIconColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: ctaGradient),
                        boxShadow: [
                          BoxShadow(
                            color: ctaGlowColor,
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoleSelectionScreen(
                                isArabic: isArabic,
                                isDarkMode: isDarkMode,
                                onToggleLanguage: widget.onToggleLanguage,
                                onToggleTheme: widget.onToggleTheme,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          startButtonText,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ctaTextColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Top bar toggle button (language / theme) ----------------
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

  Widget _glassCard(
      String imagePath, {
        required double width,
        required double height,
      }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }
}