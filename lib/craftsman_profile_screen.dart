import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'craftsman_category_screen.dart';
import 'main.dart';
import 'chat_detail_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CraftsmanProfileScreen — حساب الحرفي
// ─────────────────────────────────────────────────────────────────────────────

class CraftsmanProfileScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final String craftsmanName;
  final String craftsmanCategory;
  final String craftsmanCity;
  final String craftsmanBio;
  final String craftsmanExperience;

  const CraftsmanProfileScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.craftsmanName,
    required this.craftsmanCategory,
    required this.craftsmanCity,
    required this.craftsmanBio,
    required this.craftsmanExperience,
  });

  @override
  State<CraftsmanProfileScreen> createState() => _CraftsmanProfileScreenState();
}

class _CraftsmanProfileScreenState extends State<CraftsmanProfileScreen> {
  // Theme colors
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.08);
  Color get accent => widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);

  // Extra crafts added post-registration
  final List<String> _extraCrafts = [];

  String t(String ar, String en) => widget.isArabic ? ar : en;

  void _openAddCraftFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CraftsmanCategoryScreen(
          isArabic: widget.isArabic,
          isDarkMode: widget.isDarkMode,
          onToggleLanguage: widget.onToggleLanguage,
          onToggleTheme: widget.onToggleTheme,
          addCraftMode: true,
          onCraftAdded: (Map<String, dynamic> cat) {
            setState(() {
              final name = widget.isArabic
                  ? cat['titleAr'] as String
                  : cat['titleEn'] as String;
              if (!_extraCrafts.contains(name)) {
                _extraCrafts.add(name);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          title: Text(
            t('حسابي', 'My Profile'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: text),
              onPressed: widget.onToggleTheme,
            ),
            TextButton(
              onPressed: widget.onToggleLanguage,
              child: Text(t('EN', 'عربي'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: accent.withValues(alpha: 0.2),
                  child: Icon(Icons.person, color: accent, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.craftsmanName, style: GoogleFonts.cairo(color: text, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' 4.8', style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Text(widget.craftsmanCategory, style: GoogleFonts.cairo(color: accent, fontSize: 14)),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: dim),
                          const SizedBox(width: 4),
                          Text(widget.craftsmanCity, style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: dim),
                  onPressed: () {},
                )
              ],
            ),
            const SizedBox(height: 32),

            // Bio
            Text(t('نبذة عني', 'About Me'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.craftsmanBio, style: GoogleFonts.cairo(color: dim, fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            Text('${t('الخبرة:', 'Experience:')} ${widget.craftsmanExperience}', style: GoogleFonts.cairo(color: dim, fontSize: 14)),
            
            const SizedBox(height: 32),

            // ── My Crafts section ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('حرفي', 'My Crafts'),
                  style: GoogleFonts.cairo(
                      color: text, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: _openAddCraftFlow,
                  icon: Icon(Icons.add_circle_outline,
                      color: accent, size: 18),
                  label: Text(
                    t('أضف حرفة', 'Add Craft'),
                    style: GoogleFonts.cairo(
                        color: accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Primary craft (always present)
                _craftChip(widget.craftsmanCategory, isPrimary: true),
                // Extra crafts added from profile
                ..._extraCrafts.map((c) => _craftChip(c)),
              ],
            ),

            const SizedBox(height: 32),
            Divider(color: border),
            const SizedBox(height: 24),

            // Options
            _buildOption(Icons.wallet, t('المحفظة والأرباح', 'Wallet & Earnings'), onTap: _showWallet),
            _buildOption(Icons.star_border, t('تقييمات العملاء', 'Customer Reviews'), onTap: _showReviews),
            _buildOption(Icons.settings_outlined, t('الإعدادات', 'Settings'), onTap: _showSettings),
            _buildOption(Icons.help_outline, t('المساعدة والدعم', 'Help & Support'), onTap: _showHelp),
            
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => _showLogoutDialog(),
              child: Text(t('تسجيل الخروج', 'Logout'), style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  void _showWallet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.wallet, color: accent),
                    const SizedBox(width: 8),
                    Text(t('المحفظة والأرباح', 'Wallet & Earnings'),
                        style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color(0xFFD4A017).withValues(alpha: 0.15), const Color(0xFFD4A017).withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(t('إجمالي الأرباح', 'Total Earnings'), style: GoogleFonts.cairo(color: dim, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('1,250 JD', style: GoogleFonts.cairo(color: const Color(0xFFD4A017), fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Text(t('هذا الشهر', 'This Month'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
                          Text('320 JD', style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
                        ]),
                        Container(width: 1, height: 30, color: border),
                        Column(children: [
                          Text(t('قيد الانتظار (Escrow)', 'Pending (Escrow)'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
                          Text('850 JD', style: GoogleFonts.cairo(color: Colors.orange, fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(t('آخر المعاملات', 'Recent Transactions'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _txTile(t('دفع من نور الدين', 'Payment from Nour'), '+ 850 JD', '2026-01-05', true),
                    _txTile(t('دفع من ليلى الحسن', 'Payment from Layla'), '+ 320 JD', '2026-12-28', true),
                    _txTile(t('سحب إلى الحساب البنكي', 'Bank Withdrawal'), '- 400 JD', '2026-12-20', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _txTile(String title, String amount, String date, bool isIn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isIn ? Colors.green : Colors.red).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIn ? Colors.green : Colors.red, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                String clientName = title.contains('نور الدين') || title.contains('Nour')
                    ? t('نور الدين', 'Nour El-Din')
                    : t('ليلى الحسن', 'Layla Al-Hassan');
                _showClientProfileSheet(context, clientName, t('نابلس، فلسطين', 'Nablus, Palestine'));
              },
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  color: text,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: accent,
                ),
              ),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: GoogleFonts.cairo(color: isIn ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            Text(date, style: GoogleFonts.cairo(color: dim, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  void _showReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(t('تقييمات العملاء', 'Customer Reviews'),
                        style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('4.8 ★', style: GoogleFonts.cairo(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _reviewTile(t('نور الدين', 'Nour El-Din'), 5, t('عمل رائع وسريع ومحترف جداً! سأتعامل معه مرة أخرى بالتأكيد.', 'Excellent, fast and very professional work! Will definitely work with them again.'), '2026-01-04'),
                    _reviewTile(t('ليلى الحسن', 'Layla Al-Hassan'), 4, t('ممتاز، النتيجة أفضل من المتوقع. شكراً جزيلاً.', 'Excellent, the result was better than expected. Thank you so much.'), '2026-12-27'),
                    _reviewTile(t('خالد المنصور', 'Khalid Al-Mansour'), 5, t('خدمة احترافية من أول لآخر. الدقة في العمل تشهد له.', 'Professional service from start to finish. The precision in work speaks for itself.'), '2026-12-18'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewTile(String name, int stars, String comment, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: accent.withValues(alpha: 0.15), child: Icon(Icons.person, color: accent, size: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showClientProfileSheet(context, name, t('نابلس، فلسطين', 'Nablus, Palestine')),
                  child: Text(
                    name,
                    style: GoogleFonts.cairo(
                      color: text,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: accent,
                    ),
                  ),
                ),
              ),
              Row(children: List.generate(5, (i) => Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: Colors.amber))),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5)),
          const SizedBox(height: 6),
          Text(date, style: GoogleFonts.cairo(color: dim.withValues(alpha: 0.5), fontSize: 11)),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.settings_outlined, color: accent),
                  const SizedBox(width: 8),
                  Text(t('الإعدادات', 'Settings'), style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _settingRow(Icons.notifications_outlined, t('الإشعارات', 'Notifications'), t('فعّال', 'Enabled'), onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('تم تعديل إعدادات الإشعارات', 'Notification settings updated'))));
              }),
              _settingRow(Icons.language, t('اللغة', 'Language'), widget.isArabic ? 'العربية' : 'English', onTap: () {
                Navigator.pop(ctx);
                widget.onToggleLanguage();
              }),
              _settingRow(Icons.lock_outline, t('تغيير كلمة المرور', 'Change Password'), '', onTap: () {
                Navigator.pop(ctx);
                _showPasswordResetDialog();
              }),
              _settingRow(Icons.privacy_tip_outlined, t('الخصوصية', 'Privacy'), '', onTap: () {
                Navigator.pop(ctx);
                _showPrivacySheet();
              }),
              _settingRow(Icons.delete_outline, t('حذف الحساب', 'Delete Account'), '', isRed: true, onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('لا يمكن حذف حساب تجريبي', 'Demo account cannot be deleted'))));
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showPasswordResetDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t('تغيير كلمة المرور', 'Change Password'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: TextStyle(color: text),
          decoration: InputDecoration(
            labelText: t('كلمة المرور الجديدة', 'New Password'),
            labelStyle: TextStyle(color: dim),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: border)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t('إلغاء', 'Cancel'), style: TextStyle(color: dim))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('تم تغيير كلمة المرور بنجاح!', 'Password changed successfully!'))));
            },
            child: Text(t('حفظ', 'Save'), style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('سياسة الخصوصية', 'Privacy Policy'), style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              t(
                'نحن في كرافت جو نلتزم بحماية بياناتك الشخصية ومشاركتها فقط لغايات إتمام الطلبات وتأمين الدفعات عبر نظام الضمان (Escrow).',
                'We at CraftGo are committed to protecting your personal data and sharing it only for fulfilling orders and securing payments via Escrow.'
              ),
              style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showClientProfileSheet(BuildContext context, String name, String location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 36,
                backgroundColor: accent.withValues(alpha: 0.15),
                child: Text(name[0], style: GoogleFonts.cairo(color: accent, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Text(name, style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: dim),
                  const SizedBox(width: 4),
                  Text(location, style: GoogleFonts.cairo(color: dim, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t('عميل موثوق في كرافت جو. انضم منذ عام ٢٠٢٦.', 'Verified customer on CraftGo. Joined since 2026.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                  label: Text(t('بدء دردشة', 'Start Chat'), style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(ctx); // close sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          isArabic: widget.isArabic,
                          isDarkMode: widget.isDarkMode,
                          name: name,
                          craft: t('طلب مخصص', 'Custom request'),
                          online: true,
                          orderTitle: t('طلب مخصص', 'Custom request'),
                          orderStatus: 'bidding',
                          orderPrice: '—',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingRow(IconData icon, String title, String value, {bool isRed = false, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isRed ? Colors.redAccent : accent, size: 20),
      title: Text(title, style: GoogleFonts.cairo(color: isRed ? Colors.redAccent : text, fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: value.isNotEmpty
          ? Text(value, style: GoogleFonts.cairo(color: dim, fontSize: 13))
          : Icon(widget.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios, size: 14, color: dim),
      onTap: onTap,
    );
  }

  void _showHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.help_outline, color: accent),
                  const SizedBox(width: 8),
                  Text(t('المساعدة والدعم', 'Help & Support'), style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _helpTile(Icons.chat_outlined, t('تواصل مع الدعم', 'Contact Support'), t('متاح 24/7 عبر المحادثة المباشرة', 'Available 24/7 via live chat')),
              _helpTile(Icons.menu_book_outlined, t('مركز المساعدة', 'Help Center'), t('إجابات على الأسئلة الشائعة', 'Answers to frequently asked questions')),
              _helpTile(Icons.bug_report_outlined, t('الإبلاغ عن مشكلة', 'Report a Problem'), t('أرسل لنا تقريراً عن الخطأ', 'Send us a bug report')),
              _helpTile(Icons.star_outline, t('قيّم التطبيق', 'Rate the App'), t('شاركنا رأيك على متجر التطبيقات', 'Share your feedback on the app store')),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  t('الإصدار 1.0.0 | CraftGo © 2026', 'Version 1.0.0 | CraftGo © 2026'),
                  style: GoogleFonts.cairo(color: dim.withValues(alpha: 0.5), fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _helpTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title, style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: GoogleFonts.cairo(color: dim, fontSize: 12)),
      trailing: Icon(widget.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios, size: 14, color: dim),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          t('تسجيل الخروج', 'Logout'),
          style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
        ),
        content: Text(
          t('هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              'Are you sure you want to logout?'),
          style: GoogleFonts.cairo(color: dim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('إلغاء', 'Cancel'),
                style: GoogleFonts.cairo(color: dim)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => OnboardingScreen(
                    isArabic: widget.isArabic,
                    isDarkMode: widget.isDarkMode,
                    onToggleLanguage: widget.onToggleLanguage,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
                (route) => false,
              );
            },
            child: Text(t('تسجيل الخروج', 'Logout'),
                style: GoogleFonts.cairo(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _craftChip(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? accent.withValues(alpha: 0.15) : surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? accent : border,
          width: isPrimary ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handyman_outlined, size: 14, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: isPrimary ? accent : text,
              fontSize: 13,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isPrimary) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                t('رئيسية', 'Primary'),
                style: GoogleFonts.cairo(
                    color: accent, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border)),
        child: Icon(icon, color: accent, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.cairo(
              color: text, fontSize: 15, fontWeight: FontWeight.bold)),
      trailing: Icon(
          widget.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          size: 16,
          color: dim),
      onTap: onTap,
    );
  }
}
