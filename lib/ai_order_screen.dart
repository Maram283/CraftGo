import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'dart:math' as math;

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
  final List<List<Map<String, dynamic>>> _undoShapesStack = [];
  final List<List<Map<String, dynamic>>> _undoTextsStack = [];
  final List<List<Map<String, dynamic>>> _undoStampsStack = [];

  final List<List<List<Offset>>> _redoStrokesStack = [];
  final List<List<Color>> _redoColorsStack = [];
  final List<List<double>> _redoWidthsStack = [];
  final List<List<Map<String, dynamic>>> _redoShapesStack = [];
  final List<List<Map<String, dynamic>>> _redoTextsStack = [];
  final List<List<Map<String, dynamic>>> _redoStampsStack = [];

  bool _isEraser = false;
  String _selectedDrawingTool = 'brush'; // 'brush', 'rectangle', 'circle', 'line', 'text', 'stamp_star', 'stamp_heart', 'stamp_flower'
  bool _symmetryEnabled = false;
  bool _gridEnabled = false;
  final List<Map<String, dynamic>> _shapes = [];
  final List<Map<String, dynamic>> _texts = [];
  final List<Map<String, dynamic>> _stamps = [];
  Offset? _currentShapeStart;
  Offset? _currentShapeEnd;

  // ── 3D Viewer State ──────────────────────────────────────────────────────
  String _selected3DShape = 'cube'; // 'cube', 'sphere', 'cylinder', 'ring'
  String _selected3DMaterial = 'gold'; // 'gold', 'silver', 'clay', 'wood'
  double _rotationX = 0.4;
  double _rotationY = 0.6;
  final double _shapeScale = 1.0;
  Color _custom3DColor = const Color(0xFFD4A017);

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
    _tabController = TabController(length: 4, vsync: this);
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
    _undoShapesStack.add(_shapes.map((s) => Map<String, dynamic>.from(s)).toList());
    _undoTextsStack.add(_texts.map((t) => Map<String, dynamic>.from(t)).toList());
    _undoStampsStack.add(_stamps.map((s) => Map<String, dynamic>.from(s)).toList());

    // Clear redo stack when new action is performed
    _redoStrokesStack.clear();
    _redoColorsStack.clear();
    _redoWidthsStack.clear();
    _redoShapesStack.clear();
    _redoTextsStack.clear();
    _redoStampsStack.clear();
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
        // Canvas Toolbar: Select Tool, Toggle Grid, Symmetry
        Row(
          children: [
            // Tool selector button (dropdown or quick select)
            PopupMenuButton<String>(
              icon: Icon(Icons.category, color: accent),
              tooltip: t('أدوات الرسم', 'Drawing Tools'),
              onSelected: (tool) {
                setState(() {
                  _selectedDrawingTool = tool;
                  _isEraser = false;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'brush', child: Text(t('🖌️ فرشاة حرة', '🖌️ Free Brush'))),
                PopupMenuItem(value: 'rectangle', child: Text(t('⬜ مستطيل', '⬜ Rectangle'))),
                PopupMenuItem(value: 'circle', child: Text(t('⭕ دائرة', '⭕ Circle'))),
                PopupMenuItem(value: 'line', child: Text(t('📏 خط مستقيم', '📏 Straight Line'))),
                PopupMenuItem(value: 'text', child: Text(t('🔠 إضافة نص', '🔠 Add Text'))),
                PopupMenuItem(value: 'stamp_star', child: Text(t('⭐ ختم نجمة', '⭐ Stamp Star'))),
                PopupMenuItem(value: 'stamp_heart', child: Text(t('❤️ ختم قلب', '❤️ Stamp Heart'))),
                PopupMenuItem(value: 'stamp_flower', child: Text(t('🌸 ختم وردة', '🌸 Stamp Flower'))),
              ],
            ),
            Text(
              _selectedDrawingTool == 'brush' ? t('فرشاة حرة', 'Free Brush') :
              _selectedDrawingTool == 'rectangle' ? t('مستطيل', 'Rectangle') :
              _selectedDrawingTool == 'circle' ? t('دائرة', 'Circle') :
              _selectedDrawingTool == 'line' ? t('خط مستقيم', 'Straight Line') :
              _selectedDrawingTool == 'text' ? t('إضافة نص', 'Add Text') :
              _selectedDrawingTool.replaceFirst('stamp_', 'Stamp '),
              style: TextStyle(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Grid Toggle
            IconButton(
              icon: Icon(Icons.grid_on, color: _gridEnabled ? accent : secondaryTextColor),
              onPressed: () => setState(() => _gridEnabled = !_gridEnabled),
              tooltip: t('شبكة إرشادية', 'Guide Grid'),
            ),
            // Symmetry Toggle
            IconButton(
              icon: Icon(Icons.compare, color: _symmetryEnabled ? accent : secondaryTextColor),
              onPressed: () => setState(() => _symmetryEnabled = !_symmetryEnabled),
              tooltip: t('تناظر مرآة', 'Mirror Symmetry'),
            ),
          ],
        ),
        const SizedBox(height: 4),

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
              onTapDown: (details) {
                if (_selectedDrawingTool == 'text') {
                  _showTextInputDialog(details.localPosition);
                } else if (_selectedDrawingTool.startsWith('stamp_')) {
                  setState(() {
                    _saveStateForUndo();
                    _stamps.add({
                      'type': _selectedDrawingTool.replaceFirst('stamp_', ''),
                      'offset': details.localPosition,
                      'color': _selectedColor,
                      'size': _strokeWidth * 5,
                    });
                  });
                }
              },
              onPanStart: (details) {
                if (_isEraser) {
                  return;
                }
                if (_selectedDrawingTool == 'brush') {
                  setState(() {
                    _isDrawing = true;
                    _points = [details.localPosition];
                  });
                } else if (_selectedDrawingTool == 'rectangle' ||
                    _selectedDrawingTool == 'circle' ||
                    _selectedDrawingTool == 'line') {
                  setState(() {
                    _currentShapeStart = details.localPosition;
                    _currentShapeEnd = details.localPosition;
                  });
                }
              },
              onPanUpdate: (details) {
                if (_isEraser) {
                  _eraseNear(details.localPosition);
                  return;
                }
                if (_selectedDrawingTool == 'brush' && _isDrawing) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                } else if (_selectedDrawingTool == 'rectangle' ||
                    _selectedDrawingTool == 'circle' ||
                    _selectedDrawingTool == 'line') {
                  setState(() {
                    _currentShapeEnd = details.localPosition;
                  });
                }
              },
              onPanEnd: (details) {
                if (_isEraser) return;
                if (_selectedDrawingTool == 'brush' && _isDrawing && _points.length > 1) {
                  setState(() {
                    _saveStateForUndo();
                    _strokes.add(List.from(_points));
                    _strokeColors.add(_selectedColor);
                    _strokeWidths.add(_strokeWidth);
                    _points = [];
                    _isDrawing = false;
                  });
                } else if ((_selectedDrawingTool == 'rectangle' ||
                        _selectedDrawingTool == 'circle' ||
                        _selectedDrawingTool == 'line') &&
                    _currentShapeStart != null &&
                    _currentShapeEnd != null) {
                  setState(() {
                    _saveStateForUndo();
                    _shapes.add({
                      'type': _selectedDrawingTool,
                      'start': _currentShapeStart,
                      'end': _currentShapeEnd,
                      'color': _selectedColor,
                      'width': _strokeWidth,
                    });
                    _currentShapeStart = null;
                    _currentShapeEnd = null;
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
                  shapes: _shapes,
                  texts: _texts,
                  stamps: _stamps,
                  currentShapeStart: _currentShapeStart,
                  currentShapeEnd: _currentShapeEnd,
                  selectedDrawingTool: _selectedDrawingTool,
                  symmetryEnabled: _symmetryEnabled,
                  gridEnabled: _gridEnabled,
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

  bool _hasSketchInput() =>
      _strokes.isNotEmpty || _shapes.isNotEmpty || _texts.isNotEmpty || _stamps.isNotEmpty;

  void _showTextInputDialog(Offset offset) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(t('إضافة نص', 'Add Text'), style: TextStyle(color: primaryTextColor)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: t('اكتب شيئاً...', 'Type something...'),
            hintStyle: TextStyle(color: secondaryTextColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('إلغاء', 'Cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: accent),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _saveStateForUndo();
                  _texts.add({
                    'text': controller.text,
                    'offset': offset,
                    'color': _selectedColor,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: Text(t('إضافة', 'Add'), style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

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
      // Save current state to redo stack
      _redoStrokesStack.add(_strokes.map((s) => List<Offset>.from(s)).toList());
      _redoColorsStack.add(List<Color>.from(_strokeColors));
      _redoWidthsStack.add(List<double>.from(_strokeWidths));
      _redoShapesStack.add(_shapes.map((s) => Map<String, dynamic>.from(s)).toList());
      _redoTextsStack.add(_texts.map((t) => Map<String, dynamic>.from(t)).toList());
      _redoStampsStack.add(_stamps.map((s) => Map<String, dynamic>.from(s)).toList());

      // Restore from undo stack
      _strokes.clear();
      _strokes.addAll(_undoStrokesStack.last.map((s) => List<Offset>.from(s)));
      _strokeColors.clear();
      _strokeColors.addAll(_undoColorsStack.last);
      _strokeWidths.clear();
      _strokeWidths.addAll(_undoWidthsStack.last);
      _shapes.clear();
      _shapes.addAll(_undoShapesStack.last.map((s) => Map<String, dynamic>.from(s)));
      _texts.clear();
      _texts.addAll(_undoTextsStack.last.map((t) => Map<String, dynamic>.from(t)));
      _stamps.clear();
      _stamps.addAll(_undoStampsStack.last.map((s) => Map<String, dynamic>.from(s)));

      _undoStrokesStack.removeLast();
      _undoColorsStack.removeLast();
      _undoWidthsStack.removeLast();
      _undoShapesStack.removeLast();
      _undoTextsStack.removeLast();
      _undoStampsStack.removeLast();
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
      // Save current state to undo stack
      _undoStrokesStack.add(_strokes.map((s) => List<Offset>.from(s)).toList());
      _undoColorsStack.add(List<Color>.from(_strokeColors));
      _undoWidthsStack.add(List<double>.from(_strokeWidths));
      _undoShapesStack.add(_shapes.map((s) => Map<String, dynamic>.from(s)).toList());
      _undoTextsStack.add(_texts.map((t) => Map<String, dynamic>.from(t)).toList());
      _undoStampsStack.add(_stamps.map((s) => Map<String, dynamic>.from(s)).toList());

      // Restore from redo stack
      _strokes.clear();
      _strokes.addAll(_redoStrokesStack.last.map((s) => List<Offset>.from(s)));
      _strokeColors.clear();
      _strokeColors.addAll(_redoColorsStack.last);
      _strokeWidths.clear();
      _strokeWidths.addAll(_redoWidthsStack.last);
      _shapes.clear();
      _shapes.addAll(_redoShapesStack.last.map((s) => Map<String, dynamic>.from(s)));
      _texts.clear();
      _texts.addAll(_redoTextsStack.last.map((t) => Map<String, dynamic>.from(t)));
      _stamps.clear();
      _stamps.addAll(_redoStampsStack.last.map((s) => Map<String, dynamic>.from(s)));

      _redoStrokesStack.removeLast();
      _redoColorsStack.removeLast();
      _redoWidthsStack.removeLast();
      _redoShapesStack.removeLast();
      _redoTextsStack.removeLast();
      _redoStampsStack.removeLast();
    });
  }

  void _clearCanvas() {
    if (_strokes.isEmpty && _shapes.isEmpty && _texts.isEmpty && _stamps.isEmpty) return;
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
                _shapes.clear();
                _texts.clear();
                _stamps.clear();
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

  // ── 3D Input (Simulation) ──────────────────────────────────────────────────
  Widget _build3DInput() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Description
          Row(
            children: [
              Icon(Icons.view_in_ar, color: accent, size: 20),
              const SizedBox(width: 8),
              Text(
                t('معاينة وتعديل ثلاثي الأبعاد تفاعلي', 'Interactive 3D Preview'),
                style: TextStyle(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t('اسحب بإصبعك لتدوير المجسم ومعاينته من كافة الاتجاهات', 'Drag your finger to rotate the 3D model'),
            style: TextStyle(color: secondaryTextColor, fontSize: 11),
          ),
          const SizedBox(height: 12),

          // Interactive 3D Canvas — fixed large height
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF141F32) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotationY += details.delta.dx * 0.01;
                    _rotationX -= details.delta.dy * 0.01;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomPaint(
                    painter: _Model3DPainter(
                      shape: _selected3DShape,
                      material: _selected3DMaterial,
                      rotationX: _rotationX,
                      rotationY: _rotationY,
                      scale: _shapeScale,
                      customColor: _custom3DColor,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

        // Controls
        // Shape selector
        Text(
          t('اختر الشكل الهندسي:', 'Choose Geometry Shape:'),
          style: TextStyle(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _build3DShapeButton('cube', t('مكعب', 'Cube'), Icons.crop_square),
            _build3DShapeButton('sphere', t('كرة', 'Sphere'), Icons.lens_outlined),
            _build3DShapeButton('cylinder', t('أسطوانة', 'Cylinder'), Icons.crop_din_outlined),
            _build3DShapeButton('ring', t('خاتم', 'Ring'), Icons.trip_origin),
          ],
        ),
        const SizedBox(height: 16),

        // Color picker section
        Text(
          t('اختر اللون:', 'Choose Color:'),
          style: TextStyle(color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // ── Preset quick-select color dots ────────────────────────────────
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildColorDot(const Color(0xFFD4A017), 'gold'),
              _buildColorDot(const Color(0xFFB76E79), 'rosegold'),
              _buildColorDot(const Color(0xFFC0C0C0), 'silver'),
              _buildColorDot(const Color(0xFFCD7F32), 'bronze'),
              _buildColorDot(const Color(0xFFCD5C5C), 'clay'),
              _buildColorDot(const Color(0xFF8B4513), 'wood'),
              _buildColorDot(const Color(0xFF708090), 'default'),
              _buildColorDot(const Color(0xFF1565C0), 'blue'),
              _buildColorDot(const Color(0xFF2E7D32), 'green'),
              _buildColorDot(const Color(0xFF6A1B9A), 'purple'),
              _buildColorDot(const Color(0xFFD32F2F), 'red'),
              _buildColorDot(const Color(0xFF37474F), 'dark'),
              _buildColorDot(const Color(0xFFFFFFFF), 'white'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Inline HSV Color Picker ───────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? const Color(0xFF141F32) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Palette square (HSV)
              SizedBox(
                height: 150,
                child: ColorPickerArea(
                  HSVColor.fromColor(_custom3DColor),
                  (hsv) {
                    setState(() {
                      _custom3DColor = hsv.toColor();
                      _selected3DMaterial = 'custom';
                    });
                  },
                  PaletteType.hsv,
                ),
              ),
              const SizedBox(height: 10),
              // Hue slider
              SizedBox(
                height: 28,
                child: ColorPickerSlider(
                  TrackType.hue,
                  HSVColor.fromColor(_custom3DColor),
                  (hsv) {
                    setState(() {
                      _custom3DColor = hsv.toColor();
                      _selected3DMaterial = 'custom';
                    });
                  },
                  displayThumbColor: true,
                ),
              ),
              const SizedBox(height: 10),
              // Preview row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _custom3DColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: cardBorderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _custom3DColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '#${_custom3DColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',  
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selected3DMaterial = 'custom');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selected3DMaterial == 'custom' ? accent : accent.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t('تطبيق', 'Apply'),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
    );
  }

  Widget _buildColorDot(Color color, String id) {
    final isSelected = _selected3DMaterial == id ||
        (_selected3DMaterial == 'custom' && _custom3DColor == color);
    return GestureDetector(
      onTap: () {
        setState(() {
          _custom3DColor = color;
          _selected3DMaterial = 'custom';
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? accent : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: isSelected ? 8 : 4,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _build3DShapeButton(String shape, String label, IconData icon) {
    final isSelected = _selected3DShape == shape;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selected3DShape = shape),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? accent : (widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? accent : cardBorderColor),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.black : primaryTextColor, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : primaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // (material button and dialog replaced by inline color picker)

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
      _showResults(hasText: hasText);
    });
  }

  void _showResults({bool hasText = false}) {
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
              
              if (hasText) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('تصور ذكي (AI Generated)', 'AI Generated Concept'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t('قمنا بتوليد هذه الصورة بناءً على وصفك', 'We generated this image based on your description'),
                              style: TextStyle(fontSize: 12, color: secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://picsum.photos/80/80?random=1',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

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
                  Tab(text: t('أدوات 3D', '3D')),
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
                  _build3DInput(),
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

  final List<Map<String, dynamic>> shapes;
  final List<Map<String, dynamic>> texts;
  final List<Map<String, dynamic>> stamps;
  final Offset? currentShapeStart;
  final Offset? currentShapeEnd;
  final String selectedDrawingTool;
  final bool symmetryEnabled;
  final bool gridEnabled;

  const _SketchPainter({
    required this.strokes,
    required this.strokeColors,
    required this.strokeWidths,
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    this.isEraser = false,
    required this.canvasColor,
    required this.shapes,
    required this.texts,
    required this.stamps,
    this.currentShapeStart,
    this.currentShapeEnd,
    required this.selectedDrawingTool,
    required this.symmetryEnabled,
    required this.gridEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background with canvas color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = canvasColor,
    );

    // 1. Grid guide
    if (gridEnabled) {
      final gridPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.05)
        ..strokeWidth = 1.0;
      
      const double stepSize = 30.0;
      for (double x = 0; x < size.width; x += stepSize) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += stepSize) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Helper for mirroring points
    Offset mirrorPoint(Offset pt) {
      return Offset(size.width - pt.dx, pt.dy);
    }

    // 2. Completed strokes
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
        if (symmetryEnabled) {
          canvas.drawLine(mirrorPoint(points[j]), mirrorPoint(points[j + 1]), paint);
        }
      }
    }

    // 3. Current active stroke
    if (currentPoints.length > 1) {
      final paint = Paint()
        ..color = isEraser ? canvasColor : currentColor
        ..strokeWidth = currentWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < currentPoints.length - 1; i++) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
        if (symmetryEnabled && !isEraser) {
          canvas.drawLine(mirrorPoint(currentPoints[i]), mirrorPoint(currentPoints[i + 1]), paint);
        }
      }
    }

    // 4. Completed shapes
    for (final shape in shapes) {
      final type = shape['type'] as String;
      final start = shape['start'] as Offset;
      final end = shape['end'] as Offset;
      final color = shape['color'] as Color;
      final width = shape['width'] as double;

      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;

      void drawSingleShape(Offset st, Offset ed) {
        if (type == 'rectangle') {
          canvas.drawRect(Rect.fromPoints(st, ed), paint);
        } else if (type == 'circle') {
          canvas.drawOval(Rect.fromPoints(st, ed), paint);
        } else if (type == 'line') {
          canvas.drawLine(st, ed, paint);
        }
      }

      drawSingleShape(start, end);
      if (symmetryEnabled) {
        drawSingleShape(mirrorPoint(start), mirrorPoint(end));
      }
    }

    // 5. Active shape preview
    if (currentShapeStart != null && currentShapeEnd != null) {
      final paint = Paint()
        ..color = currentColor
        ..strokeWidth = currentWidth
        ..style = PaintingStyle.stroke;

      void drawSingleShape(Offset st, Offset ed) {
        if (selectedDrawingTool == 'rectangle') {
          canvas.drawRect(Rect.fromPoints(st, ed), paint);
        } else if (selectedDrawingTool == 'circle') {
          canvas.drawOval(Rect.fromPoints(st, ed), paint);
        } else if (selectedDrawingTool == 'line') {
          canvas.drawLine(st, ed, paint);
        }
      }

      drawSingleShape(currentShapeStart!, currentShapeEnd!);
      if (symmetryEnabled) {
        drawSingleShape(mirrorPoint(currentShapeStart!), mirrorPoint(currentShapeEnd!));
      }
    }

    // 6. Stamps
    for (final stamp in stamps) {
      final type = stamp['type'] as String;
      final offset = stamp['offset'] as Offset;
      final sizeVal = stamp['size'] as double;

      String stampChar = '⭐';
      if (type == 'heart') stampChar = '❤️';
      if (type == 'flower') stampChar = '🌸';

      void drawSingleStamp(Offset pt) {
        final tp = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: stampChar,
            style: TextStyle(fontSize: sizeVal),
          ),
        );
        tp.layout();
        tp.paint(canvas, Offset(pt.dx - sizeVal / 2, pt.dy - sizeVal / 2));
      }

      drawSingleStamp(offset);
      if (symmetryEnabled) {
        drawSingleStamp(mirrorPoint(offset));
      }
    }

    // 7. Texts
    for (final textObj in texts) {
      final text = textObj['text'] as String;
      final offset = textObj['offset'] as Offset;
      final color = textObj['color'] as Color;

      void drawSingleText(Offset pt) {
        final tp = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: text,
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
        tp.layout();
        tp.paint(canvas, pt);
      }

      drawSingleText(offset);
      if (symmetryEnabled) {
        drawSingleText(mirrorPoint(offset));
      }
    }

    // 8. Symmetry Center Line guide
    if (symmetryEnabled) {
      final symPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.3)
        ..strokeWidth = 1.0;
      
      // Draw vertical dashed symmetry line
      double dashHeight = 5.0;
      double dashSpace = 5.0;
      double startY = 0.0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashHeight),
          symPaint,
        );
        startY += dashHeight + dashSpace;
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

// ── Interactive 3D Vector-Projection Painter ──────────────────────────────────
class _Model3DPainter extends CustomPainter {
  final String shape;
  final String material;
  final double rotationX;
  final double rotationY;
  final double scale;
  final Color customColor;

  const _Model3DPainter({
    required this.shape,
    required this.material,
    required this.rotationX,
    required this.rotationY,
    required this.scale,
    this.customColor = const Color(0xFFD4A017),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY) * 0.8 * scale;

    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Color Setup based on Material (Dark to Light shade mapping)
    Color baseColorDark;
    Color baseColorLight;

    if (material == 'gold') {
      baseColorDark = const Color(0xFF7A5807);
      baseColorLight = const Color(0xFFFFE040);
    } else if (material == 'rosegold') {
      baseColorDark = const Color(0xFF75404B);
      baseColorLight = const Color(0xFFFFB2C1);
    } else if (material == 'silver') {
      baseColorDark = const Color(0xFF5F6E7D);
      baseColorLight = const Color(0xFFF0F4F8);
    } else if (material == 'clay') {
      baseColorDark = const Color(0xFF732E20);
      baseColorLight = const Color(0xFFFFA07A);
    } else if (material == 'wood') {
      baseColorDark = const Color(0xFF422108);
      baseColorLight = const Color(0xFFCD853F);
    } else if (material == 'bronze') {
      baseColorDark = const Color(0xFF523315);
      baseColorLight = const Color(0xFFF5B061);
    } else if (material == 'default') {
      baseColorDark = const Color(0xFF3A3A3A);
      baseColorLight = const Color(0xFFB0BEC5);
    } else if (material == 'custom') {
      // Derive dark/light from the custom picked color using HSL
      final hsl = HSLColor.fromColor(customColor);
      baseColorDark = hsl.withLightness((hsl.lightness * 0.4).clamp(0.0, 1.0)).toColor();
      baseColorLight = hsl.withLightness((hsl.lightness * 1.4).clamp(0.0, 1.0)).toColor();
    } else {
      // fallback
      baseColorDark = const Color(0xFF523315);
      baseColorLight = const Color(0xFFF5B061);
    }

    // Helper for 3D rotation and projection with depth returning
    Map<String, dynamic> projectWithDepth(double x, double y, double z) {
      // Y rotation
      double x1 = x * math.cos(rotationY) - z * math.sin(rotationY);
      double z1 = x * math.sin(rotationY) + z * math.cos(rotationY);
      // X rotation
      double y2 = y * math.cos(rotationX) - z1 * math.sin(rotationX);
      double z2 = y * math.sin(rotationX) + z1 * math.cos(rotationX);

      // Perspective projection
      double distance = 4.0;
      double fov = 350.0;
      double screenX = centerX + x1 * fov / (distance + z2);
      double screenY = centerY + y2 * fov / (distance + z2);
      return {
        'offset': Offset(screenX, screenY),
        'depth': z2,
      };
    }

    void drawDepthLine(Map<String, dynamic> ptA, Map<String, dynamic> ptB) {
      double avgDepth = (ptA['depth'] + ptB['depth']) / 2;
      // Normalize depth to [0.0, 1.0] for gradient shading
      double t = (avgDepth + 1.2) / 2.4;
      t = t.clamp(0.0, 1.0);
      
      // Interpolate color: closer points get light baseColorLight, further get baseColorDark
      paint.color = Color.lerp(baseColorLight, baseColorDark, t)!;
      canvas.drawLine(ptA['offset'], ptB['offset'], paint);
    }

    if (shape == 'cube') {
      // 8 Vertices of a Cube
      final List<List<double>> vertices = [
        [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
        [-1, -1, 1],  [1, -1, 1],  [1, 1, 1],  [-1, 1, 1]
      ];

      // Scale vertices
      final scaled = vertices.map((v) => [v[0] * radius * 0.007, v[1] * radius * 0.007, v[2] * radius * 0.007]).toList();
      final points = scaled.map((v) => projectWithDepth(v[0], v[1], v[2])).toList();

      // Edges index
      final List<List<int>> edges = [
        [0, 1], [1, 2], [2, 3], [3, 0], // Back face
        [4, 5], [5, 6], [6, 7], [7, 4], // Front face
        [0, 4], [1, 5], [2, 6], [3, 7]  // Connecting edges
      ];

      for (final edge in edges) {
        drawDepthLine(points[edge[0]], points[edge[1]]);
      }
    } else if (shape == 'sphere') {
      // Sphere represented by circles (longitude and latitude lines)
      const int latSegments = 8;
      const int lonSegments = 12;

      for (int i = 0; i <= latSegments; i++) {
        final double lat = (i * math.pi / latSegments) - math.pi / 2;
        final double r = radius * 0.007 * math.cos(lat);
        final double y = radius * 0.007 * math.sin(lat);

        List<Map<String, dynamic>> circlePoints = [];
        for (int j = 0; j <= lonSegments; j++) {
          final double lon = j * 2 * math.pi / lonSegments;
          final double x = r * math.cos(lon);
          final double z = r * math.sin(lon);
          circlePoints.add(projectWithDepth(x, y, z));
        }

        for (int j = 0; j < circlePoints.length - 1; j++) {
          drawDepthLine(circlePoints[j], circlePoints[j + 1]);
        }
      }

      for (int j = 0; j < lonSegments; j++) {
        final double lon = j * 2 * math.pi / lonSegments;
        List<Map<String, dynamic>> meridianPoints = [];
        for (int i = 0; i <= latSegments; i++) {
          final double lat = (i * math.pi / latSegments) - math.pi / 2;
          final double x = radius * 0.007 * math.cos(lat) * math.cos(lon);
          final double y = radius * 0.007 * math.sin(lat);
          final double z = radius * 0.007 * math.cos(lat) * math.sin(lon);
          meridianPoints.add(projectWithDepth(x, y, z));
        }
        for (int i = 0; i < meridianPoints.length - 1; i++) {
          drawDepthLine(meridianPoints[i], meridianPoints[i + 1]);
        }
      }
    } else if (shape == 'cylinder') {
      // Top and bottom circles connected
      const int segments = 16;
      final double halfHeight = radius * 0.007;
      final double r = radius * 0.006;

      List<Map<String, dynamic>> topPoints = [];
      List<Map<String, dynamic>> bottomPoints = [];

      for (int i = 0; i <= segments; i++) {
        final double angle = i * 2 * math.pi / segments;
        final double x = r * math.cos(angle);
        final double z = r * math.sin(angle);

        topPoints.add(projectWithDepth(x, -halfHeight, z));
        bottomPoints.add(projectWithDepth(x, halfHeight, z));
      }

      for (int i = 0; i < segments; i++) {
        drawDepthLine(topPoints[i], topPoints[i + 1]);
        drawDepthLine(bottomPoints[i], bottomPoints[i + 1]);
        if (i % 4 == 0) {
          drawDepthLine(topPoints[i], bottomPoints[i]);
        }
      }
    } else if (shape == 'ring') {
      // Torus
      const int ringSegments = 16;
      const int tubeSegments = 8;
      final double rTube = radius * 0.002;
      final double rRing = radius * 0.006;

      for (int i = 0; i < ringSegments; i++) {
        final double theta = i * 2 * math.pi / ringSegments;
        final double cosTheta = math.cos(theta);
        final double sinTheta = math.sin(theta);

        List<Map<String, dynamic>> tubePoints = [];
        for (int j = 0; j <= tubeSegments; j++) {
          final double phi = j * 2 * math.pi / tubeSegments;
          final double x = (rRing + rTube * math.cos(phi)) * cosTheta;
          final double y = rTube * math.sin(phi);
          final double z = (rRing + rTube * math.cos(phi)) * sinTheta;

          tubePoints.add(projectWithDepth(x, y, z));
        }

        for (int j = 0; j < tubePoints.length - 1; j++) {
          drawDepthLine(tubePoints[j], tubePoints[j + 1]);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Model3DPainter old) => true;
}
