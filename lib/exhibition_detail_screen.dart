import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExhibitionDetailScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final Map<String, dynamic> exhibition;

  const ExhibitionDetailScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.exhibition,
  });

  @override
  State<ExhibitionDetailScreen> createState() => _ExhibitionDetailScreenState();
}

class _ExhibitionDetailScreenState extends State<ExhibitionDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final List<Map<String, dynamic>> _mockRequests = [
    {
      'name': 'سمير الخطيب',
      'nameEn': 'Samir Al-Khatib',
      'craft': 'خزف',
      'craftEn': 'Ceramics',
      'time': 'منذ ساعتين',
      'timeEn': '2 hours ago',
      'color': const Color(0xFFE64A19)
    },
    {
      'name': 'ندى الأحمد',
      'nameEn': 'Nada Al-Ahmad',
      'craft': 'تطريز',
      'craftEn': 'Embroidery',
      'time': 'منذ 4 ساعات',
      'timeEn': '4 hours ago',
      'color': const Color(0xFF00796B)
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
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0.85).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name =
        widget.isArabic ? widget.exhibition['name'] : widget.exhibition['nameEn'];
    final gradient = widget.exhibition['gradient'] as List<Color>;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: surface,
              iconTheme: IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  name,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(blurRadius: 4, color: Colors.black54)
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: accent, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.isArabic
                                        ? widget.exhibition['location']
                                        : widget.exhibition['locationEn'],
                                    style: GoogleFonts.cairo(
                                        color: text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.exhibition['type'] == 'Public'
                                      ? Colors.blue.withValues(alpha: 0.2)
                                      : Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.exhibition['type'] == 'Public'
                                      ? t('عام', 'Public')
                                      : t('خاص', 'Private'),
                                  style: GoogleFonts.cairo(
                                      color: widget.exhibition['type'] == 'Public'
                                          ? Colors.blueAccent
                                          : Colors.orangeAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: dim, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.exhibition['startDate']} - ${widget.exhibition['endDate']}',
                                style: GoogleFonts.cairo(color: text),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t(
                                'يُقام المعرض في مساحة مفتوحة لتعزيز التفاعل بين الحرفيين والجمهور. يتميز بتنوع الحرف المعروضة.',
                                'The exhibition is held in an open space to enhance interaction between artisans and the public. Features a variety of crafts.'),
                            style: GoogleFonts.cairo(
                                color: dim, height: 1.5, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // AI Event Predictor
                    Text(
                      t('متنبئ المعارض بالذكاء الاصطناعي', 'AI Exhibition Predictor'),
                      style: GoogleFonts.cairo(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withValues(alpha: 0.1),
                            surface,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.insights, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t('توقعات الحضور والمبيعات', 'Attendance & Sales Forecast'),
                                  style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('+450', style: GoogleFonts.cairo(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                                  Text(t('زائر متوقع', 'Expected Visitors'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
                                ],
                              ),
                              Container(width: 1, height: 40, color: border),
                              Column(
                                children: [
                                  Text('ممتاز', style: GoogleFonts.cairo(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)),
                                  Text(t('فرصة المبيعات', 'Sales Chance'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.isArabic
                                ? '💡 بناءً على الموقع الممتاز والطقس المشمس في هذه التواريخ، نتوقع حضوراً كثيفاً.'
                                : '💡 Based on the prime location and sunny weather on these dates, we expect high turnout.',
                            style: GoogleFonts.cairo(color: dim, fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // AI Trust Score
                    Text(
                      t('تحليل الذكاء الاصطناعي', 'AI Trust Analysis'),
                      style: GoogleFonts.cairo(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6A1B9A).withValues(alpha: 0.1),
                            accent.withValues(alpha: 0.05)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF6A1B9A).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) =>
                                      CircularProgressIndicator(
                                    value: _progressAnimation.value,
                                    strokeWidth: 8,
                                    backgroundColor: surface,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) => Text(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: GoogleFonts.cairo(
                                    color: text,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.greenAccent, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                        t('الموقع محقق', 'Location Verified'),
                                        style: GoogleFonts.cairo(
                                            color: text, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.greenAccent, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                        t('التواريخ منطقية', 'Dates Valid'),
                                        style: GoogleFonts.cairo(
                                            color: text, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded,
                                        color: Colors.amber, size: 16),
                                    const SizedBox(width: 6),
                                    Text(t('حساب حديث', 'New Account'),
                                        style: GoogleFonts.cairo(
                                            color: text, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t('قيد المراجعة من فريق CraftGo',
                                      'Under Review by CraftGo Team'),
                                  style: GoogleFonts.cairo(
                                      color: dim,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Participation Requests
                    Text(
                      t('طلبات المشاركة', 'Participation Requests'),
                      style: GoogleFonts.cairo(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._mockRequests.map((req) => _buildRequestCard(req)),

                    const SizedBox(height: 24),

                    // Invited Artisans
                    Text(
                      t('الحرفيون المشاركون (4)', 'Participating Artisans (4)'),
                      style: GoogleFonts.cairo(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildArtisanAvatar('أح', 'أحمد', Colors.blue),
                          _buildArtisanAvatar('سز', 'سارة', Colors.purple),
                          _buildArtisanAvatar('مع', 'محمد', Colors.green),
                          _buildArtisanAvatar('لس', 'ليلى', Colors.orange),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Map Placeholder
                    Text(
                      t('الموقع', 'Location'),
                      style: GoogleFonts.cairo(
                          color: text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: accent.withValues(alpha: 0.5)),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/map_placeholder.png'),
                          fit: BoxFit.cover,
                          opacity: 0.3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: accent, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              widget.isArabic
                                  ? widget.exhibition['location']
                                  : widget.exhibition['locationEn'],
                              style: GoogleFonts.cairo(
                                color: text,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: req['color'],
                child: Text(
                  widget.isArabic
                      ? req['name'].substring(0, 1)
                      : req['nameEn'].substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isArabic ? req['name'] : req['nameEn'],
                      style: GoogleFonts.cairo(
                          color: text, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.isArabic ? req['craft'] : req['craftEn'],
                      style: GoogleFonts.cairo(color: dim, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                widget.isArabic ? req['time'] : req['timeEn'],
                style: GoogleFonts.cairo(color: dim, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _mockRequests.remove(req);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(t('قبول', 'Accept')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _mockRequests.remove(req);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(t('رفض', 'Reject')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanAvatar(String initials, String name, Color color) {
    return Container(
      width: 70,
      margin: EdgeInsets.only(
          left: widget.isArabic ? 16 : 0, right: widget.isArabic ? 0 : 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              initials,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.cairo(color: text, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
