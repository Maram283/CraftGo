import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exhibition_detail_screen.dart';
import 'exhibition_capacity_screen.dart';

class MyExhibitionsScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  const MyExhibitionsScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<MyExhibitionsScreen> createState() => _MyExhibitionsScreenState();
}

class _MyExhibitionsScreenState extends State<MyExhibitionsScreen> {
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  bool _isGeneratingAI = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<Map<String, dynamic>> _mockExhibitions = [
    {
      'id': '1',
      'name': 'أسبوع الحرف اليدوية بعمّان',
      'nameEn': 'Amman Handmade Week',
      'status': 'Active',
      'type': 'Public',
      'location': 'عمّان',
      'locationEn': 'Amman',
      'startDate': '2026-07-01',
      'endDate': '2026-07-15',
      'interested': 150,
      'gradient': [const Color(0xFF1976D2), const Color(0xFF009688)],
    },
    {
      'id': '2',
      'name': 'سوق رمضان الحرفي',
      'nameEn': 'Ramadan Craft Market',
      'status': 'Past',
      'type': 'Public',
      'location': 'إربد',
      'locationEn': 'Irbid',
      'startDate': '2026-03-20',
      'endDate': '2026-03-30',
      'interested': 320,
      'gradient': [const Color(0xFFE64A19), const Color(0xFFD32F2F)],
    },
    {
      'id': '3',
      'name': 'معرض الفنون الشعبية',
      'nameEn': 'Folk Arts Fair',
      'status': 'Upcoming',
      'type': 'Private',
      'location': 'الزرقاء',
      'locationEn': 'Zarqa',
      'startDate': '2026-08-10',
      'endDate': '2026-08-20',
      'interested': 85,
      'gradient': [const Color(0xFF7B1FA2), const Color(0xFF3F51B5)],
    },
    {
      'id': '4',
      'name': 'يرموك للحرف التراثية',
      'nameEn': 'Yarmouk Heritage Crafts',
      'status': 'Upcoming',
      'type': 'Public',
      'location': 'إربد',
      'locationEn': 'Irbid',
      'startDate': '2026-09-01',
      'endDate': '2026-09-07',
      'interested': 40,
      'gradient': [const Color(0xFF388E3C), const Color(0xFF00796B)],
    },
    {
      'id': '5',
      'name': 'بازار الشتاء',
      'nameEn': 'Winter Bazaar',
      'status': 'Past',
      'type': 'Private',
      'location': 'عمّان',
      'locationEn': 'Amman',
      'startDate': '2025-12-15',
      'endDate': '2025-12-20',
      'interested': 210,
      'gradient': [const Color(0xFF455A64), const Color(0xFF1976D2)],
    },
    {
      'id': '6',
      'name': 'أسواق الأردن الحرفية',
      'nameEn': 'Jordan Craft Markets',
      'status': 'Active',
      'type': 'Public',
      'location': 'عمان',
      'locationEn': 'Amman',
      'startDate': '2026-07-05',
      'endDate': '2026-07-25',
      'interested': 450,
      'gradient': [const Color(0xFFFBC02D), const Color(0xFFF57C00)],
    },
  ];

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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          title: Text(
            t('معارضي', 'My Exhibitions'),
            style: GoogleFonts.cairo(
              color: text,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () => _showAddExhibitionBottomSheet(context),
                icon: const Icon(Icons.add, color: Colors.black),
                label: Text(
                  t('إضافة معرض', 'Add Exhibition'),
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: text),
                decoration: InputDecoration(
                  hintText: t('ابحث عن معرض...', 'Search exhibitions...'),
                  hintStyle: TextStyle(color: dim),
                  prefixIcon: Icon(Icons.search, color: dim),
                  filled: true,
                  fillColor: surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab(0, t('الكل', 'All')),
                  _buildTab(1, t('نشط', 'Active')),
                  _buildTab(2, t('قادم', 'Upcoming')),
                  _buildTab(3, t('منتهي', 'Past')),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredExhibitions.length,
                itemBuilder: (context, index) {
                  final ex = _filteredExhibitions[index];
                  return _buildExhibitionCard(ex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredExhibitions {
    return _mockExhibitions.where((ex) {
      final nameMatches = widget.isArabic
          ? ex['name'].toString().contains(_searchQuery)
          : ex['nameEn'].toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final statusMatches = _selectedTabIndex == 0 ||
          (_selectedTabIndex == 1 && ex['status'] == 'Active') ||
          (_selectedTabIndex == 2 && ex['status'] == 'Upcoming') ||
          (_selectedTabIndex == 3 && ex['status'] == 'Past');

      return nameMatches && statusMatches;
    }).toList();
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        margin: EdgeInsets.only(
            left: widget.isArabic ? 8 : 0, right: widget.isArabic ? 0 : 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accent : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? accent : border),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? Colors.black : text,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildExhibitionCard(Map<String, dynamic> ex) {
    final name = widget.isArabic ? ex['name'] : ex['nameEn'];
    final location = widget.isArabic ? ex['location'] : ex['locationEn'];
    final status = ex['status'];
    final type = ex['type'];
    final gradient = ex['gradient'] as List<Color>;

    Color statusColor = Colors.grey;
    String statusText = status;
    if (status == 'Active') {
      statusColor = Colors.green;
      statusText = t('نشط', 'Active');
    } else if (status == 'Upcoming') {
      statusColor = Colors.amber;
      statusText = t('قادم', 'Upcoming');
    } else if (status == 'Past') {
      statusText = t('منتهي', 'Past');
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExhibitionDetailScreen(
              isArabic: widget.isArabic,
              isDarkMode: widget.isDarkMode,
              exhibition: ex,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: type == 'Public'
                            ? Colors.blue.withValues(alpha: 0.9)
                            : Colors.orange.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type == 'Public'
                            ? t('عام', 'Public')
                            : t('خاص', 'Private'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.cairo(
                      color: text,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: dim),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: GoogleFonts.cairo(color: dim, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: dim),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${ex['startDate']}',
                          style: GoogleFonts.cairo(color: dim, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, size: 14, color: accent),
                          const SizedBox(width: 4),
                          Text(
                            '${ex['interested']}',
                            style: GoogleFonts.cairo(
                                color: text,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, size: 16, color: dim),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          // Capacity Management Button
                          IconButton(
                            icon: Icon(Icons.people_alt, size: 16, color: accent),
                            tooltip: widget.isArabic ? 'إدارة السعة والاحتياط' : 'Capacity & Standby',
                            onPressed: () {
                              final exName = widget.isArabic ? ex['name'] as String : ex['nameEn'] as String;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExhibitionCapacityScreen(
                                    isArabic: widget.isArabic,
                                    isDarkMode: widget.isDarkMode,
                                    exhibitionName: exName,
                                    maxCapacity: 10,
                                  ),
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon:
                                Icon(Icons.delete, size: 16, color: Colors.red),
                            onPressed: () => _confirmDelete(ex),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> ex) {
    final name = widget.isArabic ? ex['name'] : ex['nameEn'];
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          title: Text(t('تأكيد الحذف', 'Confirm Delete'),
              style: GoogleFonts.cairo(color: text)),
          content: Text(
            widget.isArabic
                ? 'هل أنت متأكد من حذف "$name"؟'
                : 'Are you sure you want to delete "$name"?',
            style: TextStyle(color: dim),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() => _mockExhibitions.remove(ex));
                Navigator.pop(ctx);
              },
              child: Text(t('حذف', 'Delete'),
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExhibitionBottomSheet(BuildContext context) {
    _titleController.clear();
    _descController.clear();
    _locationController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Directionality(
            textDirection:
                widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t('إضافة معرض جديد', 'Add New Exhibition'),
                      style: GoogleFonts.cairo(
                        color: text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Image Placeholder
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                size: 40, color: dim),
                            const SizedBox(height: 8),
                            Text(
                              t('إضافة صورة المعرض', 'Add Exhibition Image'),
                              style:
                                  GoogleFonts.cairo(color: dim, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(_titleController, t('العنوان', 'Title')),
                    const SizedBox(height: 16),
                    _buildTextField(
                        _locationController, t('الموقع', 'Location'),
                        icon: Icons.location_on),
                    const SizedBox(height: 16),
                    // AI Description Generator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            t('الوصف', 'Description'),
                            style: GoogleFonts.cairo(
                                color: text, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _isGeneratingAI
                              ? null
                              : () async {
                                  setModalState(
                                      () => _isGeneratingAI = true);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1500));
                                  final title = _titleController.text.isEmpty
                                      ? (widget.isArabic
                                          ? 'المعرض'
                                          : 'The exhibition')
                                      : _titleController.text;
                                  final loc = _locationController.text.isEmpty
                                      ? (widget.isArabic
                                          ? 'المدينة'
                                          : 'the city')
                                      : _locationController.text;
                                  setModalState(() {
                                    _descController.text = widget.isArabic
                                        ? 'يُقام $title في $loc، وهو معرض حرفي متخصص يجمع أمهر الحرفيين المحليين لعرض إبداعاتهم وأعمالهم الفنية الأصيلة. يهدف المعرض إلى تعزيز الثقافة الحرفية ودعم الحرفيين المحليين.'
                                        : 'Taking place in $loc, $title is a specialized craft exhibition bringing together the most skilled local artisans to showcase their authentic creative works and traditional crafts. The exhibition aims to promote craft culture and support local artisans.';
                                    _isGeneratingAI = false;
                                  });
                                },
                          icon: _isGeneratingAI
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
                          label: Text(
                            t('توليد AI', 'Generate AI'),
                            style: GoogleFonts.cairo(color: Colors.purpleAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(_descController, '', maxLines: 4),
                    const SizedBox(height: 24),
                    // Suggest Artisans
                    ElevatedButton.icon(
                      onPressed: () => _showArtisanSuggestions(context),
                      icon: const Icon(Icons.people, color: Colors.white),
                      label: Text(
                        t('اقتراح حرفيين مناسبين', 'Suggest Suitable Artisans'),
                        style: GoogleFonts.cairo(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: border),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(t('إلغاء', 'Cancel'),
                                style: GoogleFonts.cairo(color: text)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              t('حفظ المعرض', 'Save Exhibition'),
                              style: GoogleFonts.cairo(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, IconData? icon}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: text),
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        labelStyle: TextStyle(color: dim),
        prefixIcon: icon != null ? Icon(icon, color: dim) : null,
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showArtisanSuggestions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: surface,
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t('اقتراحات الذكاء الاصطناعي', 'AI Suggestions'),
                  style: GoogleFonts.cairo(color: text, fontSize: 16),
                ),
              ),
            ],
          ),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildArtisanChip(t('أحمد الحداد (نجارة)', 'Ahmad (Carpentry)'),
                  Colors.brown),
              _buildArtisanChip(t('سارة الزهراني (مجوهرات)', 'Sara (Jewelry)'),
                  Colors.purple),
              _buildArtisanChip(t('محمد العمري (فخار)', 'Mohammad (Pottery)'),
                  Colors.orange),
              _buildArtisanChip(t('ليلى السعيد (نسيج)', 'Layla (Textiles)'),
                  Colors.blue),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إغلاق', 'Close'),
                  style: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }
}
