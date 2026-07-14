import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/admin_users_screen.dart';
import '../screens/admin/admin_verifications_screen.dart';
import '../screens/admin/admin_disputes_screen.dart';
import '../widgets/role_selection_screen.dart';

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
                      // Logout button
                      _topBarButton(
                        icon: Icons.logout_rounded,
                        label: widget.isArabic ? 'خروج' : 'Logout',
                        onTap: () => _showLogoutDialog(context),
                        isDestructive: true,
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: backgroundColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.logout_rounded, color: Colors.red, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.isArabic ? 'تسجيل الخروج' : 'Sign Out',
                      style: GoogleFonts.cairo(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isArabic
                          ? 'هل أنت متأكد من رغبتك بالخروج من لوحة الإدارة؟'
                          : 'Are you sure you want to exit the Admin panel?',
                      style: GoogleFonts.cairo(
                        color: secondaryTextColor,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Cancel
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: chipBorderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              widget.isArabic ? 'إلغاء' : 'Cancel',
                              style: GoogleFonts.cairo(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Confirm logout
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => RoleSelectionScreen(
                                    isArabic: widget.isArabic,
                                    isDarkMode: widget.isDarkMode,
                                    onToggleLanguage: widget.onToggleLanguage,
                                    onToggleTheme: widget.onToggleTheme,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.isArabic ? 'تأكيد الخروج' : 'Confirm',
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
    );
  }

  Widget _topBarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : topIconColor;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.1)
              : topButtonBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.3)
                : chipBorderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
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
