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

  bool _aiSorted = false;

  final List<Map<String, dynamic>> _todayNotifications = [
    {
      'id': '0',
      'type': 'ai_suggestion',
      'priority': 'low',
      'titleAr': '💡 اقتراح AI',
      'titleEn': '💡 AI Suggestion',
      'bodyAr': 'حرفي جديد في منطقتك قد يعجبك: فاطمة - تطريز ورسم',
      'bodyEn': 'New artisan near you: Fatima - Embroidery & Art',
      'time': 'الآن',
      'timeEn': 'Just now',
      'unread': true,
      'isAI': true,
    },
    {
      'id': '1',
      'type': 'order', // order, message, payment, system
      'priority': 'high',
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
      'priority': 'medium',
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
      'priority': 'high',
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
      'priority': 'low',
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
      case 'ai_suggestion': return Icons.auto_awesome;
      default: return Icons.notifications_none;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order': return Colors.blue;
      case 'message': return Colors.green;
      case 'payment': return accent;
      case 'system': return dim;
      case 'ai_suggestion': return Colors.purpleAccent;
      default: return accent;
    }
  }

  Color _getAIPriorityColor(String priority) {
    switch (priority) {
      case 'high': return Colors.redAccent;
      case 'medium': return Colors.amber;
      case 'low': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _getAIPriorityLabel(String priority, bool isArabic) {
    switch (priority) {
      case 'high': return isArabic ? '🔴 حرج' : '🔴 Critical';
      case 'medium': return isArabic ? '🟡 متوسط' : '🟡 Medium';
      case 'low': return isArabic ? '🔵 اقتراح' : '🔵 Suggestion';
      default: return '';
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
    // Only filter out AI suggestion if not active
    final todayList = _aiSorted ? _todayNotifications : _todayNotifications.where((n) => n['isAI'] != true).toList();
    final isEmpty = todayList.isEmpty && _yesterdayNotifications.isEmpty;

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
            IconButton(
              icon: Icon(Icons.auto_awesome, color: _aiSorted ? Colors.purpleAccent : dim),
              onPressed: () => setState(() => _aiSorted = !_aiSorted),
            ),
            if (!isEmpty)
              IconButton(
                icon: Icon(Icons.done_all, color: accent),
                tooltip: t('تحديد الكل كمقروء', 'Mark all read'),
                onPressed: _markAllAsRead,
              ),
          ],
        ),
        body: isEmpty ? _buildEmptyState() : _buildList(todayList),
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

  Widget _buildList(List<Map<String, dynamic>> todayList) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        if (_aiSorted)
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('تم ترتيب الإشعارات حسب أهميتها بالذكاء الاصطناعي 🤖', 'Notifications sorted by AI priority 🤖'),
                    style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        if (todayList.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              t('اليوم', 'Today'),
              style: GoogleFonts.cairo(color: dim, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...List.generate(
            todayList.length,
            (index) => _buildNotificationTile(todayList, index),
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
                    if (_aiSorted && n['priority'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getAIPriorityColor(n['priority']).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getAIPriorityLabel(n['priority'], widget.isArabic),
                          style: GoogleFonts.cairo(
                            color: _getAIPriorityColor(n['priority']),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
