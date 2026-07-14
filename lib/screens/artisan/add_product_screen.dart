import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AddProductScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // ── Controllers ──────────────────────────────────────────────────────
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _colorsController = TextEditingController();

  // ── Image / AI state ─────────────────────────────────────────────────
  bool _isGeneratingBackground = false;
  bool _isPricing = false;
  bool _hasImage = false;
  bool _hasAiBackground = false;

  // ── Categories (multi‑select) ──────────────────────────────────────
  final List<String> _allCategories = [
    'خشب', 'فخار', 'خياطة', 'تطريز', 'مجوهرات',
    'زجاج', 'حجر', 'ورق', 'جلد', 'معادن'
  ];
  final Set<String> _selectedCategories = {};

  // ── Visibility ─────────────────────────────────────────────────────
  bool _isPublic = true;

  // ── Theme helpers ─────────────────────────────────────────────────
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

  // ── AI methods (unchanged) ──────────────────────────────────────────
  void _generateAiBackground() {
    setState(() => _isGeneratingBackground = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isGeneratingBackground = false;
        _hasAiBackground = true;
      });
    });
  }

  void _guessAiPrice() {
    setState(() => _isPricing = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isPricing = false;
        _priceController.text = "45";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isArabic
                ? 'تم اقتراح سعر 45 دينار بناءً على المواد والوقت (خوارزمية التسعير الذكية 🤖)'
                : 'A price of 45 JD was suggested based on materials and time (Smart AI Pricing 🤖)',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.purpleAccent,
        ),
      );
    });
  }

  // ── Category toggle ─────────────────────────────────────────────────
  void _toggleCategory(String cat) {
    setState(() {
      if (_selectedCategories.contains(cat)) {
        _selectedCategories.remove(cat);
      } else {
        _selectedCategories.add(cat);
      }
    });
  }

  // ── Save product (mock) ─────────────────────────────────────────────
  void _saveProduct() {
    // In real app, send to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t('✅ تم حفظ المنتج بنجاح', '✅ Product saved successfully')),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context, true);
  }

  // ── Build ────────────────────────────────────────────────────────────
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
          title: Text(
            t('إضافة منتج جديد', 'Add New Product'),
            style: GoogleFonts.cairo(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Upload & AI Studio ────────────────────────────
              Text(
                t('صورة المنتج', 'Product Image'),
                style: GoogleFonts.cairo(
                    color: text, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() => _hasImage = true);
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasAiBackground ? Colors.purpleAccent : border,
                      width: _hasAiBackground ? 2 : 1,
                    ),
                  ),
                  child: !_hasImage
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 50, color: dim),
                      const SizedBox(height: 8),
                      Text(
                        t('اضغط لرفع صورة', 'Tap to upload image'),
                        style:
                        GoogleFonts.cairo(color: dim, fontSize: 14),
                      ),
                    ],
                  )
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _hasAiBackground
                            ? Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.brown.shade800,
                                Colors.brown.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.checkroom,
                                size: 80, color: Colors.white70),
                          ),
                        )
                            : Container(
                          color: Colors.grey.withValues(alpha: 0.3),
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 80, color: Colors.white),
                          ),
                        ),
                      ),
                      if (_isGeneratingBackground)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                  color: Colors.purpleAccent),
                              const SizedBox(height: 12),
                              Text(
                                t('جاري إنشاء استوديو افتراضي...',
                                    'Generating virtual studio...'),
                                style: GoogleFonts.cairo(
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_hasImage && !_hasAiBackground && !_isGeneratingBackground) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _generateAiBackground,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    t('تحسين وتغيير الخلفية (AI Studio)',
                        'Enhance & Change Background (AI Studio)'),
                    style: GoogleFonts.cairo(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // ── Title ────────────────────────────────────────────────
              _buildTextField(_titleController, t('اسم المنتج', 'Product Name')),
              const SizedBox(height: 16),

              // ── Description ──────────────────────────────────────────
              _buildTextField(_descController, t('وصف المنتج', 'Description'),
                  maxLines: 4),
              const SizedBox(height: 16),

              // ── Materials ────────────────────────────────────────────
              _buildTextField(
                  _materialsController, t('المواد المستخدمة', 'Materials')),
              const SizedBox(height: 16),

              // ── Dimensions ───────────────────────────────────────────
              _buildTextField(
                  _dimensionsController,
                  t('الأبعاد (مثال: 30x40 سم)', 'Dimensions (e.g., 30x40 cm)')),
              const SizedBox(height: 16),

              // ── Colors ───────────────────────────────────────────────
              _buildTextField(
                  _colorsController,
                  t('الألوان المتوفرة (افصل بينها بفواصل)', 'Colors (comma separated)')),
              const SizedBox(height: 16),

              // ── Categories (multi‑select chips) ─────────────────────
              Text(
                t('التصنيفات', 'Categories'),
                style: GoogleFonts.cairo(
                    color: text, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allCategories.map((cat) {
                  final selected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.black : text,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) => _toggleCategory(cat),
                    backgroundColor: surface,
                    selectedColor: accent,
                    side: BorderSide(
                      color: selected ? accent : border,
                      width: selected ? 2 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Public / Private toggle ────────────────────────────
              Row(
                children: [
                  Text(
                    t('عام / خاص', 'Public / Private'),
                    style: TextStyle(color: text, fontSize: 16),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isPublic,
                    onChanged: (v) => setState(() => _isPublic = v),
                    activeColor: accent,
                  ),
                  Text(
                    _isPublic ? t('عام', 'Public') : t('خاص', 'Private'),
                    style: TextStyle(
                      color: _isPublic ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Price & AI ──────────────────────────────────────────
              Text(
                t('السعر (بالدينار)', 'Price (JD)'),
                style: GoogleFonts.cairo(
                    color: text, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_priceController, '',
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isPricing ? null : _guessAiPrice,
                    icon: _isPricing
                        ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.purpleAccent))
                        : const Icon(Icons.psychology,
                        color: Colors.purpleAccent),
                    label: Text(
                      t('تسعير AI', 'AI Pricing'),
                      style: GoogleFonts.cairo(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: surface,
                      side: const BorderSide(color: Colors.purpleAccent),
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Save Button ──────────────────────────────────────────
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  t('حفظ المنتج', 'Save Product'),
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

  // ── Helper: text field ──────────────────────────────────────────────
  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: text),
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        labelStyle: TextStyle(color: dim),
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}