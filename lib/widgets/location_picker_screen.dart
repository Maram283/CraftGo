// lib/features/hire_order/screens/location_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPickerScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final LatLng? initialLocation;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // ── Nablus, West Bank as default location ──────────────────────────────
  static const LatLng _defaultLocation = LatLng(32.2211, 35.2544);

  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? _defaultLocation;
    _selectedAddress = widget.initialAddress ?? '';
    if (_selectedAddress.isEmpty) {
      _getAddressFromCoords(_selectedLocation);
    }
  }

  // ── FIXED: Removed localeIdentifier ──────────────────────────────────
  Future<void> _getAddressFromCoords(LatLng position) async {
    setState(() => _isLoading = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((s) => s != null && s.isNotEmpty).toList();
        setState(() {
          _selectedAddress = parts.join(', ');
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = widget.isArabic
            ? '${_selectedLocation.latitude}, ${_selectedLocation.longitude}'
            : '${_selectedLocation.latitude}, ${_selectedLocation.longitude}';
      });
    }
    setState(() => _isLoading = false);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _getAddressFromCoords(position);
  }

  void _confirmLocation() {
    Navigator.pop(context, {
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'address': _selectedAddress,
    });
  }

  void _searchLocation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isArabic ? 'البحث عن موقع' : 'Search Location',
              style: GoogleFonts.cairo(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: widget.isArabic
                    ? 'ابحث عن مدينة، شارع، أو منطقة'
                    : 'Search for city, street, or area',
                hintStyle: GoogleFonts.cairo(
                  color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                ),
                prefixIcon: Icon(Icons.search, color: const Color(0xFFD4A017)),
                filled: true,
                fillColor: widget.isDarkMode
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.02),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.isDarkMode ? Colors.white12 : Colors.black12,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2),
                ),
              ),
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
              onSubmitted: (query) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.isArabic
                          ? 'قريباً: البحث عن المواقع باستخدام Google Places'
                          : 'Coming soon: Location search with Google Places',
                    ),
                    backgroundColor: const Color(0xFFD4A017),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: widget.isDarkMode ? Colors.white24 : Colors.black12,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.isArabic ? 'إلغاء' : 'Cancel',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.isArabic ? 'بحث' : 'Search',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8),
        appBar: AppBar(
          backgroundColor: widget.isDarkMode ? const Color(0xFF0D1420) : const Color(0xFFF5F6F8),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              widget.isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.isArabic ? 'اختر الموقع' : 'Pick Location',
            style: GoogleFonts.cairo(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFFD4A017)),
              onPressed: _searchLocation,
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Address bar ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: const Color(0xFFD4A017), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFD4A017),
                      ),
                    )
                        : Text(
                      _selectedAddress.isNotEmpty
                          ? _selectedAddress
                          : widget.isArabic
                          ? 'اضغط على الخريطة لتحديد الموقع'
                          : 'Tap on the map to select location',
                      style: GoogleFonts.cairo(
                        color: _selectedAddress.isNotEmpty
                            ? (widget.isDarkMode ? Colors.white : Colors.black87)
                            : (widget.isDarkMode ? Colors.white54 : Colors.black54),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedAddress.isNotEmpty)
                    GestureDetector(
                      onTap: _confirmLocation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.isArabic ? 'تأكيد' : 'Confirm',
                          style: GoogleFonts.cairo(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Map ──────────────────────────────────────────────────────
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 14,
                ),
                onTap: _onTap,
                markers: {
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: _selectedLocation,
                    infoWindow: InfoWindow(
                      title: widget.isArabic ? 'الموقع المحدد' : 'Selected Location',
                      snippet: _selectedAddress.isNotEmpty ? _selectedAddress : null,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                compassEnabled: true,
                tiltGesturesEnabled: false,
              ),
            ),
            // ── Bottom info ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: widget.isDarkMode ? Colors.white12 : Colors.black12,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: const Color(0xFFD4A017), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.isArabic
                          ? 'اسحب الخريطة أو اضغط لتحديد موقع دقيق'
                          : 'Drag or tap the map to select a precise location',
                      style: GoogleFonts.cairo(
                        color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
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
}