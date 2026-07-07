import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_dashboard.dart';
import 'admin_users_screen.dart';
import 'admin_verifications_screen.dart';
import 'admin_disputes_screen.dart';

class AdminShell extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const AdminShell({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  // Colors
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get primaryTextColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor =>
      widget.isDarkMode ? Colors.white70 : Colors.black54;
  Color get topIconColor => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get topButtonBackground =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get chipBorderColor =>
      widget.isDarkMode ? Colors.white12 : Colors.black12;

  // Selected tab color
  final Color _gold = const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final direction = widget.isArabic ? TextDirection.rtl : TextDirection.ltr;

    // The 4 screens for the Admin Shell
    final screens = [
      AdminDashboard(
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
        onNavigateTab: (index) => setState(() => _currentIndex = index),
      ),
      AdminUsersScreen(
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
      ),
      AdminVerificationsScreen(
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
      ),
      AdminDisputesScreen(
        isArabic: widget.isArabic,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: backgroundColor.withValues(alpha: 0.85),
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button (to exit admin mode)
                      _topBarButton(
                        icon: widget.isArabic
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios,
                        label: "",
                        onTap: () => Navigator.pop(context),
                      ),
                      
                      // App Title inside the Shell
                      Text(
                        "CraftGo Admin",
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _gold,
                        ),
                      ),

                      // Language & Theme Toggles
                      Row(
                        children: [
                          _topBarButton(
                            icon: Icons.language,
                            label: widget.isArabic ? "EN" : "عربي",
                            onTap: widget.onToggleLanguage,
                          ),
                          const SizedBox(width: 8),
                          _topBarButton(
                            icon: widget.isDarkMode
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            label: "",
                            onTap: widget.onToggleTheme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (idx) => setState(() => _currentIndex = idx),
              backgroundColor: backgroundColor,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _gold,
              unselectedItemColor: secondaryTextColor,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: widget.isArabic ? 'Cairo' : null,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 11,
                fontFamily: widget.isArabic ? 'Cairo' : null,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard_outlined),
                  activeIcon: const Icon(Icons.dashboard_rounded),
                  label: widget.isArabic ? 'الرئيسية' : 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.people_outline),
                  activeIcon: const Icon(Icons.people_rounded),
                  label: widget.isArabic ? 'المستخدمين' : 'Users',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.verified_user_outlined),
                  activeIcon: const Icon(Icons.verified_user_rounded),
                  label: widget.isArabic ? 'التوثيق' : 'Verifications',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.gavel_outlined),
                  activeIcon: const Icon(Icons.gavel_rounded),
                  label: widget.isArabic ? 'النزاعات' : 'Disputes',
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: topButtonBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: topIconColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: topIconColor,
                  fontSize: 12,
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
