import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationsScreen — الإشعارات
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const NotificationsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Theme colors
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get border => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.black.withValues(alpha: 0.08);
  Color get accent => widget.isDarkMode ? const Color(0xFFD4A017) : const Color(0xFF0D1B33);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  final List<Map<String, dynamic>> _todayNotifications = [
    {
      'id': '1',
      'type': 'order', // order, message, payment, system
      'titleAr': 'طلب جديد!',
      'titleEn': 'New Order!',
      'bodyAr': 'لقد تلقيت طلباً جديداً من محمد لخدمة النجارة.',
      'bodyEn': 'You have a new order from Mohammed for carpentry.',
      'time': 'منذ 5 دقائق',
      'timeEn': '5 mins ago',
      'unread': true,
    },
    {
      'id': '2',
      'type': 'message',
      'titleAr': 'رسالة جديدة',
      'titleEn': 'New Message',
      'bodyAr': 'سارة أرسلت لك رسالة بخصوص طلب الدهان.',
      'bodyEn': 'Sara sent you a message regarding the painting order.',
      'time': 'منذ ساعتين',
      'timeEn': '2 hours ago',
      'unread': true,
    },
  ];

  final List<Map<String, dynamic>> _yesterdayNotifications = [
    {
      'id': '3',
      'type': 'payment',
      'titleAr': 'دفعة مستلمة',
      'titleEn': 'Payment Received',
      'bodyAr': 'تم استلام دفعة بقيمة 50 دينار في محفظتك.',
      'bodyEn': 'A payment of 50 JD has been added to your wallet.',
      'time': 'أمس, 3:30 م',
      'timeEn': 'Yesterday, 3:30 PM',
      'unread': false,
    },
    {
      'id': '4',
      'type': 'system',
      'titleAr': 'تحديث التطبيق',
      'titleEn': 'App Update',
      'bodyAr': 'نسخة جديدة من كرافت جو متوفرة الآن بميزات جديدة.',
      'bodyEn': 'A new version of CraftGo is available with new features.',
      'time': 'أمس, 9:00 ص',
      'timeEn': 'Yesterday, 9:00 AM',
      'unread': false,
    },
  ];

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order': return Icons.receipt_long;
      case 'message': return Icons.chat_bubble_outline;
      case 'payment': return Icons.account_balance_wallet_outlined;
      case 'system': return Icons.info_outline;
      default: return Icons.notifications_none;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order': return Colors.blue;
      case 'message': return Colors.green;
      case 'payment': return accent;
      case 'system': return dim;
      default: return accent;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _todayNotifications) { n['unread'] = false; }
      for (var n in _yesterdayNotifications) { n['unread'] = false; }
    });
  }

  void _dismissNotification(List list, int index) {
    setState(() => list.removeAt(index));
  }

  void _markAsRead(Map<String, dynamic> n) {
    if (n['unread']) {
      setState(() => n['unread'] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _todayNotifications.isEmpty && _yesterdayNotifications.isEmpty;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(widget.isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('الإشعارات', 'Notifications'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            if (!isEmpty)
              IconButton(
                icon: Icon(Icons.done_all, color: accent),
                tooltip: t('تحديد الكل كمقروء', 'Mark all read'),
                onPressed: _markAllAsRead,
              ),
          ],
        ),
        body: isEmpty ? _buildEmptyState() : _buildList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: border,
            ),
            child: Icon(Icons.notifications_none, size: 80, color: dim),
          ),
          const SizedBox(height: 24),
          Text(
            t('لا يوجد إشعارات', 'No notifications'),
            style: GoogleFonts.cairo(color: text, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            t('سيظهر لك هنا أي تحديثات جديدة', 'You will see new updates here'),
            style: GoogleFonts.cairo(color: dim, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        if (_todayNotifications.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              t('اليوم', 'Today'),
              style: GoogleFonts.cairo(color: dim, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...List.generate(
            _todayNotifications.length,
            (index) => _buildNotificationTile(_todayNotifications, index),
          ),
        ],
        if (_yesterdayNotifications.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              t('أمس', 'Yesterday'),
              style: GoogleFonts.cairo(color: dim, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...List.generate(
            _yesterdayNotifications.length,
            (index) => _buildNotificationTile(_yesterdayNotifications, index),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationTile(List<Map<String, dynamic>> list, int index) {
    final n = list[index];
    final color = _getColorForType(n['type']);
    final isUnread = n['unread'] as bool;

    return Dismissible(
      key: Key(n['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _dismissNotification(list, index),
      background: Container(
        alignment: widget.isArabic ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: InkWell(
        onTap: () => _markAsRead(n),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: isUnread ? accent.withValues(alpha: 0.05) : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconForType(n['type']), color: color, size: 24),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            t(n['titleAr'], n['titleEn']),
                            style: GoogleFonts.cairo(
                              color: text,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          t(n['time'], n['timeEn']),
                          style: GoogleFonts.cairo(color: dim, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t(n['bodyAr'], n['bodyEn']),
                      style: GoogleFonts.cairo(color: isUnread ? text : dim, fontSize: 13, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isUnread) ...[
                const SizedBox(width: 12),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
