import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerProfileScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String userName;

  const CustomerProfileScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    this.userName = 'Customer',
  });

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  // Mock user data
  String name = 'Ahmed Al-Masri';
  String email = 'ahmed@example.com';
  String phone = '+970 599 123 456';
  String bio = 'Handmade enthusiast, love supporting local artisans.';
  String location = 'Nablus, Palestine';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _phoneController.text = phone;
    _bioController.text = bio;
    _locationController.text = location;
  }

  // Theme colors
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      widget.isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      widget.isDarkMode ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08);

  Color get surfaceColor =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  void _showEditProfileSheet() {
    _nameController.text = name;
    _phoneController.text = phone;
    _bioController.text = bio;
    _locationController.text = location;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: cardBorderColor),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: secondaryTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t('تعديل الملف الشخصي', 'Edit Profile'),
                  style: GoogleFonts.arefRuqaa(
                    color: primaryTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: accent.withOpacity(0.2),
                        child: Icon(Icons.person, size: 50, color: accent),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: surfaceColor, width: 2),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Name
                _buildEditField(
                  label: t('الاسم', 'Full Name'),
                  controller: _nameController,
                ),
                // Email – READ ONLY
                _buildReadOnlyField(
                  label: t('البريد الإلكتروني', 'Email'),
                  value: email,
                ),
                _buildEditField(
                  label: t('رقم الهاتف', 'Phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildEditField(
                  label: t('نبذة', 'Bio'),
                  controller: _bioController,
                  maxLines: 3,
                ),
                _buildEditField(
                  label: t('الموقع', 'Location'),
                  controller: _locationController,
                ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: cardBorderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          t('إلغاء', 'Cancel'),
                          style: TextStyle(color: primaryTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            setState(() {
                              name = _nameController.text.trim();
                              phone = _phoneController.text.trim();
                              bio = _bioController.text.trim();
                              location = _locationController.text.trim();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            t('حفظ', 'Save'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isDarkMode
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.02),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(Icons.lock_outline, size: 16, color: secondaryTextColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          t('الإعدادات', 'Settings'),
          style: GoogleFonts.arefRuqaa(
            color: primaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme Toggle
            ListTile(
              leading: Icon(
                widget.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: accent,
              ),
              title: Text(
                t('الوضع الليلي', 'Dark Mode'),
                style: TextStyle(color: primaryTextColor),
              ),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (_) => widget.onToggleTheme(),
                activeColor: accent,
              ),
            ),
            // Language Toggle
            ListTile(
              leading: Icon(Icons.language, color: accent),
              title: Text(
                t('اللغة', 'Language'),
                style: TextStyle(color: primaryTextColor),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isArabic ? 'عربي' : 'English',
                    style: TextStyle(color: primaryTextColor, fontSize: 13),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.swap_horiz,
                      color: accent,
                      size: 20,
                    ),
                    onPressed: widget.onToggleLanguage,
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.notifications_outlined, color: accent),
              title: Text(
                t('الإشعارات', 'Notifications'),
                style: TextStyle(color: primaryTextColor),
              ),
              trailing: Switch(
                value: true,
                onChanged: (_) {},
                activeColor: accent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: accent),
              title: Text(
                t('الخصوصية', 'Privacy'),
                style: TextStyle(color: primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _showPrivacySheet();
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline, color: accent),
              title: Text(
                t('تغيير كلمة المرور', 'Change Password'),
                style: TextStyle(color: primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _showChangePasswordDialog();
              },
            ),
            const Divider(),
            // Logout
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                t('تسجيل الخروج', 'Logout'),
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('إغلاق', 'Close'),
              style: TextStyle(color: accent),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscure1 = true, obscure2 = true, obscure3 = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Directionality(
          textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(t('تغيير كلمة المرور', 'Change Password'),
                style: GoogleFonts.cairo(color: primaryTextColor, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _passField(currentCtrl, t('كلمة المرور الحالية', 'Current Password'), obscure1, () => setDlg(() => obscure1 = !obscure1)),
                const SizedBox(height: 12),
                _passField(newCtrl, t('كلمة المرور الجديدة', 'New Password'), obscure2, () => setDlg(() => obscure2 = !obscure2)),
                const SizedBox(height: 12),
                _passField(confirmCtrl, t('تأكيد كلمة المرور', 'Confirm Password'), obscure3, () => setDlg(() => obscure3 = !obscure3)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: secondaryTextColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(t('تم تغيير كلمة المرور بنجاح ✅', 'Password changed successfully ✅'),
                        style: GoogleFonts.cairo(color: Colors.white)),
                  ));
                },
                child: Text(t('حفظ', 'Save'), style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passField(TextEditingController ctrl, String label, bool obscure, VoidCallback onToggle) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(color: primaryTextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryTextColor),
        prefixIcon: Icon(Icons.lock_outline, color: secondaryTextColor),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: secondaryTextColor, size: 20),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: cardBorderColor.withValues(alpha: 0.5),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cardBorderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accent, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: secondaryTextColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(t('سياسة الخصوصية', 'Privacy Policy'),
                    style: GoogleFonts.cairo(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _privacySection(
                          t('جمع البيانات', 'Data Collection'),
                          t('نجمع بياناتك فقط لتحسين تجربتك على التطبيق. لا نبيع بياناتك لأي جهة خارجية.', 'We collect your data only to improve your app experience. We never sell your data to third parties.'),
                        ),
                        _privacySection(
                          t('الدفع والأمان', 'Payment & Security'),
                          t('جميع المدفوعات محمية بنظام Escrow — لا يصل الحرفي مبلغه حتى تأكدك من استلام الخدمة.', 'All payments are protected by Escrow — the craftsman does not receive funds until you confirm service delivery.'),
                        ),
                        _privacySection(
                          t('حذف الحساب', 'Account Deletion'),
                          t('يمكنك طلب حذف حسابك وبياناتك في أي وقت عبر التواصل مع الدعم.', 'You can request account and data deletion at any time by contacting support.'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privacySection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 18, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.cairo(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 6),
          Text(body, style: GoogleFonts.cairo(color: secondaryTextColor, fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          t('تسجيل الخروج', 'Logout'),
          style: TextStyle(color: primaryTextColor),
        ),
        content: Text(
          t('هل أنت متأكد من رغبتك في تسجيل الخروج؟', 'Are you sure you want to logout?'),
          style: TextStyle(color: primaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('إلغاء', 'Cancel'),
              style: TextStyle(color: primaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text(
              t('تسجيل الخروج', 'Logout'),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          t('حسابي', 'Profile'),
          style: GoogleFonts.arefRuqaa(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: primaryTextColor),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: accent.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 56,
                      color: accent,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showEditProfileSheet,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: backgroundColor, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: GoogleFonts.arefRuqaa(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: secondaryTextColor),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bio
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardBorderColor),
                ),
                child: Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Only menu item is Wishlist (Orders are separate tab)
              _MenuItem(
                icon: Icons.favorite_border,
                label: t('المفضلة', 'Wishlist'),
                onTap: () {
                  // TODO: navigate to wishlist
                },
                accent: accent,
                primaryText: primaryTextColor,
                surface: surfaceColor,
                border: cardBorderColor,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Menu Item Widget ──────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accent, primaryText, surface, border;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.accent,
    required this.primaryText,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        color: surface,
      ),
      child: ListTile(
        leading: Icon(icon, color: accent),
        title: Text(
          label,
          style: TextStyle(color: primaryText, fontSize: 15),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryText.withOpacity(0.4)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
