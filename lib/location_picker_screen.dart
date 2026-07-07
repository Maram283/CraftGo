import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LocationPickerScreen — اختيار الموقع
// ─────────────────────────────────────────────────────────────────────────────

class LocationPickerScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const LocationPickerScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();

  // Selected details
  String _selectedAddressText = "";
  bool _isLocating = false;

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

  @override
  void initState() {
    super.initState();
    _cityController.text = t('نابلس', 'Nablus');
    _areaController.text = t('الجبيهة', 'Al-Jubaiha');
    _streetController.text = t('شارع الجامعة', 'University Street');
    _buildingController.text = '14';
    _updateAddressText();
  }

  void _updateAddressText() {
    setState(() {
      _selectedAddressText = "${_cityController.text}, ${_areaController.text}, ${_streetController.text}, ${t('بناية', 'Building')} ${_buildingController.text}";
    });
  }

  void _simulateGPSLocate() {
    setState(() {
      _isLocating = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLocating = false;
          _cityController.text = t('نابلس', 'Nablus');
          _areaController.text = t('خلدا', 'Khalda');
          _streetController.text = t('شارع وصفي التل', 'Wasfi Al-Tal Street');
          _buildingController.text = '88';
          _updateAddressText();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF4CAF50),
            content: Text(
              t('تم تحديد موقعك الحالي بنجاح!', 'Current location resolved successfully!'),
              style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
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
            icon: Icon(widget.isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('تحديد موقع التوصيل', 'Select Delivery Location'),
            style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // Styled premium Map background simulation
            Positioned.fill(
              child: _buildMapSimulation(),
            ),

            // Floating Search bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildSearchBar(),
            ),

            // Draggable/Floating Pin
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated pulse
                        if (_isLocating)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: 2.2),
                            duration: const Duration(seconds: 1),
                            builder: (context, val, child) {
                              return Container(
                                width: 20 * val,
                                height: 20 * val,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accent.withValues(alpha: 0.4 / val),
                                ),
                              );
                            },
                          ),
                        Icon(
                          Icons.location_on,
                          size: 44,
                          color: _isLocating ? accent : Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isLocating ? t('جاري التحديد...', 'Resolving...') : t('موقعك المختار', 'Selected Pin'),
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 60), // offset pin tip to align center
                ],
              ),
            ),

            // GPS locating overlay
            if (_isLocating)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(accent)),
                        const SizedBox(height: 16),
                        Text(
                          t('جاري تحديد الموقع الجغرافي...', 'Retrieving GPS Coordinates...'),
                          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Locate me FAB
            Positioned(
              bottom: 300,
              right: widget.isArabic ? null : 16,
              left: widget.isArabic ? 16 : null,
              child: FloatingActionButton(
                backgroundColor: surface,
                foregroundColor: accent,
                elevation: 4,
                onPressed: _simulateGPSLocate,
                child: const Icon(Icons.my_location),
              ),
            ),

            // Details input bottom sheet container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildDetailsPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: text),
        decoration: InputDecoration(
          hintText: t('ابحث عن موقع...', 'Search for location...'),
          hintStyle: TextStyle(color: dim),
          prefixIcon: Icon(Icons.search, color: accent),
          suffixIcon: IconButton(
            icon: const Icon(Icons.mic_none),
            onPressed: () {},
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onSubmitted: (val) {
          if (val.isNotEmpty) {
            _simulateGPSLocate();
          }
        },
      ),
    );
  }

  Widget _buildMapSimulation() {
    return Container(
      color: widget.isDarkMode ? const Color(0xFF131A26) : const Color(0xFFE8ECEF),
      child: CustomPaint(
        painter: _MapPainter(
          isDarkMode: widget.isDarkMode,
          accentColor: accent,
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedAddressText,
                  style: GoogleFonts.cairo(
                    color: text,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMiniTextField(
                  label: t('المدينة', 'City'),
                  controller: _cityController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniTextField(
                  label: t('المنطقة', 'Area'),
                  controller: _areaController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildMiniTextField(
                  label: t('الشارع', 'Street'),
                  controller: _streetController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildMiniTextField(
                  label: t('البناية', 'Bld No.'),
                  controller: _buildingController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _updateAddressText();
                Navigator.pop(context, _selectedAddressText);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                t('تأكيد وحفظ الموقع', 'Confirm & Save Location'),
                style: GoogleFonts.cairo(
                  color: widget.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(color: dim, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.cairo(color: text, fontSize: 13),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (_) => _updateAddressText(),
          ),
        ),
      ],
    );
  }
}

// Custom Painter to simulate map road details dynamically
class _MapPainter extends CustomPainter {
  final bool isDarkMode;
  final Color accentColor;

  // ignore: library_private_types_in_public_api
  _MapPainter({required this.isDarkMode, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    // Draw grid
    double gridSpacing = 40.0;
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double j = 0; j < size.height; j += gridSpacing) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), linePaint);
    }

    // Draw stylized main roads
    final Paint roadPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0;

    final Paint roadBorderPaint = Paint()
      ..color = isDarkMode
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16.0;

    void drawRoad(Path path) {
      canvas.drawPath(path, roadBorderPaint);
      canvas.drawPath(path, roadPaint);
    }

    // Diagonal road 1
    Path path1 = Path()
      ..moveTo(-50, 100)
      ..lineTo(size.width + 50, size.height - 200);
    drawRoad(path1);

    // Cross road 2
    Path path2 = Path()
      ..moveTo(size.width * 0.3, -50)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.4, size.width * 0.8, size.height + 50);
    drawRoad(path2);

    // Minor roads
    final Paint minorRoadPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    Path path3 = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.6);
    canvas.drawPath(path3, minorRoadPaint);

    // Accent location highlights (fake buildings)
    final Paint fillPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.3, 50, 40),
        const Radius.circular(8),
      ),
      fillPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.25, 45, 60),
        const Radius.circular(8),
      ),
      fillPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.5, size.height * 0.55, 70, 35),
        const Radius.circular(8),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
