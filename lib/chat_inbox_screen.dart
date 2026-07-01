import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_detail_screen.dart';

class ChatInboxScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const ChatInboxScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  // ── Sample chat data ──────────────────────────────────────────────────
  // Each chat is tied to an order/request — that's what orderTitle/
  // orderStatus/orderPrice represent, and what opens the order-shortcut
  // card at the top of the conversation.
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'nameAr': 'أمجد الخطيب',
      'nameEn': 'Amjad Al-Khateeb',
      'lastMessageAr': 'تم تجهيز طلبك، متى يناسبك الاستلام؟',
      'lastMessageEn': 'Your order is ready, when can you pick it up?',
      'time': '10:30',
      'unread': 2,
      'online': true,
      'craftAr': 'أعمال الخشب',
      'craftEn': 'Woodworking',
      'orderTitleAr': 'صندوق خشبي محفور مخصص',
      'orderTitleEn': 'Custom Carved Wooden Box',
      'orderStatus': 'in_progress',
      'orderPrice': '60 JOD',
    },
    {
      'id': '2',
      'nameAr': 'فاطمة محمود',
      'nameEn': 'Fatima Mahmoud',
      'lastMessageAr': 'شكراً لك، سأبدأ بالعمل غداً',
      'lastMessageEn': 'Thank you, I will start working tomorrow',
      'time': 'أمس',
      'unread': 0,
      'online': false,
      'craftAr': 'تطريز',
      'craftEn': 'Embroidery',
      'orderTitleAr': 'سجادة صوفية مطرزة',
      'orderTitleEn': 'Embroidered Wool Rug',
      'orderStatus': 'bidding',
      'orderPrice': '52 JOD',
    },
    {
      'id': '3',
      'nameAr': 'إياد الكردي',
      'nameEn': 'Iyad Al-Kurdi',
      'lastMessageAr': 'هل لديك استفسار عن التصميم؟',
      'lastMessageEn': 'Do you have any questions about the design?',
      'time': 'أمس',
      'unread': 1,
      'online': true,
      'craftAr': 'فخار',
      'craftEn': 'Pottery',
      'orderTitleAr': 'طقم أواني فخارية من 6 قطع',
      'orderTitleEn': '6-Piece Clay Cookware Set',
      'orderStatus': 'bidding',
      'orderPrice': '180 JOD',
    },
    {
      'id': '4',
      'nameAr': 'سارة العلي',
      'nameEn': 'Sara Al-Ali',
      'lastMessageAr': 'تم تسليم الطلب بنجاح ✅',
      'lastMessageEn': 'Order delivered successfully ✅',
      'time': '٢٣ يونيو',
      'unread': 0,
      'online': false,
      'craftAr': 'مجوهرات',
      'craftEn': 'Jewelry',
      'orderTitleAr': 'خاتم فضة مخصص',
      'orderTitleEn': 'Custom Silver Ring',
      'orderStatus': 'completed',
      'orderPrice': '35 JOD',
    },
    {
      'id': '5',
      'nameAr': 'محمد ناصر',
      'nameEn': 'Mohammad Naser',
      'lastMessageAr': 'سأرسل التصميم النهائي خلال ساعة',
      'lastMessageEn': 'I will send the final design within an hour',
      'time': '٢٢ يونيو',
      'unread': 0,
      'online': false,
      'craftAr': 'خط عربي',
      'craftEn': 'Calligraphy',
      'orderTitleAr': 'لوحة جدارية بخط عربي',
      'orderTitleEn': 'Arabic Calligraphy Canvas',
      'orderStatus': 'in_progress',
      'orderPrice': '150 JOD',
    },
  ];

  // ── Search + filter ────────────────────────────────────────────────────
  String _searchQuery = '';
  bool _unreadOnly = false;

  List<Map<String, dynamic>> get _filteredChats {
    var list = _chats;
    if (_unreadOnly) {
      list = list.where((c) => (c['unread'] as int) > 0).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((chat) {
        final name = widget.isArabic
            ? chat['nameAr'].toString().toLowerCase()
            : chat['nameEn'].toString().toLowerCase();
        final lastMsg = widget.isArabic
            ? chat['lastMessageAr'].toString().toLowerCase()
            : chat['lastMessageEn'].toString().toLowerCase();
        final orderTitle = widget.isArabic
            ? chat['orderTitleAr'].toString().toLowerCase()
            : chat['orderTitleEn'].toString().toLowerCase();
        return name.contains(query) || lastMsg.contains(query) || orderTitle.contains(query);
      }).toList();
    }
    return list;
  }

  int get _unreadCount => _chats.where((c) => (c['unread'] as int) > 0).length;

  // ── Theme colors ──────────────────────────────────────────────────────
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);

  Color get primaryTextColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      widget.isDarkMode ? Colors.white70 : Colors.black54;

  Color get cardBorderColor =>
      widget.isDarkMode ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08);

  Color get surfaceColor =>
      widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;

  Color get accent => const Color(0xFFD4A017);

  String t(String ar, String en) => widget.isArabic ? ar : en;

  void _openChat(Map<String, dynamic> chat) {
    setState(() => chat['unread'] = 0); // mark as read
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          isArabic: widget.isArabic,
          isDarkMode: widget.isDarkMode,
          name: widget.isArabic ? chat['nameAr'] : chat['nameEn'],
          craft: widget.isArabic ? chat['craftAr'] : chat['craftEn'],
          online: chat['online'],
          orderTitle: widget.isArabic ? chat['orderTitleAr'] : chat['orderTitleEn'],
          orderStatus: chat['orderStatus'],
          orderPrice: chat['orderPrice'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredChats;
    final direction = widget.isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            t('الرسائل', 'Chats'),
            style: GoogleFonts.arefRuqaa(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Search bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorderColor),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    hintText: t('ابحث عن رسالة، محادثة، أو طلب...', 'Search messages, chats, or orders...'),
                    hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // ── All / Unread filter ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  _FilterChip(
                    label: t('الكل', 'All'),
                    selected: !_unreadOnly,
                    accent: accent,
                    surface: surfaceColor,
                    border: cardBorderColor,
                    primaryText: primaryTextColor,
                    onTap: () => setState(() => _unreadOnly = false),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '${t('غير مقروءة', 'Unread')}${_unreadCount > 0 ? ' ($_unreadCount)' : ''}',
                    selected: _unreadOnly,
                    accent: accent,
                    surface: surfaceColor,
                    border: cardBorderColor,
                    primaryText: primaryTextColor,
                    onTap: () => setState(() => _unreadOnly = true),
                  ),
                ],
              ),
            ),

            // ── Chat list ──────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: secondaryTextColor.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _unreadOnly
                          ? t('لا توجد رسائل غير مقروءة', 'No unread conversations')
                          : t('لا توجد محادثات', 'No conversations'),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final chat = filtered[index];
                  final name = widget.isArabic ? chat['nameAr'] : chat['nameEn'];
                  final lastMessage = widget.isArabic
                      ? chat['lastMessageAr']
                      : chat['lastMessageEn'];
                  final orderTitle =
                  widget.isArabic ? chat['orderTitleAr'] : chat['orderTitleEn'];
                  final time = chat['time'];
                  final unread = chat['unread'] as int;
                  final online = chat['online'] as bool;

                  return _ChatTile(
                    name: name,
                    lastMessage: lastMessage,
                    orderTitle: orderTitle,
                    time: time,
                    unread: unread,
                    online: online,
                    accent: accent,
                    primaryText: primaryTextColor,
                    secondaryText: secondaryTextColor,
                    surface: surfaceColor,
                    border: cardBorderColor,
                    onTap: () => _openChat(chat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── All/Unread filter chip ───────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent, surface, border, primaryText;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.surface,
    required this.border,
    required this.primaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? accent : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? accent : border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : primaryText,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Chat tile widget ──────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String orderTitle;
  final String time;
  final int unread;
  final bool online;
  final Color accent;
  final Color primaryText;
  final Color secondaryText;
  final Color surface;
  final Color border;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.lastMessage,
    required this.orderTitle,
    required this.time,
    required this.unread,
    required this.online,
    required this.accent,
    required this.primaryText,
    required this.secondaryText,
    required this.surface,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unread > 0 ? accent.withValues(alpha: 0.4) : border,
              width: unread > 0 ? 1.3 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + online dot
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: accent.withValues(alpha: 0.2),
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: TextStyle(color: accent, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (online)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Name, order title chip, last message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: secondaryText.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Order title — small chip so it's clear which order this
                    // thread belongs to, without competing with the message.
                    Row(
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 11, color: accent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            orderTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: TextStyle(
                              color: unread > 0 ? primaryText : secondaryText,
                              fontSize: 13,
                              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unread > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              unread.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}