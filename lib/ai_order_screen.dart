import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';

class AIOrderScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AIOrderScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AIOrderScreen> createState() => _AIOrderScreenState();
}

class _AIOrderScreenState extends State<AIOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Text input ──────────────────────────────────────────────────────────
  final TextEditingController _textController = TextEditingController();

  // ── Photo input ─────────────────────────────────────────────────────────
  XFile? _selectedImage;

  // ── Sketch input ────────────────────────────────────────────────────────
  List<Offset> _points = [];
  Color _selectedColor = const Color(0xFFD4A017);
  double _strokeWidth = 4.0;
  bool _isDrawing = false;
  final List<List<Offset>> _strokes = [];
  final List<Color> _strokeColors = [];
  final List<double> _strokeWidths = [];

  // Undo/Redo stacks
  final List<List<List<Offset>>> _undoStrokesStack = [];
  final List<List<Color>> _undoColorsStack = [];
  final List<List<double>> _undoWidthsStack = [];
  final List<List<List<Offset>>> _redoStrokesStack = [];
  final List<List<Color>> _redoColorsStack = [];
  final List<List<double>> _redoWidthsStack = [];

  bool _isEraser = false;

  // ── Color palette ──────────────────────────────────────────────────────
  final List<Color> _colors = [
    Colors.black,
    Colors.grey,
    Colors.brown,
    const Color(0xFFD4A017), // Gold
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

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

  // Canvas background - always light for better visibility
  Color get canvasBackground => const Color(0xFFF8F6F1); // Warm cream/paper color

  String t(String ar, String en) => widget.isArabic ? ar : en;

  // ── Save state for undo ──────────────────────────────────────────────
  void _saveStateForUndo() {
    _undoStrokesStack.add(_strokes.map((s) => List<Offset>.from(s)).toList());
    _undoColorsStack.add(List<Color>.from(_strokeColors));
    _undoWidthsStack.add(List<double>.from(_strokeWidths));
    // Clear redo stack when new action is performed
    _redoStrokesStack.clear();
    _redoColorsStack.clear();
    _redoWidthsStack.clear();
  }

  // ── Text input ──────────────────────────────────────────────────────────
  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('اكتب وصفاً لما تحتاجه', 'Describe what you need'),
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorderColor),
            ),
            child: TextField(
              controller: _textController,
              maxLines: null,
              expands: true,
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                hintText: t(
                  'مثال: أحتاج إلى سجادة صوفية صغيرة بنقش تقليدي أحمر...',
                  'Example: I need a small wool rug with red traditional patterns...',
                ),
                hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Photo input ──────────────────────────────────────────────────────────
  Widget _buildPhotoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('ارفع صورة مرجعية', 'Upload a reference image'),
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _pickImage(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorderColor, style: BorderStyle.solid),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 48,
                    color: secondaryTextColor.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t('اضغط لاختيار صورة', 'Tap to select an image'),
                    style: TextStyle(
                      color: secondaryTextColor.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedImage != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => setState(() => _selectedImage = null),
                icon: Icon(Icons.close, color: Colors.redAccent, size: 16),
                label: Text(
                  t('إزالة', 'Remove'),
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  // ── Color Picker Dialog ──────────────────────────────────────────────
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          t('اختر لوناً', 'Pick a color'),
          style: TextStyle(color: primaryTextColor),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
                _isEraser = false;
              });
            },
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            portraitOnly: true,
          ),
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

  // ── Sketch input ────────────────────────────────────────────────────────
  Widget _buildSketchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Canvas
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: canvasBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorderColor),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                if (_isEraser) {
                  return;
                }
                setState(() {
                  _isDrawing = true;
                  _points = [];
                  _points.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                if (_isEraser) {
                  _eraseNear(details.localPosition);
                  return;
                }
                if (_isDrawing) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                }
              },
              onPanEnd: (details) {
                if (_isEraser) return;
                if (_isDrawing && _points.length > 1) {
                  setState(() {
                    _saveStateForUndo();
                    _strokes.add(List.from(_points));
                    _strokeColors.add(_selectedColor);
                    _strokeWidths.add(_strokeWidth);
                    _points = [];
                    _isDrawing = false;
                  });
                }
              },
              child: CustomPaint(
                painter: _SketchPainter(
                  strokes: _strokes,
                  strokeColors: _strokeColors,
                  strokeWidths: _strokeWidths,
                  currentPoints: _points,
                  currentColor: _isEraser ? Colors.transparent : _selectedColor,
                  currentWidth: _isEraser ? _strokeWidth * 3 : _strokeWidth,
                  isEraser: _isEraser,
                  canvasColor: canvasBackground,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── TOOLS BELOW CANVAS ──────────────────────────────────────────
        // Color palette + Color Wheel button
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  separatorBuilder: (context, _) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color == _selectedColor && !_isEraser;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                          _isEraser = false;
                        });
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: isSelected ? accent : Colors.transparent,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: accent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Color Wheel button
              GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const SweepGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.blue,
                        Colors.indigo,
                        Colors.purple,
                        Colors.red,
                      ],
                    ),
                    border: Border.all(
                      color: _selectedColor == const Color(0xFFD4A017) && !_isEraser
                          ? accent
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.colorize,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Row: Eraser, Brush Size, Undo, Redo, Clear
        Row(
          children: [
            // Eraser toggle
            _buildToolButton(
              icon: _isEraser ? Icons.brush : Icons.cleaning_services,
              label: _isEraser ? t('رسم', 'Draw') : t('ممحاة', 'Eraser'),
              isActive: _isEraser,
              onTap: () => setState(() => _isEraser = !_isEraser),
            ),
            const SizedBox(width: 8),

            // Brush size
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.line_weight, color: primaryTextColor, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Slider(
                      value: _strokeWidth,
                      min: 1,
                      max: 12,
                      activeColor: accent,
                      inactiveColor: cardBorderColor,
                      onChanged: (v) => setState(() => _strokeWidth = v),
                    ),
                  ),
                  Container(
                    width: 24,
                    alignment: Alignment.center,
                    child: Text(
                      _strokeWidth.round().toString(),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),

            // Undo
            _buildIconButton(
              icon: Icons.undo,
              onTap: _undoLastStroke,
            ),
            // Redo
            _buildIconButton(
              icon: Icons.redo,
              onTap: _redoLastStroke,
            ),
            // Clear
            _buildIconButton(
              icon: Icons.delete_sweep,
              onTap: _clearCanvas,
              color: Colors.redAccent,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Analyze button
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFF7B500), Color(0xFFD89A00)],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: _hasSketchInput() ? _submitRequest : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: _hasSketchInput() ? Colors.black : Colors.black38,
                ),
                const SizedBox(width: 10),
                Text(
                  _hasSketchInput()
                      ? t('تحليل الرسم بالذكاء الاصطناعي', 'Analyze Drawing with AI')
                      : t('ارسم شيئاً للتحليل', 'Draw something to analyze'),
                  style: TextStyle(
                    color: _hasSketchInput() ? Colors.black : Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _hasSketchInput() => _strokes.isNotEmpty;

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? accent : cardBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.black : primaryTextColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : primaryTextColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return IconButton(
      icon: Icon(icon, color: color ?? primaryTextColor, size: 20),
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  void _eraseNear(Offset point) {
    for (int i = _strokes.length - 1; i >= 0; i--) {
      final stroke = _strokes[i];
      for (final p in stroke) {
        if ((p - point).distance < 20) {
          setState(() {
            _saveStateForUndo();
            _strokes.removeAt(i);
            _strokeColors.removeAt(i);
            _strokeWidths.removeAt(i);
          });
          return;
        }
      }
    }
  }

  void _undoLastStroke() {
    if (_undoStrokesStack.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('لا يوجد إجراء للتراجع', 'Nothing to undo')),
          backgroundColor: accent,
        ),
      );
      return;
    }

    setState(() {
      // Save current state to redo stack (deep copy)
      _redoStrokesStack.add(_strokes.map((s) => List<Offset>.from(s)).toList());
      _redoColorsStack.add(List<Color>.from(_strokeColors));
      _redoWidthsStack.add(List<double>.from(_strokeWidths));

      // Restore from undo stack
      _strokes.clear();
      _strokes.addAll(_undoStrokesStack.last.map((s) => List<Offset>.from(s)));
      _strokeColors.clear();
      _strokeColors.addAll(_undoColorsStack.last);
      _strokeWidths.clear();
      _strokeWidths.addAll(_undoWidthsStack.last);

      _undoStrokesStack.removeLast();
      _undoColorsStack.removeLast();
      _undoWidthsStack.removeLast();
    });
  }

  void _redoLastStroke() {
    if (_redoStrokesStack.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('لا يوجد إجراء للإعادة', 'Nothing to redo')),
          backgroundColor: accent,
        ),
      );
      return;
    }

    setState(() {
      // Save current state to undo stack (deep copy)
      _undoStrokesStack.add(_strokes.map((s) => List<Offset>.from(s)).toList());
      _undoColorsStack.add(List<Color>.from(_strokeColors));
      _undoWidthsStack.add(List<double>.from(_strokeWidths));

      // Restore from redo stack
      _strokes.clear();
      _strokes.addAll(_redoStrokesStack.last.map((s) => List<Offset>.from(s)));
      _strokeColors.clear();
      _strokeColors.addAll(_redoColorsStack.last);
      _strokeWidths.clear();
      _strokeWidths.addAll(_redoWidthsStack.last);

      _redoStrokesStack.removeLast();
      _redoColorsStack.removeLast();
      _redoWidthsStack.removeLast();
    });
  }

  void _clearCanvas() {
    if (_strokes.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          t('مسح الرسمة؟', 'Clear drawing?'),
          style: TextStyle(color: primaryTextColor),
        ),
        content: Text(
          t('هل أنت متأكد من رغبتك في مسح الرسمة؟', 'Are you sure you want to clear the drawing?'),
          style: TextStyle(color: secondaryTextColor),
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
              setState(() {
                _saveStateForUndo();
                _strokes.clear();
                _strokeColors.clear();
                _strokeWidths.clear();
                _points.clear();
              });
            },
            child: Text(
              t('مسح', 'Clear'),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ── Submit ──────────────────────────────────────────────────────────────
  void _submitRequest() {
    bool hasText = _textController.text.trim().isNotEmpty;
    bool hasPhoto = _selectedImage != null;
    bool hasSketch = _strokes.isNotEmpty;

    if (!hasText && !hasPhoto && !hasSketch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t('يرجى إدخال وصف، أو رفع صورة، أو رسم فكرتك', 'Please enter a description, upload a photo, or draw your idea'),
          ),
          backgroundColor: accent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD4A017),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      _showResults();
    });
  }

  void _showResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: cardBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: secondaryTextColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t('نتائج البحث الذكي', 'AI Search Results'),
                style: GoogleFonts.arefRuqaa(
                  color: primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t('تم العثور على المنتجات والحرفيين المطابقين', 'Found matching products and artisans'),
                style: TextStyle(color: secondaryTextColor, fontSize: 13),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      t('منتجات مشابهة', 'Similar Products'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ResultProductCard(
                      nameAr: 'سجادة صوفية مطرزة',
                      nameEn: 'Embroidered Wool Rug',
                      price: '52 JOD',
                      rating: '4.9',
                      isArabic: widget.isArabic,
                      isDarkMode: widget.isDarkMode,
                    ),
                    _ResultProductCard(
                      nameAr: 'مفرش طاولة تقليدي',
                      nameEn: 'Traditional Table Runner',
                      price: '35 JOD',
                      rating: '4.7',
                      isArabic: widget.isArabic,
                      isDarkMode: widget.isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      t('حرفيون موصى بهم', 'Recommended Artisans'),
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ResultArtisanCard(
                      nameAr: 'فاطمة محمود',
                      nameEn: 'Fatima Mahmoud',
                      craftAr: 'تطريز ومنسوجات',
                      craftEn: 'Embroidery & Textiles',
                      rating: '4.8',
                      isArabic: widget.isArabic,
                      isDarkMode: widget.isDarkMode,
                    ),
                    _ResultArtisanCard(
                      nameAr: 'أمجد الخطيب',
                      nameEn: 'Amjad Al-Khateeb',
                      craftAr: 'أعمال الخشب والأثاث',
                      craftEn: 'Woodworking',
                      rating: '4.9',
                      isArabic: widget.isArabic,
                      isDarkMode: widget.isDarkMode,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          t('طلب ذكي بالذكاء الاصطناعي', 'AI Smart Order'),
          style: GoogleFonts.arefRuqaa(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Tab selector
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorderColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: accent,
                unselectedLabelColor: secondaryTextColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: t('نص', 'Text')),
                  Tab(text: t('صورة', 'Photo')),
                  Tab(text: t('رسم', 'Draw')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTextInput(),
                  _buildPhotoInput(),
                  _buildSketchInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Painter ──────────────────────────────────────────────────────────
class _SketchPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Color> strokeColors;
  final List<double> strokeWidths;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;
  final bool isEraser;
  final Color canvasColor;

  const _SketchPainter({
    required this.strokes,
    required this.strokeColors,
    required this.strokeWidths,
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    this.isEraser = false,
    required this.canvasColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background with canvas color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = canvasColor,
    );

    // Draw completed strokes
    for (int i = 0; i < strokes.length; i++) {
      final points = strokes[i];
      final color = strokeColors[i];
      final width = strokeWidths[i];
      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int j = 0; j < points.length - 1; j++) {
        canvas.drawLine(points[j], points[j + 1], paint);
      }
    }

    // Draw current stroke
    if (currentPoints.length > 1) {
      final paint = Paint()
        ..color = isEraser ? canvasColor : currentColor
        ..strokeWidth = currentWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < currentPoints.length - 1; i++) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SketchPainter old) => true;
}

// ── Result Product Card ─────────────────────────────────────────────────────
class _ResultProductCard extends StatelessWidget {
  final String nameAr, nameEn, price, rating;
  final bool isArabic;
  final bool isDarkMode;

  const _ResultProductCard({
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.rating,
    required this.isArabic,
    required this.isDarkMode,
  });

  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get accent => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.checkroom_outlined, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? nameAr : nameEn,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          rating,
                          style: TextStyle(color: primaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: secondaryText),
        ],
      ),
    );
  }
}

// ── Result Artisan Card ─────────────────────────────────────────────────────
class _ResultArtisanCard extends StatelessWidget {
  final String nameAr, nameEn, craftAr, craftEn, rating;
  final bool isArabic;
  final bool isDarkMode;

  const _ResultArtisanCard({
    required this.nameAr,
    required this.nameEn,
    required this.craftAr,
    required this.craftEn,
    required this.rating,
    required this.isArabic,
    required this.isDarkMode,
  });

  Color get primaryText => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryText => isDarkMode ? Colors.white70 : Colors.black54;
  Color get border => isDarkMode ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08);
  Color get surface => isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get accent => const Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: accent.withValues(alpha: 0.2),
            child: Text(
              (isArabic ? nameAr : nameEn)[0],
              style: TextStyle(color: accent, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? nameAr : nameEn,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isArabic ? craftAr : craftEn,
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber),
              Text(
                rating,
                style: TextStyle(color: primaryText, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}