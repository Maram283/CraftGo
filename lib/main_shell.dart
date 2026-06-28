import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'client_dashboard.dart';
import 'client_profile.dart';
import 'chat_inbox_screen.dart';
import 'my_orders_screen.dart';
import 'ai_order_screen.dart';
import 'customer_login_screen.dart';
import 'cart_screen.dart';
import 'notifications_screen.dart';
import 'favorites_screen.dart';
// ─────────────────────────────────────────────────────────────────────────────
// MainShell — persistent AppBar + BottomNavigationBar
//
// HOW IT WORKS:
//   • This widget owns isArabic / isDarkMode and the toggle callbacks.
//   • Each tab page receives those values as constructor args.
//   • Pages do NOT have their own AppBar or back button — the shell handles it.
//   • Use IndexedStack so pages keep their scroll position when switching tabs.
// ─────────────────────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String? userName; // For logout confirmation

  // For artisan role, pass extra profile data needed by CraftsmanDashboard.
  // null = customer mode.
  final Map<String, String>? craftsmanProfile;
  final bool isGuest;

  const MainShell({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    this.craftsmanProfile,
    this.userName,
    this.isGuest = false,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // ── Local state — initialized to false until initState runs ───────────────
  bool _isArabic = false;
  bool _isDarkMode = true;
  bool _stateReady = false;

  @override
  void initState() {
    super.initState();
    _isArabic = widget.isArabic;
    _isDarkMode = widget.isDarkMode;
    _stateReady = true;
  }

  @override
  void didUpdateWidget(covariant MainShell old) {
    super.didUpdateWidget(old);
    if (old.isArabic != widget.isArabic) setState(() => _isArabic = widget.isArabic);
    if (old.isDarkMode != widget.isDarkMode) setState(() => _isDarkMode = widget.isDarkMode);
  }

  void _toggleLanguage() {
    setState(() => _isArabic = !_isArabic);
    widget.onToggleLanguage();
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    widget.onToggleTheme();
  }

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _gold = Color(0xFFFFD700);
  static const Color _navy = Color(0xFF0D1B33);

  Color get _bg => _isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get _surface => _isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get _primaryText => _isDarkMode ? Colors.white : Colors.black87;
  Color get _border => _isDarkMode ? Colors.white12 : Colors.black12;
  Color get _accent => _isDarkMode ? _gold : _navy;
  Color get _unselected => _isDarkMode ? Colors.white38 : Colors.black38;

  // ── Tab titles ────────────────────────────────────────────────────────────
  List<String> get _titles => _isArabic
      ? ['الرئيسية', 'البحث الذكي', 'طلباتي', 'الرسائل', 'حسابي']
      : ['Home', 'AI Search', 'My Orders', 'Chats', 'Profile'];

  // ── Pages ─────────────────────────────────────────────────────────────────
  List<Widget> get _pages => [
    // ── Tab 0: Home / Customer Dashboard (Always accessible) ──────────────
    ClientDashboard(
      isArabic: _isArabic,
      isDarkMode: _isDarkMode,
      onToggleLanguage: _toggleLanguage,
      onToggleTheme: _toggleTheme,
      isGuest: widget.isGuest,
    ),

    // ── Tab 1: AI Search ──────────────────────────────────────────────────
    widget.isGuest
        ? _buildLoginRequiredView(Icons.auto_awesome, _titles[1])
        : AIOrderScreen(
            isArabic: _isArabic,
            isDarkMode: _isDarkMode,
          ),
          
    // ── Tab 2: My Orders ──────────────────────────────────────────────────
    widget.isGuest
        ? _buildLoginRequiredView(Icons.receipt_long, _titles[2])
        : MyOrdersScreen(
            isArabic: _isArabic,
            isDarkMode: _isDarkMode,
          ),

    // ── Tab 3: Chats ──────────────────────────────────────────────────────
    widget.isGuest
        ? _buildLoginRequiredView(Icons.chat_bubble_outline, _titles[3])
        : ChatInboxScreen(
            isArabic: _isArabic,
            isDarkMode: _isDarkMode,
          ),
          
    // ── Tab 4: Profile ────────────────────────────────────────────────────
    widget.isGuest
        ? _buildLoginRequiredView(Icons.person_outline, _titles[4])
        : CustomerProfileScreen(
            isArabic: _isArabic,
            isDarkMode: _isDarkMode,
            onToggleLanguage: _toggleLanguage,
            onToggleTheme: _toggleTheme,
            userName: widget.userName ?? 'User',
          ),
  ];

  Widget _buildLoginRequiredView(IconData icon, String title) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: _primaryText, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 60, color: _accent),
              ),
              const SizedBox(height: 24),
              Text(
                _isArabic ? "ميزة للأعضاء فقط" : "Members Only Feature",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isArabic 
                    ? "يرجى تسجيل الدخول للوصول إلى هذه الميزة والاستمتاع بكامل خدمات CraftGo."
                    : "Please log in to access this feature and enjoy all CraftGo services.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: _primaryText.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to Login screen and remove MainShell from stack
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerLoginScreen(
                          isArabic: _isArabic,
                          isDarkMode: _isDarkMode,
                          onToggleLanguage: _toggleLanguage,
                          onToggleTheme: _toggleTheme,
                          onLoginSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainShell(
                                  isArabic: _isArabic,
                                  isDarkMode: _isDarkMode,
                                  onToggleLanguage: _toggleLanguage,
                                  onToggleTheme: _toggleTheme,
                                  isGuest: false,
                                ),
                              ),
                            );
                          },
                          onGuestAccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainShell(
                                  isArabic: _isArabic,
                                  isDarkMode: _isDarkMode,
                                  onToggleLanguage: _toggleLanguage,
                                  onToggleTheme: _toggleTheme,
                                  isGuest: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    _isArabic ? "تسجيل الدخول" : "Login Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Guest Prompt Dialog ──────────────────────────────────────────────────
  void _showGuestPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          _isArabic ? 'تنبيه' : 'Notice',
          style: TextStyle(color: _primaryText, fontWeight: FontWeight.bold),
        ),
        content: Text(
          _isArabic 
              ? 'يرجى تسجيل الدخول للوصول إلى هذه الميزة.' 
              : 'Please log in to access this feature.',
          style: TextStyle(color: _primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: _primaryText.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerLoginScreen(
                    isArabic: _isArabic,
                    isDarkMode: _isDarkMode,
                    onToggleLanguage: _toggleLanguage,
                    onToggleTheme: _toggleTheme,
                    onLoginSuccess: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainShell(
                            isArabic: _isArabic,
                            isDarkMode: _isDarkMode,
                            onToggleLanguage: _toggleLanguage,
                            onToggleTheme: _toggleTheme,
                            isGuest: false,
                          ),
                        ),
                      );
                    },
                    onGuestAccess: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainShell(
                            isArabic: _isArabic,
                            isDarkMode: _isDarkMode,
                            onToggleLanguage: _toggleLanguage,
                            onToggleTheme: _toggleTheme,
                            isGuest: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Text(
              _isArabic ? 'تسجيل الدخول' : 'Login',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logout Dialog ──────────────────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surface,
        title: Text(
          _isArabic ? 'تسجيل الخروج' : 'Logout',
          style: TextStyle(color: _primaryText),
        ),
        content: Text(
          _isArabic
              ? 'هل أنت متأكد من رغبتك في تسجيل الخروج؟'
              : 'Are you sure you want to logout?',
          style: TextStyle(color: _primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: _primaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate back to login/onboarding
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text(
              _isArabic ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: _bg,

          // ── AppBar ──────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: _surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: Text(
              _titles[_currentIndex],
              style: TextStyle(
                color: _primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              // Favorites
              _IconBtn(
                icon: Icons.favorite_border_rounded,
                color: _primaryText,
                surface: _surface,
                border: _border,
                onTap: () {
                  if (widget.isGuest) {
                    _showGuestPromptDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FavoritesScreen(
                          isArabic: _isArabic,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),

              // Cart
              _IconBtn(
                icon: Icons.shopping_cart_outlined,
                color: _primaryText,
                surface: _surface,
                border: _border,
                onTap: () {
                  if (widget.isGuest) {
                    _showGuestPromptDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(
                          isArabic: _isArabic,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),

              // Notifications
              _IconBtn(
                icon: Icons.notifications_none_rounded,
                color: _primaryText,
                surface: _surface,
                border: _border,
                badge: true,
                onTap: () {
                  if (widget.isGuest) {
                    _showGuestPromptDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(
                          isArabic: _isArabic,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),

              // Language toggle
              _TextBtn(
                label: _isArabic ? 'EN' : 'عربي',
                icon: Icons.language_rounded,
                color: _primaryText,
                surface: _surface,
                border: _border,
                onTap: _toggleLanguage,
              ),
              const SizedBox(width: 8),

              // Theme toggle
              _IconBtn(
                icon: _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: _primaryText,
                surface: _surface,
                border: _border,
                onTap: _toggleTheme,
              ),
              const SizedBox(width: 16),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, color: _border),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          // IndexedStack keeps each page alive (preserves scroll, state, etc.)
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // ── Bottom Nav ──────────────────────────────────────────────────
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: _surface,
              border: Border(top: BorderSide(color: _border)),
            ),
            child: SafeArea(
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: _isArabic ? 'الرئيسية' : 'Home',
                      index: 0,
                      current: _currentIndex,
                      accent: _accent,
                      unselected: _unselected,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                    _NavItem(
                      icon: Icons.auto_awesome_rounded,
                      label: _isArabic ? 'AI بحث' : 'AI Search',
                      index: 1,
                      current: _currentIndex,
                      accent: _accent,
                      unselected: _unselected,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                    _NavItemCenter(
                      icon: Icons.receipt_long_rounded,
                      label: _isArabic ? 'طلباتي' : 'Orders',
                      index: 2,
                      current: _currentIndex,
                      accent: _accent,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                    _NavItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: _isArabic ? 'الرسائل' : 'Chats',
                      index: 3,
                      current: _currentIndex,
                      accent: _accent,
                      unselected: _unselected,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      label: _isArabic ? 'حسابي' : 'Profile',
                      index: 4,
                      current: _currentIndex,
                      accent: _accent,
                      unselected: _unselected,
                      onTap: (i) => setState(() => _currentIndex = i),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom nav items
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final Color accent, unselected;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.accent,
    required this.unselected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: sel ? accent : unselected),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: sel ? accent : unselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemCenter extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final Color accent;
  final ValueChanged<int> onTap;

  const _NavItemCenter({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 48,
              height: 36,
              decoration: BoxDecoration(
                color: sel ? accent : accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 22, color: sel ? Colors.black : accent),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: sel ? accent : accent.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBar sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color, surface, border;
  final bool badge;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.surface,
    required this.border,
    this.badge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: surface,
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            if (badge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TextBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color, surface, border;
  final VoidCallback onTap;

  const _TextBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.surface,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder — delete once you wire in the real screen
// ─────────────────────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDarkMode;
  final Color accent, primaryText, secondaryText;

  const _Placeholder({
    required this.label,
    required this.icon,
    required this.isDarkMode,
    required this.accent,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: accent.withOpacity(0.35)),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Placeholder with Logout Button
// ─────────────────────────────────────────────────────────────────────────────

class _ProfilePlaceholder extends StatelessWidget {
  final String label;
  final bool isArabic;
  final bool isDarkMode;
  final Color accent, primaryText, secondaryText, surface, border;
  final String userName;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const _ProfilePlaceholder({
    required this.label,
    required this.isArabic,
    required this.isDarkMode,
    required this.accent,
    required this.primaryText,
    required this.secondaryText,
    required this.surface,
    required this.border,
    required this.userName,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF1C2431),
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: Color(0xFFD4A017),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isArabic ? 'زبون' : 'Customer',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              // Menu Items
              _ProfileMenuItem(
                icon: Icons.person_outline_rounded,
                label: isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
                isDarkMode: isDarkMode,
                primaryText: primaryText,
                secondaryText: secondaryText,
                surface: surface,
                border: border,
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                label: isArabic ? 'طلباتي' : 'My Orders',
                isDarkMode: isDarkMode,
                primaryText: primaryText,
                secondaryText: secondaryText,
                surface: surface,
                border: border,
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.favorite_border,
                label: isArabic ? 'المفضلة' : 'Wishlist',
                isDarkMode: isDarkMode,
                primaryText: primaryText,
                secondaryText: secondaryText,
                surface: surface,
                border: border,
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                label: isArabic ? 'الإعدادات' : 'Settings',
                isDarkMode: isDarkMode,
                primaryText: primaryText,
                secondaryText: secondaryText,
                surface: surface,
                border: border,
                onTap: () {},
              ),
              const SizedBox(height: 30),

              // Language & Theme Toggles in Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileToggleButton(
                    icon: Icons.language,
                    label: isArabic ? 'EN' : 'عربي',
                    isDarkMode: isDarkMode,
                    primaryText: primaryText,
                    surface: surface,
                    border: border,
                    onTap: onToggleLanguage,
                  ),
                  const SizedBox(width: 12),
                  _ProfileToggleButton(
                    icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    label: '',
                    isDarkMode: isDarkMode,
                    primaryText: primaryText,
                    surface: surface,
                    border: border,
                    onTap: onToggleTheme,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: Text(
                    isArabic ? 'تسجيل الخروج' : 'Logout',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final Color primaryText, secondaryText, surface, border;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.isDarkMode,
    required this.primaryText,
    required this.secondaryText,
    required this.surface,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        color: isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFD4A017)),
        title: Text(
          label,
          style: TextStyle(color: primaryText),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: secondaryText),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _ProfileToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final Color primaryText, surface, border;
  final VoidCallback onTap;

  const _ProfileToggleButton({
    required this.icon,
    required this.label,
    required this.isDarkMode,
    required this.primaryText,
    required this.surface,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: primaryText),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: primaryText,
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