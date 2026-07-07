import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'craftsman_dashboard.dart';
import 'craftsman_orders_screen.dart';
import 'chat_inbox_screen.dart';
import 'craftsman_projects_screen.dart';
import 'craftsman_profile_screen.dart';



class CraftsmanShell extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String craftsmanName;
  final String craftsmanCategoryAr;
  final String craftsmanCategoryEn;
  final String craftsmanCity;
  final String craftsmanBio;
  final String craftsmanExperience;
  final bool isVerified;
  final bool isPending;

  const CraftsmanShell({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.craftsmanName,
    required this.craftsmanCategoryAr,
    required this.craftsmanCategoryEn,
    required this.craftsmanCity,
    required this.craftsmanBio,
    required this.craftsmanExperience,
    this.isVerified = true,
    this.isPending = false,
  });

  @override
  State<CraftsmanShell> createState() => _CraftsmanShellState();
}

class _CraftsmanShellState extends State<CraftsmanShell> {
  int _currentIndex = 0;
  
  late bool _isArabic;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isArabic = widget.isArabic;
    _isDarkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant CraftsmanShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isArabic != widget.isArabic) _isArabic = widget.isArabic;
    if (oldWidget.isDarkMode != widget.isDarkMode) _isDarkMode = widget.isDarkMode;
  }

  void _toggleLanguage() {
    setState(() => _isArabic = !_isArabic);
    widget.onToggleLanguage();
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    widget.onToggleTheme();
  }

  // Colors
  Color get bg => _isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => _isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => _isDarkMode ? Colors.white : Colors.black87;
  Color get accent => _isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);
  Color get unselected => _isDarkMode ? Colors.white38 : Colors.black38;

  List<String> get _titles => _isArabic
      ? ['الرئيسية', 'الطلبات', 'مشاريعي', 'الرسائل', 'حسابي']
      : ['Home', 'Orders', 'Projects', 'Messages', 'Profile'];

  String get _name => _isArabic ? 'محمد الحرفي' : 'Mohammed Craftsman';
  String get _city => _isArabic ? 'نابلس، فلسطين' : 'Nablus, Palestine';
  String get _bio => _isArabic ? 'خبير في الأعمال الخشبية الكلاسيكية والمودرن.' : 'Expert in classic and modern woodwork.';
  String get _experience => _isArabic ? '١٢ سنة' : '12 years';

  List<Widget> get _pages => [
    CraftsmanDashboard(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
      onToggleLanguage: _toggleLanguage,
      onToggleTheme: _toggleTheme,
      name: _name,
      categoryTitleAr: widget.craftsmanCategoryAr,
      categoryTitleEn: widget.craftsmanCategoryEn,
      city: _city,
      bio: _bio,
      experience: _experience,
      isVerified: widget.isVerified,
      isPending: widget.isPending,
    ),
    CraftsmanOrdersScreen(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
    ),
    CraftsmanProjectsScreen(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
    ),
    ChatInboxScreen(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
    ),
    CraftsmanProfileScreen(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
      onToggleLanguage: _toggleLanguage,
      onToggleTheme: _toggleTheme,
      craftsmanName: _name,
      craftsmanCategory: _isArabic ? widget.craftsmanCategoryAr : widget.craftsmanCategoryEn,
      craftsmanCity: _city,
      craftsmanBio: _bio,
      craftsmanExperience: _experience,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          toolbarHeight: 0, // Hidden app bar just to reserve safe area color
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              backgroundColor: surface,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: accent,
              unselectedItemColor: unselected,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.normal),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined, size: 24),
                  activeIcon: const Icon(Icons.home_filled, size: 26),
                  label: _titles[0],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long_outlined, size: 24),
                  activeIcon: const Icon(Icons.receipt_long, size: 26),
                  label: _titles[1],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.folder_special_outlined, size: 24),
                  activeIcon: const Icon(Icons.folder_special, size: 26),
                  label: _titles[2],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
                  activeIcon: const Icon(Icons.chat_bubble_rounded, size: 26),
                  label: _titles[3],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded, size: 24),
                  activeIcon: const Icon(Icons.person_rounded, size: 26),
                  label: _titles[4],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
