import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exhibition_owner_dashboard.dart';
import 'my_exhibitions_screen.dart';

// Assuming NotificationsScreen exists, but we'll mock it if it doesn't.
// It seems NotificationsScreen might be missing or in another file, 
// so I'll create a _ComingSoonPage for it if it fails to import. 
// I'll just use _ComingSoonPage for now to avoid compilation errors if it's not ready.

class ExhibitionOwnerShell extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String ownerName;

  const ExhibitionOwnerShell({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.ownerName,
  });

  @override
  State<ExhibitionOwnerShell> createState() => _ExhibitionOwnerShellState();
}

class _ExhibitionOwnerShellState extends State<ExhibitionOwnerShell> {
  int _currentIndex = 0;

  Color get bg =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.1);
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              widget.isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
              color: text,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'CraftGo',
            style: GoogleFonts.playfairDisplay(
              color: accent,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.language, color: text),
              onPressed: widget.onToggleLanguage,
            ),
            IconButton(
              icon: Icon(
                  widget.isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: text),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ExhibitionOwnerDashboard(
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
              ownerName: widget.ownerName,
            ),
            MyExhibitionsScreen(
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
            ),
            _ComingSoonPage(
              title: t('الإشعارات', 'Notifications'),
              icon: Icons.notifications_active_outlined,
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
            ),
            _ExhibitionOwnerProfilePage(
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
              ownerName: widget.ownerName,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: surface,
          selectedItemColor: accent,
          unselectedItemColor: dim,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.cairo(),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: t('الرئيسية', 'Home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.museum_outlined),
              activeIcon: const Icon(Icons.museum),
              label: t('معارضي', 'Exhibitions'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              activeIcon: const Icon(Icons.notifications),
              label: t('الإشعارات', 'Notifications'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: t('حسابي', 'Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExhibitionOwnerProfilePage extends StatelessWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String ownerName;

  const _ExhibitionOwnerProfilePage({
    required this.isArabic,
    required this.isDarkMode,
    required this.ownerName,
  });

  Color get bg => isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => isDarkMode ? Colors.white : Colors.black87;
  Color get dim => isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.1);
  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF6A1B9A).withValues(alpha: 0.2),
            child: Text(
              isArabic ? ownerName.substring(0, 1) : ownerName.substring(0, 1),
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ownerName,
            style: GoogleFonts.cairo(
                color: text, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'razan@craftgo.com',
            style: GoogleFonts.cairo(color: dim, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(t('معارض', 'Exhibitions'), '3'),
                Container(width: 1, height: 40, color: border),
                _buildStat(t('حرفيين', 'Artisans'), '8'),
                Container(width: 1, height: 40, color: border),
                _buildStat(t('طلبات', 'Requests'), '15'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildOptionTile(Icons.settings_outlined, t('الإعدادات', 'Settings')),
          _buildOptionTile(
              Icons.help_outline, t('المساعدة والدعم', 'Help & Support')),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              // Pop all screens until the very first route (login/role selection)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(t('تسجيل الخروج', 'Logout'),
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.cairo(
                color: text, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.cairo(color: dim, fontSize: 13)),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.cairo(
              color: text, fontSize: 16, fontWeight: FontWeight.bold)),
      trailing: Icon(isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: dim, size: 16),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isArabic;
  final bool isDarkMode;

  const _ComingSoonPage({
    required this.title,
    required this.icon,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color text = isDarkMode ? Colors.white : Colors.black87;
    Color dim = isDarkMode ? Colors.white70 : Colors.black54;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: const Color(0xFFD4A017).withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.cairo(
                color: text, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'هذه الميزة قيد التطوير' : 'This feature is coming soon',
            style: GoogleFonts.cairo(color: dim, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
