import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiChatbotScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String? productName;
  final double? productPrice;
  final IconData? productIcon;

  const AiChatbotScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    this.productName,
    this.productPrice,
    this.productIcon,
  });

  @override
  State<AiChatbotScreen> createState() => _AiChatbotScreenState();
}

class _AiChatbotScreenState extends State<AiChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

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
  void initState() {
    super.initState();
    // Initial greeting from Crafty
    if (widget.productName != null) {
      _messages.add({
        'isUser': false,
        'text': widget.isArabic
            ? 'مرحباً! أنا Crafty 🤖 مساعدك الذكي. لقد لاحظت أنك مهتم بـ "${widget.productName}" وسعره الحالي هو ${widget.productPrice?.toStringAsFixed(0)} دينار. هل ترغب في التفاوض على السعر أو تقديم عرض؟ 💸'
            : 'Hello! I am Crafty 🤖 your smart assistant. I noticed you are interested in "${widget.productName}" priced at ${widget.productPrice?.toStringAsFixed(0)} JD. Would you like to negotiate the price or make an offer? 💸',
      });
    } else {
      _messages.add({
        'isUser': false,
        'text': widget.isArabic
            ? 'مرحباً! أنا Crafty 🤖، مساعدك الذكي في CraftGo. كيف يمكنني مساعدتك اليوم؟ (مثال: اقترح لي هدية، كيف أسعر منتجي؟)'
            : 'Hello! I am Crafty 🤖, your smart assistant in CraftGo. How can I help you today? (e.g., Suggest a gift, How to price my product?)',
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();
    setState(() {
      _messages.add({'isUser': true, 'text': userText});
      _controller.clear();
      _isTyping = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        String response = widget.isArabic
            ? 'هذا سؤال رائع! يعتمد التسعير الذكي على حساب تكلفة المواد (مثلاً 10 دنانير) وإضافة قيمة وقتك (مثلاً 5 ساعات × 3 دنانير). بناءً على السوق، أنصحك بسعر بين 35 و 45 دينار.'
            : 'Great question! Smart pricing depends on material costs (e.g. 10 JD) plus your time (e.g. 5 hours × 3 JD). Based on market trends, I suggest a price between 35 and 45 JD.';

        // Negotiation logic if we have product context
        if (widget.productPrice != null) {
          // Extract digits
          final RegExp regExp = RegExp(r'\d+');
          final Match? match = regExp.firstMatch(userText);
          if (match != null) {
            final double? offeredPrice = double.tryParse(match.group(0)!);
            if (offeredPrice != null) {
              final double minAcceptablePrice = widget.productPrice! * 0.8; // 20% max discount
              if (offeredPrice >= minAcceptablePrice && offeredPrice < widget.productPrice!) {
                response = widget.isArabic
                    ? 'هذا عرض ممتاز ومناسب جداً! 🤝 وافقت على بيع المنتج لك بسعر ${offeredPrice.toStringAsFixed(0)} دينار بدلاً من ${widget.productPrice?.toStringAsFixed(0)} دينار. تمت إضافة المنتج بسعره الجديد إلى سلتك بنجاح! 🎉'
                    : 'That is a great offer! 🤝 I agree to sell it to you for ${offeredPrice.toStringAsFixed(0)} JD instead of ${widget.productPrice?.toStringAsFixed(0)} JD. The product has been successfully added to your cart with the new price! 🎉';
              } else if (offeredPrice >= widget.productPrice!) {
                response = widget.isArabic
                    ? 'السعر المعروض مساوٍ أو أكبر من السعر الحالي! يمكنك شراء المنتج مباشرة أو تقديم عرض للحصول على خصم. 😊'
                    : 'The offered price is equal to or greater than the current price! You can purchase it directly or make an offer for a discount. 😊';
              } else {
                final suggestedPrice = (widget.productPrice! * 0.85).toStringAsFixed(0);
                response = widget.isArabic
                    ? 'هذا السعر منخفض جداً بالنسبة لعمل يدوي متميز يتطلب الكثير من الجهد والوقت! 😔 هل يمكنك تقديم عرض أفضل؟ ما رأيك بـ $suggestedPrice دينار؟'
                    : 'This price is too low for a premium handmade piece that requires time and effort! 😔 Can you offer a better price? How about $suggestedPrice JD?';
              }
            }
          } else {
            response = widget.isArabic
                ? 'لم أستطع تحديد السعر الذي تقترحه. يرجى كتابة الرقم مباشرة (مثال: "هل يمكنني الحصول عليه بـ 38 دينار؟")'
                : 'I couldn\'t detect the price you offered. Please type the number directly (e.g., "Can I have it for 38 JD?")';
          }
        } else if (userText.contains('هدية') || userText.contains('gift')) {
          response = widget.isArabic
              ? 'بناءً على تصفحك، أنصحك بقطعة فخار يدوية من "محمد العمري" أو صندوق خشبي محفور من "أحمد الحداد". هل تريدني أن أرسل لك الروابط؟'
              : 'Based on your browsing, I recommend a handmade pottery piece from "Mohammad" or a carved wooden box from "Ahmad". Shall I send you the links?';
        }

        _messages.add({'isUser': false, 'text': response});
      });
    });
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
          leading: IconButton(
            icon: Icon(
              widget.isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
              color: text,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Crafty AI',
                style: GoogleFonts.playfairDisplay(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['isUser'];
                  return _buildMessageBubble(msg['text'], isUser);
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      t('Crafty يكتب...', 'Crafty is typing...'),
                      style: GoogleFonts.cairo(color: dim, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: text),
                      decoration: InputDecoration(
                        hintText: t('اكتب رسالتك...', 'Type a message...'),
                        hintStyle: TextStyle(color: dim),
                        filled: true,
                        fillColor: bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String textStr, bool isUser) {
    return Align(
      alignment: isUser
          ? (widget.isArabic ? Alignment.centerLeft : Alignment.centerRight)
          : (widget.isArabic ? Alignment.centerRight : Alignment.centerLeft),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? accent : surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: (isUser && !widget.isArabic) || (!isUser && widget.isArabic) ? const Radius.circular(0) : const Radius.circular(16),
            bottomRight: (isUser && widget.isArabic) || (!isUser && !widget.isArabic) ? const Radius.circular(0) : const Radius.circular(16),
          ),
          border: isUser ? null : Border.all(color: const Color(0xFF6A1B9A).withValues(alpha: 0.3)),
        ),
        child: Text(
          textStr,
          style: GoogleFonts.cairo(
            color: isUser ? Colors.black : text,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
