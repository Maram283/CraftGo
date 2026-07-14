import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExhibitionOwnerDashboard extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String ownerName;

  const ExhibitionOwnerDashboard({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.ownerName,
  });

  @override
  State<ExhibitionOwnerDashboard> createState() =>
      _ExhibitionOwnerDashboardState();
}

class _ExhibitionOwnerDashboardState extends State<ExhibitionOwnerDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  bool _isAnalyzingDemand = false;
  String? _aiDemandResult;

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'name': 'أحمد الحداد',
      'nameEn': 'Ahmad Al-Haddad',
      'craft': 'نجارة',
      'craftEn': 'Carpentry',
      'exhibition': 'أسبوع الحرف',
      'time': 'منذ يومين',
      'timeEn': '2 days ago',
      'color': const Color(0xFF1565C0)
    },
    {
      'name': 'سارة الزهراني',
      'nameEn': 'Sara Al-Zahrani',
      'craft': 'مجوهرات',
      'craftEn': 'Jewelry',
      'exhibition': 'معرض الفنون',
      'time': 'منذ 5 ساعات',
      'timeEn': '5 hours ago',
      'color': const Color(0xFF6A1B9A)
    },
    {
      'name': 'محمد العمري',
      'nameEn': 'Mohammad Al-Omari',
      'craft': 'فخار',
      'craftEn': 'Pottery',
      'exhibition': 'معرض الفنون',
      'time': 'منذ يوم',
      'timeEn': '1 day ago',
      'color': const Color(0xFF2E7D32)
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
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

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
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                t('مرحباً، ${widget.ownerName}', 'Welcome, ${widget.ownerName}'),
                style: GoogleFonts.cairo(
                  color: text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t('إدارة معارضك ومتابعة الطلبات',
                    'Manage your exhibitions and requests'),
                style: GoogleFonts.cairo(
                  color: dim,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard(Icons.event, '2',
                        t('معارض نشطة', 'Active Exhibitions'), Colors.green),
                    const SizedBox(width: 12),
                    _buildStatCard(
                        Icons.hourglass_empty,
                        '3',
                        t('طلبات معلقة', 'Pending Requests'),
                        Colors.amber),
                    const SizedBox(width: 12),
                    _buildStatCard(Icons.people_outline, '8',
                        t('حرفيون مدعوون', 'Invited Artisans'), Colors.blue),
                    const SizedBox(width: 12),
                    _buildStatCard(Icons.calendar_today, '1',
                        t('أحداث قادمة', 'Upcoming Events'), Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Recent Exhibitions
              Text(
                t('معارضي الأخيرة', 'My Recent Exhibitions'),
                style: GoogleFonts.cairo(
                  color: text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildRecentExhibition(
                  'أسبوع الحرف اليدوية بعمّان', 'عمّان، الأردن', '2026-07-01 to 2026-07-15', 'Active', Colors.green),
              _buildRecentExhibition(
                  'سوق رمضان الحرفي', 'إربد، الأردن', '2026-03-20 to 2026-03-30', 'Past', Colors.grey),
              _buildRecentExhibition(
                  'معرض الفنون الشعبية', 'الزرقاء، الأردن', '2026-08-10 to 2026-08-20', 'Upcoming', Colors.amber),
              const SizedBox(height: 32),

              // AI Trust Score Panel
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF6A1B9A).withValues(alpha: 0.5)),
                  gradient: LinearGradient(
                    colors: [
                      surface,
                      const Color(0xFF6A1B9A).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
                        const SizedBox(width: 8),
                        Text(
                          t('تحليل الذكاء الاصطناعي لمعارضك',
                              'AI Trust Analysis'),
                          style: GoogleFonts.cairo(
                            color: text,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t('يتم تحليل معارضك تلقائياً لضمان الأمان',
                          'Your exhibitions are auto-analyzed for safety'),
                      style: GoogleFonts.cairo(color: dim, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    _buildAIProgressBar('أسبوع الحرف اليدوية', 0.94, Colors.green),
                    const SizedBox(height: 12),
                    _buildAIProgressBar('سوق رمضان', 0.88, Colors.lightGreen),
                    const SizedBox(height: 12),
                    _buildAIProgressBar('معرض الفنون', 0.71, Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // AI Tips for Success
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          t('نصائح الذكاء الاصطناعي للتحسين', 'AI Tips for Success'),
                          style: GoogleFonts.cairo(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 12),
                    if (_isAnalyzingDemand)
                      const Center(child: CircularProgressIndicator())
                    else if (_aiDemandResult != null)
                      Text(
                        '💡 ${_aiDemandResult!}',
                        style: GoogleFonts.cairo(color: text, fontSize: 13, height: 1.5),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() => _isAnalyzingDemand = true);
                          // Simulate or fetch from backend
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            _aiDemandResult = widget.isArabic 
                              ? 'استناداً إلى بيانات السوق الحالية: هناك إقبال كبير جداً على "الخياطة والتطريز" في منطقتك، ننصحك بتوفير مقاعد كافية لهم في معارضك القادمة.'
                              : 'Based on current market data: There is a very high demand for "Crochet & Knitting" in your area. We recommend providing enough seats for them in your upcoming exhibitions.';
                            _isAnalyzingDemand = false;
                          });
                        },
                        icon: const Icon(Icons.analytics, color: Colors.white),
                        label: Text(
                          t('تحليل طلب السوق الآن', 'Analyze Market Demand Now'),
                          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Pending Requests
              Row(
                children: [
                  Text(
                    t('طلبات المشاركة المعلقة', 'Pending Participation Requests'),
                    style: GoogleFonts.cairo(
                      color: text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_pendingRequests.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._pendingRequests.map((req) => _buildRequestCard(req)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String number, String label, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            number,
            style: GoogleFonts.cairo(
              color: text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: dim,
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExhibition(String name, String location, String date,
      String status, Color statusColor) {
    String statusText = status;
    if (status == 'Active') statusText = t('نشط', 'Active');
    if (status == 'Past') statusText = t('منتهي', 'Past');
    if (status == 'Upcoming') statusText = t('قادم', 'Upcoming');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.horizontal(
                  left: widget.isArabic ? Radius.zero : const Radius.circular(12),
                  right: widget.isArabic ? const Radius.circular(12) : Radius.zero,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.cairo(
                                    color: text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$location • $date',
                            style: GoogleFonts.cairo(color: dim, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accent),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        t('إدارة', 'Manage'),
                        style: GoogleFonts.cairo(color: accent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.cairo(color: text, fontSize: 13)),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Text(
                  '${(value * _progressAnimation.value * 100).toInt()}%',
                  style: GoogleFonts.cairo(
                      color: color, fontWeight: FontWeight.bold, fontSize: 13),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: value * _progressAnimation.value,
                backgroundColor: surface,
                color: color,
                minHeight: 6,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                backgroundColor: req['color'].withValues(alpha: 0.2),
                child: Text(
                  widget.isArabic
                      ? req['name'].substring(0, 1)
                      : req['nameEn'].substring(0, 1),
                  style: TextStyle(
                      color: req['color'], fontWeight: FontWeight.bold),
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
                      '${widget.isArabic ? req['craft'] : req['craftEn']} • ${req['exhibition']}',
                      style: GoogleFonts.cairo(color: dim, fontSize: 12),
                    ),
                    if (req['ai_recommended'] == true)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              t('مرشح ممتاز (AI)', 'AI Recommended'),
                              style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pendingRequests.remove(req);
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
                      _pendingRequests.remove(req);
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
}
