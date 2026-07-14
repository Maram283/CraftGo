import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'services/session_service.dart';
import 'services/upload_service.dart';
import 'services/products_service.dart';
import 'utils/app_feedback.dart';

class AddProductScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String selectedCategory;

  const AddProductScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    this.selectedCategory = 'عام',
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  bool _isGeneratingBackground = false;
  bool _isPricing = false;
  bool _isSaving = false;
  bool _hasAiBackground = false;

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
        _priceController.text = "45"; // JD
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
              // Image Upload & AI Studio
              Text(
                t('صورة المنتج', 'Product Image'),
                style: GoogleFonts.cairo(
                    color: text, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _selectedImage = File(picked.path));
                  }
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
                  child: _selectedImage == null
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
                                    ) // Mock AI background
                                  : Image.file(_selectedImage!, fit: BoxFit.cover),
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
              if (_selectedImage != null && !_hasAiBackground && !_isGeneratingBackground) ...[
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

              // Title
              _buildTextField(_titleController, t('اسم المنتج', 'Product Name')),
              const SizedBox(height: 16),

              // Description
              _buildTextField(_descController, t('وصف المنتج', 'Description'),
                  maxLines: 4),
              const SizedBox(height: 24),

              // Pricing & AI
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

              // Save Button
              ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
                    AppFeedback.showWarning(context, t('يرجى كتابة الاسم والسعر', 'Please enter title and price'));
                    return;
                  }
                  
                  setState(() => _isSaving = true);
                  AppFeedback.showLoading(context, message: t('جاري حفظ المنتج...', 'Saving Product...'));
                  
                  String? imageUrl;
                  if (_selectedImage != null) {
                    imageUrl = await UploadService.uploadImage(_selectedImage!);
                  }
                  
                  final userId = await SessionService.getUserId() ?? 'demo-craftsman-id';
                  
                  final success = await ProductsService.createProduct(
                    craftsmanId: userId,
                    titleAr: _titleController.text,
                    titleEn: _titleController.text,
                    description: _descController.text,
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    category: widget.selectedCategory,
                    imageUrl: imageUrl,
                  );
                  
                  if (context.mounted) {
                    AppFeedback.hideLoading(context);
                    if (success) {
                      Navigator.pop(context);
                      AppFeedback.showSuccess(context, t('تم حفظ المنتج بنجاح', 'Product saved successfully'));
                    } else {
                      setState(() => _isSaving = false);
                      AppFeedback.showError(context, t('فشل حفظ المنتج', 'Failed to save product'));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black))
                  : Text(
                  t('حفظ المنتج', 'Save Product'),
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
