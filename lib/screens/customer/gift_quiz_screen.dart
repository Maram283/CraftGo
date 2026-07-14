import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GiftQuizScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const GiftQuizScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<GiftQuizScreen> createState() => _GiftQuizScreenState();
}

class _GiftQuizScreenState extends State<GiftQuizScreen> {
  // ── Quiz state ──────────────────────────────────────────────────────
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step 1: Who is it for?
  String? _selectedRecipient;
  final List<String> _recipients = ['Mother', 'Father', 'Wife/Husband', 'Friend', 'Child', 'Colleague', 'Other'];
  final TextEditingController _customRecipientController = TextEditingController();

  // Step 2: Occasion
  String? _selectedOccasion;
  final List<String> _occasions = ['Birthday', 'Anniversary', 'Graduation', 'Wedding', 'Housewarming', 'No specific', 'Other'];
  final TextEditingController _customOccasionController = TextEditingController();

  // Step 3: Budget
  String? _selectedBudget;
  final List<String> _budgets = ['Under 20 JD', '20-50 JD', '50-100 JD', '100-200 JD', '200+ JD', 'Any'];
  final TextEditingController _customBudgetController = TextEditingController();

  // Step 4: Style preferences (multi-select)
  final List<String> _allStyles = ['Traditional', 'Modern/Contemporary', 'Minimalist', 'Colorful/Vibrant', 'Earthy/Natural', 'Luxurious/High-end'];
  final List<String> _selectedStyles = [];
  final TextEditingController _customStyleController = TextEditingController();

  // ── Results data ──────────────────────────────────────────────────
  final List<Map<String, dynamic>> _products = [
    {
      'nameAr': 'سجادة صوفية مطرزة',
      'nameEn': 'Embroidered Wool Rug',
      'price': 52,
      'image': Icons.checkroom_outlined,
      'reasonAr': 'تتناسب مع الذوق التقليدي وتضفي لمسة أنيقة',
      'reasonEn': 'Matches traditional taste and adds an elegant touch',
    },
    {
      'nameAr': 'خاتم فضة مصنوع يدوياً',
      'nameEn': 'Handmade Silver Ring',
      'price': 35,
      'image': Icons.watch_outlined,
      'reasonAr': 'خيار مثالي لمن يحب المجوهرات الأنيقة',
      'reasonEn': 'Perfect for someone who loves elegant jewelry',
    },
    {
      'nameAr': 'إبريق فخاري تقليدي',
      'nameEn': 'Traditional Clay Pitcher',
      'price': 28,
      'image': Icons.local_cafe_outlined,
      'reasonAr': 'يجمع بين الأصالة والفن، هدية فريدة',
      'reasonEn': 'Combines authenticity and art, a unique gift',
    },
    {
      'nameAr': 'صندوق خشبي محفور',
      'nameEn': 'Carved Wooden Box',
      'price': 60,
      'image': Icons.chair_outlined,
      'reasonAr': 'قطعة فنية تصلح لتخزين المجوهرات أو الهدايا',
      'reasonEn': 'Art piece perfect for storing jewelry or gifts',
    },
    {
      'nameAr': 'وشاح صوف منسوج يدوياً',
      'nameEn': 'Hand-Woven Wool Scarf',
      'price': 22,
      'image': Icons.checkroom_outlined,
      'reasonAr': 'هدية دافئة وأنيقة تناسب جميع الأعمار',
      'reasonEn': 'Warm and elegant gift suitable for all ages',
    },
  ];

  final List<Map<String, dynamic>> _artisans = [
    {
      'nameAr': 'أمجد الخطيب',
      'nameEn': 'Amjad Al-Khateeb',
      'craftAr': 'أعمال الخشب والأثاث',
      'craftEn': 'Woodworking',
      'rating': 4.9,
      'image': Icons.chair_outlined,
      'reasonAr': 'خبرة في صناعة القطع الخشبية الفريدة',
      'reasonEn': 'Expert in unique wooden pieces',
    },
    {
      'nameAr': 'فاطمة محمود',
      'nameEn': 'Fatima Mahmoud',
      'craftAr': 'خياطة وتطريز',
      'craftEn': 'Crochet & Knitting',
      'rating': 4.8,
      'image': Icons.checkroom_outlined,
      'reasonAr': 'تصاميم يدوية تناسب جميع الأذواق',
      'reasonEn': 'Handcrafted designs for all tastes',
    },
    {
      'nameAr': 'إياد الكردي',
      'nameEn': 'Iyad Al-Kurdi',
      'craftAr': 'الفخار والخزف',
      'craftEn': 'Pottery & Ceramics',
      'rating': 5.0,
      'image': Icons.local_cafe_outlined,
      'reasonAr': 'أعمال فخارية أصلية وأنيقة',
      'reasonEn': 'Authentic and elegant pottery',
    },
    {
      'nameAr': 'هنا سلامة',
      'nameEn': 'Hana Salama',
      'craftAr': 'حلي ومجوهرات',
      'craftEn': 'Jewelry & Accessories',
      'rating': 4.7,
      'image': Icons.watch_outlined,
      'reasonAr': 'مجوهرات مصممة خصيصاً لك',
      'reasonEn': 'Custom-designed jewelry',
    },
  ];

  // ── Theme helpers ──────────────────────────────────────────────────
  Color get bg => widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8);
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white60 : Colors.black54;
  Color get accent => const Color(0xFFD4A017);
  Color get border => widget.isDarkMode ? Colors.white12 : Colors.black12;

  String t(String ar, String en) => widget.isArabic ? ar : en;

  // ── Validation ──────────────────────────────────────────────────
  bool get canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedRecipient != null || _customRecipientController.text.trim().isNotEmpty;
      case 1:
        return _selectedOccasion != null || _customOccasionController.text.trim().isNotEmpty;
      case 2:
        return _selectedBudget != null || _customBudgetController.text.trim().isNotEmpty;
      case 3:
        return _selectedStyles.isNotEmpty || _customStyleController.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  // ── Navigation ──────────────────────────────────────────────────
  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _showResults();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  // ── Toggle style ──────────────────────────────────────────────────
  void _toggleStyle(String style) {
    setState(() {
      if (_selectedStyles.contains(style)) {
        _selectedStyles.remove(style);
      } else {
        _selectedStyles.add(style);
      }
    });
  }

  // ── Show results with both products and artisans ──────────────
  void _showResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('اقتراحات الهدايا والحرفيين', 'Gift & Artisan Recommendations'),
                  style: GoogleFonts.cairo(color: text, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: dim),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t('بناءً على اختياراتك، هذه أفضل الهدايا والحرفيين المناسبين:', 'Based on your choices, these are the best gifts and artisans:'),
              style: TextStyle(color: dim, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // ── Products section ──────────────────────────────
                  if (_products.isNotEmpty) ...[
                    _buildSectionHeader(t('منتجات', 'Products')),
                    const SizedBox(height: 8),
                    ..._products.map((item) => _buildResultCard(item, isProduct: true)),
                  ],
                  const SizedBox(height: 16),
                  // ── Artisans section ──────────────────────────────
                  if (_artisans.isNotEmpty) ...[
                    _buildSectionHeader(t('حرفيون', 'Artisans')),
                    const SizedBox(height: 8),
                    ..._artisans.map((item) => _buildResultCard(item, isProduct: false)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  t('تصفح الكل', 'Browse All'),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            color: text,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item, {required bool isProduct}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['image'] ?? Icons.star, size: 30, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isArabic ? item['nameAr'] : item['nameEn'],
                  style: TextStyle(color: text, fontWeight: FontWeight.bold),
                ),
                if (isProduct) ...[
                  Text(
                    '${item['price']} JOD',
                    style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.isArabic ? item['reasonAr'] : item['reasonEn'],
                    style: TextStyle(color: dim, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else ...[
                  Text(
                    widget.isArabic ? item['craftAr'] : item['craftEn'],
                    style: TextStyle(color: dim, fontSize: 12),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        item['rating'].toString(),
                        style: TextStyle(color: text, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    widget.isArabic ? item['reasonAr'] : item['reasonEn'],
                    style: TextStyle(color: dim, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isProduct ? Icons.shopping_bag_outlined : Icons.chat_bubble_outline,
              color: accent,
              size: 16,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isProduct
                        ? t('فتح تفاصيل المنتج', 'Opening product details')
                        : t('بدء محادثة مع الحرفي', 'Starting chat with artisan'),
                  ),
                ),
              );
            },
          ),
        ],
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
          leading: IconButton(
            icon: Icon(widget.isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('مساعد الهدايا', 'Gift Assistant'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A017)),
              minHeight: 4,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${t('الخطوة', 'Step')} ${_currentStep + 1}/$_totalSteps',
                style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Step content
              Expanded(
                child: _buildStepContent(),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(t('السابق', 'Back'), style: TextStyle(color: dim)),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: canProceed ? _nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canProceed ? accent : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? t('الحصول على الهدايا', 'Get Gifts')
                            : t('متابعة', 'Continue'),
                        style: TextStyle(color: canProceed ? Colors.black : Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep(
          title: t('لمن تبحث عن هدية؟', 'Who is the gift for?'),
          options: _recipients,
          selected: _selectedRecipient,
          onSelect: (v) => setState(() => _selectedRecipient = v),
          customController: _customRecipientController,
          customHint: t('أو اكتب إجابة أخرى', 'Or type another answer'),
          icon: Icons.person_outline,
        );
      case 1:
        return _buildStep(
          title: t('ما هي المناسبة؟', 'What is the occasion?'),
          options: _occasions,
          selected: _selectedOccasion,
          onSelect: (v) => setState(() => _selectedOccasion = v),
          customController: _customOccasionController,
          customHint: t('أو اكتب مناسبة أخرى', 'Or type another occasion'),
          icon: Icons.event_outlined,
        );
      case 2:
        return _buildStep(
          title: t('ما هي ميزانيتك التقريبية؟', 'What is your approximate budget?'),
          options: _budgets,
          selected: _selectedBudget,
          onSelect: (v) => setState(() => _selectedBudget = v),
          customController: _customBudgetController,
          customHint: t('أو اكتب قيمة أخرى', 'Or type another amount'),
          icon: Icons.attach_money,
        );
      case 3:
        return _buildMultiSelectStep(
          title: t('ما هي الأذواق التي تفضلها؟', 'What styles do you prefer?'),
          options: _allStyles,
          selected: _selectedStyles,
          onToggle: _toggleStyle,
          customController: _customStyleController,
          customHint: t('أو اكتب ذوقاً آخر', 'Or type another style'),
          icon: Icons.palette_outlined,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep({
    required String title,
    required List<String> options,
    required String? selected,
    required Function(String) onSelect,
    required TextEditingController customController,
    required String customHint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: accent, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              ...options.map((opt) {
                final isSelected = selected == opt;
                return GestureDetector(
                  onTap: () => onSelect(opt),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? accent.withValues(alpha: 0.15) : surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? accent : border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? accent : border),
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: accent, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t(opt, opt),
                            style: TextStyle(color: text, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              // Custom text field
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: customController,
                  style: TextStyle(color: text),
                  decoration: InputDecoration(
                    hintText: customHint,
                    hintStyle: TextStyle(color: dim),
                    prefixIcon: Icon(Icons.edit_outlined, color: dim),
                    filled: true,
                    fillColor: surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent, width: 2),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectStep({
    required String title,
    required List<String> options,
    required List<String> selected,
    required Function(String) onToggle,
    required TextEditingController customController,
    required String customHint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: accent, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          t('اختر كل ما يناسب (اختياري متعدد)', 'Select all that apply (multi-select)'),
          style: TextStyle(color: dim, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: options.map((opt) {
                  final isSelected = selected.contains(opt);
                  return GestureDetector(
                    onTap: () => onToggle(opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? accent : surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? accent : border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Icon(Icons.check, color: Colors.black, size: 16),
                          if (isSelected) const SizedBox(width: 6),
                          Text(
                            t(opt, opt),
                            style: TextStyle(
                              color: isSelected ? Colors.black : text,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Custom text field
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: TextField(
                  controller: customController,
                  style: TextStyle(color: text),
                  decoration: InputDecoration(
                    hintText: customHint,
                    hintStyle: TextStyle(color: dim),
                    prefixIcon: Icon(Icons.edit_outlined, color: dim),
                    filled: true,
                    fillColor: surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent, width: 2),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}