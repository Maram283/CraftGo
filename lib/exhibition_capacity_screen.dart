import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CraftsmanStatus { confirmed, standby, absent }

class ExhibitionCraftsman {
  final String id;
  final String nameAr;
  final String nameEn;
  final String specialtyAr;
  final String specialtyEn;
  final String city;
  final double rating;
  final int commitmentScore;
  final double distanceKm;
  final String phone;
  CraftsmanStatus status;
  int? standbyOrder;
  bool respondedToAlert;

  ExhibitionCraftsman({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.specialtyAr,
    required this.specialtyEn,
    required this.city,
    required this.rating,
    required this.commitmentScore,
    required this.distanceKm,
    required this.phone,
    this.status = CraftsmanStatus.confirmed,
    this.standbyOrder,
    this.respondedToAlert = false,
  });

  double aiMatchScore(ExhibitionCraftsman missing) {
    double score = 0;
    if (specialtyAr == missing.specialtyAr) score += 50;
    score += (rating / 5.0) * 20;
    score += (commitmentScore / 100.0) * 20;
    score += max(0, (1 - distanceKm / 100)) * 10;
    return score;
  }
}

class AbsenceAlert {
  final String craftsmanId;
  final String reason;
  final DateTime reportedAt;
  bool resolved;
  AbsenceAlert({
    required this.craftsmanId,
    required this.reason,
    required this.reportedAt,
    this.resolved = false,
  });
}

class ExhibitionCapacityScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;
  final String exhibitionName;
  final int maxCapacity;

  const ExhibitionCapacityScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
    required this.exhibitionName,
    this.maxCapacity = 10,
  });

  @override
  State<ExhibitionCapacityScreen> createState() =>
      _ExhibitionCapacityScreenState();
}

class _ExhibitionCapacityScreenState extends State<ExhibitionCapacityScreen>
    with TickerProviderStateMixin {
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

  late AnimationController _pulseCtrl;
  late AnimationController _aiCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _aiAnim;

  int _tabIndex = 0;
  bool _isAiAnalyzing = false;
  String _aiInsight = '';
  AbsenceAlert? _activeAlert;
  ExhibitionCraftsman? _suggestedReplacement;
  late List<ExhibitionCraftsman> _craftsmen;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _aiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _aiAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _aiCtrl, curve: Curves.easeOut));
    _craftsmen = _generateMockCraftsmen();
  }

  List<ExhibitionCraftsman> _generateMockCraftsmen() {
    return [
      ExhibitionCraftsman(id: '1', nameAr: 'ط£ط­ظ…ط¯ ط§ظ„ط­ط¯ط§ط¯', nameEn: 'Ahmad Al-Haddad', specialtyAr: 'ظ†ط¬ط§ط±ط©', specialtyEn: 'Carpentry', city: 'ط¹ظ…ط§ظ†', rating: 4.9, commitmentScore: 95, distanceKm: 5, phone: '+962 79 111 2233', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '2', nameAr: 'ط³ط§ط±ط© ط§ظ„ط²ظ‡ط±ط§ظ†ظٹ', nameEn: 'Sara Al-Zahrani', specialtyAr: 'ظ…ط¬ظˆظ‡ط±ط§طھ', specialtyEn: 'Jewelry', city: 'ط¹ظ…ط§ظ†', rating: 4.8, commitmentScore: 90, distanceKm: 8, phone: '+962 79 222 3344', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '3', nameAr: 'ظ…ط­ظ…ط¯ ط§ظ„ط¹ظ…ط±ظٹ', nameEn: 'Mohammad Al-Omari', specialtyAr: 'ظپط®ط§ط±', specialtyEn: 'Pottery', city: 'ط§ظ„ط²ط±ظ‚ط§ط،', rating: 4.7, commitmentScore: 88, distanceKm: 22, phone: '+962 78 333 4455', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '4', nameAr: 'ط±ظٹظ… ط§ظ„ط®ط§ظ„ط¯ظٹ', nameEn: 'Reem Al-Khalidi', specialtyAr: 'ظ†ط³ظٹط¬', specialtyEn: 'Weaving', city: 'ط¹ظ…ط§ظ†', rating: 4.6, commitmentScore: 92, distanceKm: 12, phone: '+962 77 444 5566', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '5', nameAr: 'ط®ط§ظ„ط¯ ط§ظ„ط´ظ…ط±ظٹ', nameEn: 'Khalid Al-Shamri', specialtyAr: 'ط®ط²ظپ', specialtyEn: 'Ceramics', city: 'ط§ط±ط¨ط¯', rating: 4.5, commitmentScore: 80, distanceKm: 85, phone: '+962 79 555 6677', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '6', nameAr: 'ظ†ظˆط± ط§ظ„ط¯ظٹظ† ط§ظ„ط³ط¹ظٹط¯', nameEn: 'Nour Al-Saeed', specialtyAr: 'ط±ط³ظ…', specialtyEn: 'Painting', city: 'ط¹ظ…ط§ظ†', rating: 4.9, commitmentScore: 97, distanceKm: 6, phone: '+962 78 666 7788', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '7', nameAr: 'ظ‡ظٹط§ظ… ط§ظ„ظ‚ط§ط³ظ…', nameEn: 'Hayam Al-Qasem', specialtyAr: 'طھط·ط±ظٹط²', specialtyEn: 'Embroidery', city: 'ط¹ظ…ط§ظ†', rating: 4.7, commitmentScore: 85, distanceKm: 9, phone: '+962 79 777 8899', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '8', nameAr: 'ظٹظˆط³ظپ ط§ظ„ظ…طµط±ظٹ', nameEn: 'Yousef Al-Masri', specialtyAr: 'ظ†ط­ط§ط³ظٹط§طھ', specialtyEn: 'Copperwork', city: 'ط§ظ„ط³ظ„ط·', rating: 4.4, commitmentScore: 78, distanceKm: 35, phone: '+962 77 888 9900', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '9', nameAr: 'ظ„ظ…ظٹط§ط، ط§ظ„ط­ط³ظ†', nameEn: 'Lamia Al-Hassan', specialtyAr: 'طµط¨ط§ط؛ط©', specialtyEn: 'Dyeing', city: 'ط¹ظ…ط§ظ†', rating: 4.6, commitmentScore: 88, distanceKm: 11, phone: '+962 79 999 0011', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '10', nameAr: 'ط¹ظ…ط± ط§ظ„طµط§ظپظٹ', nameEn: 'Omar Al-Safi', specialtyAr: 'ط¬ظ„ط¯ظٹط§طھ', specialtyEn: 'Leatherwork', city: 'ط¹ظ…ط§ظ†', rating: 4.8, commitmentScore: 93, distanceKm: 7, phone: '+962 78 100 1122', status: CraftsmanStatus.confirmed),
      ExhibitionCraftsman(id: '11', nameAr: 'ظپط§ط·ظ…ط© ط§ظ„ظ†ط¬ط§ط±', nameEn: 'Fatima Al-Najjar', specialtyAr: 'ظ†ط¬ط§ط±ط©', specialtyEn: 'Carpentry', city: 'ط¹ظ…ط§ظ†', rating: 4.7, commitmentScore: 91, distanceKm: 4, phone: '+962 79 201 1234', status: CraftsmanStatus.standby, standbyOrder: 1),
      ExhibitionCraftsman(id: '12', nameAr: 'ط¨ط§ط³ظ… ظ‚ط·ظٹط´ط§طھ', nameEn: 'Basem Qateeshat', specialtyAr: 'ظپط®ط§ط±', specialtyEn: 'Pottery', city: 'ط§ظ„ط²ط±ظ‚ط§ط،', rating: 4.5, commitmentScore: 87, distanceKm: 25, phone: '+962 77 302 5678', status: CraftsmanStatus.standby, standbyOrder: 2),
      ExhibitionCraftsman(id: '13', nameAr: 'ط±ظˆط§ظ† ط§ظ„ط·ط±ط§ظˆظ†ط©', nameEn: 'Rawan Al-Tarawneh', specialtyAr: 'ظ…ط¬ظˆظ‡ط±ط§طھ', specialtyEn: 'Jewelry', city: 'ط¹ظ…ط§ظ†', rating: 4.9, commitmentScore: 96, distanceKm: 3, phone: '+962 79 403 9012', status: CraftsmanStatus.standby, standbyOrder: 3),
      ExhibitionCraftsman(id: '14', nameAr: 'طھط§ظ…ط± ط§ط¨ظˆ ط®ط¶ط±', nameEn: 'Tamer Abu Khudur', specialtyAr: 'ط®ط²ظپ', specialtyEn: 'Ceramics', city: 'ط§ط±ط¨ط¯', rating: 4.3, commitmentScore: 75, distanceKm: 90, phone: '+962 78 504 3456', status: CraftsmanStatus.standby, standbyOrder: 4),
      ExhibitionCraftsman(id: '15', nameAr: 'ط³ظ„ظ…ظ‰ ط§ظ„ط¨ط·ط§ظٹظ†ط©', nameEn: 'Salma Al-Bataineh', specialtyAr: 'ظ†ط³ظٹط¬', specialtyEn: 'Weaving', city: 'ط¹ظ…ط§ظ†', rating: 4.6, commitmentScore: 89, distanceKm: 14, phone: '+962 77 605 7890', status: CraftsmanStatus.standby, standbyOrder: 5),
    ];
  }

  List<ExhibitionCraftsman> get _confirmed =>
      _craftsmen.where((c) => c.status == CraftsmanStatus.confirmed).toList();
  List<ExhibitionCraftsman> get _standby {
    final list = _craftsmen.where((c) => c.status == CraftsmanStatus.standby).toList();
    list.sort((a, b) => (a.standbyOrder ?? 99).compareTo(b.standbyOrder ?? 99));
    return list;
  }

  bool get isFull => _confirmed.length >= widget.maxCapacity;
  double get fillPercent => _confirmed.length / widget.maxCapacity;

  Future<void> _runAiAnalysis() async {
    setState(() { _isAiAnalyzing = true; _aiInsight = ''; });
    _aiCtrl.forward(from: 0);
    await Future.delayed(const Duration(seconds: 2));
    final int highRisk = _confirmed.where((c) => c.commitmentScore < 85).length;
    final List<ExhibitionCraftsman> distant = _confirmed.where((c) => c.distanceKm > 50).toList();
    String insight;
    if (widget.isArabic) {
      insight = 'ًں¤– طھط­ظ„ظٹظ„ ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ:\n\n'
          'â€¢ ${_confirmed.length} ط­ط±ظپظٹ ظ…ط¤ظƒط¯ ظ…ظ† ط§طµظ„ ${widget.maxCapacity}\n'
          'â€¢ ${_standby.length} ظپظٹ ظ‚ط§ط¦ظ…ط© ط§ظ„ط§ط­طھظٹط§ط·\n'
          'â€¢ $highRisk ط­ط±ظپظٹ ظ„ط¯ظٹظ‡ظ… ط³ط¬ظ„ ط§ظ„طھط²ط§ظ… ط§ظ‚ظ„ ظ…ظ† 85% â†گ ط®ط·ط± ط؛ظٹط§ط¨\n'
          '${distant.isNotEmpty ? "â€¢ ${distant.map((c) => c.nameAr).join("طŒ ")} ظٹظ‚ط¹ظˆظ† ط¹ظ„ظ‰ ط¨ط¹ط¯ ط§ظƒط«ط± ظ…ظ† 50 ظƒظ…\n" : ""}'
          '\n âœ… طھظˆطµظٹط©: ط§ط¶ظپ ${max(0, 3 - _standby.length)} ط§ط­طھظٹط§ط·ظٹ ط§ط¶ط§ظپظٹ';
    } else {
      insight = 'ًں¤– AI Analysis:\n\n'
          'â€¢ ${_confirmed.length} confirmed of ${widget.maxCapacity} max\n'
          'â€¢ ${_standby.length} on standby\n'
          'â€¢ $highRisk craftsmen have commitment below 85% â†گ absence risk\n'
          '${distant.isNotEmpty ? "â€¢ ${distant.map((c) => c.nameEn).join(", ")} are 50+ km away\n" : ""}'
          '\nâœ… Recommendation: Add ${max(0, 3 - _standby.length)} more standby members';
    }
    if (mounted) setState(() { _isAiAnalyzing = false; _aiInsight = insight; });
  }

  void _reportAbsence(ExhibitionCraftsman craftsman) {
    setState(() { craftsman.status = CraftsmanStatus.absent; });
    _activeAlert = AbsenceAlert(craftsmanId: craftsman.id, reason: t('ط§ط¹طھط°ط§ط± ظ…ظپط§ط¬ط¦', 'Sudden cancellation'), reportedAt: DateTime.now());
    final standbyList = _standby.toList();
    if (standbyList.isNotEmpty) {
      standbyList.sort((a, b) => b.aiMatchScore(craftsman).compareTo(a.aiMatchScore(craftsman)));
      _suggestedReplacement = standbyList.first;
    }
    setState(() {});
    _showAbsenceDialog(craftsman);
  }

  void _showAbsenceDialog(ExhibitionCraftsman absent) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (ctx) => _AbsenceAlertDialog(
        absent: absent, suggested: _suggestedReplacement,
        isArabic: widget.isArabic, isDarkMode: widget.isDarkMode,
        onConfirm: () { Navigator.pop(ctx); if (_suggestedReplacement != null) _promoteStandby(_suggestedReplacement!); },
        onSkip: () => Navigator.pop(ctx),
      ),
    );
  }

  void _promoteStandby(ExhibitionCraftsman standby) {
    setState(() {
      standby.status = CraftsmanStatus.confirmed;
      standby.standbyOrder = null;
      int order = 1;
      for (final c in _standby) { c.standbyOrder = order++; }
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Text(t('âœ… ${standby.nameAr} طھظ…طھ طھط±ظ‚ظٹطھظ‡', 'âœ… ${standby.nameEn} promoted'), style: GoogleFonts.cairo(color: Colors.white)),
      duration: const Duration(seconds: 4),
    ));
  }

  @override
  void dispose() { _pulseCtrl.dispose(); _aiCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface, elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: text, size: 20), onPressed: () => Navigator.pop(context)),
          title: Column(children: [
            Text(widget.exhibitionName, style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(t('ط§ط¯ط§ط±ط© ط§ظ„ط·ط§ظ‚ط© ط§ظ„ط§ط³طھظٹط¹ط§ط¨ظٹط©', 'Capacity Management'), style: GoogleFonts.cairo(color: dim, fontSize: 11)),
          ]),
          centerTitle: true,
          actions: [IconButton(
            icon: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (c, ch) => Transform.scale(scale: _isAiAnalyzing ? _pulseAnim.value : 1.0, child: ch),
              child: Icon(Icons.auto_awesome, color: _isAiAnalyzing ? Colors.purpleAccent : accent),
            ),
            onPressed: _runAiAnalysis,
          )],
        ),
        body: Column(children: [
          _buildCapacityHeader(),
          _buildTabBar(),
          Expanded(child: IndexedStack(index: _tabIndex, children: [
            _buildConfirmedList(),
            _buildStandbyList(),
            _buildAlertsTab(),
          ])),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _runAiAnalysis,
          backgroundColor: Colors.purpleAccent,
          icon: AnimatedBuilder(animation: _pulseAnim, builder: (c, ch) => Transform.scale(scale: _isAiAnalyzing ? _pulseAnim.value : 1.0, child: ch!), child: const Icon(Icons.auto_awesome, color: Colors.white)),
          label: Text(t('طھط­ظ„ظٹظ„ AI', 'AI Analysis'), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildCapacityHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFull ? [const Color(0xFF7B0000), const Color(0xFF1C0000)] : [accent.withValues(alpha: 0.15), const Color(0xFF0D1420)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isFull ? Colors.redAccent.withValues(alpha: 0.4) : accent.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isFull ? t('ًں”´ ط§ظ„ظ…ط¹ط±ط¶ ظ…ظ…طھظ„ط¦', 'ًں”´ Exhibition Full') : t('ًںں¢ ظ…ظ‚ط§ط¹ط¯ ظ…طھط§ط­ط©', 'ًںں¢ Seats Available'),
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(isFull ? t('ط§ظ„طھط³ط¬ظٹظ„ ط§ظ„ط¬ط¯ظٹط¯ â†گ ظ‚ط§ط¦ظ…ط© ط§ظ„ط§ط­طھظٹط§ط·', 'New registrations â†’ Standby') : t('${widget.maxCapacity - _confirmed.length} ظ…ظ‚ط¹ط¯ ظ…طھط¨ظ‚', '${widget.maxCapacity - _confirmed.length} seats left'),
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
          ])),
          SizedBox(width: 70, height: 70, child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: fillPercent.clamp(0.0, 1.0), strokeWidth: 7, backgroundColor: Colors.white.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation<Color>(isFull ? Colors.redAccent : accent)),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${_confirmed.length}', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('/${widget.maxCapacity}', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10)),
            ]),
          ])),
        ]),
        const SizedBox(height: 16),
        _buildSeatGrid(),
        const SizedBox(height: 12),
        Row(children: [
          _buildLegend(isFull ? Colors.redAccent : accent, t('ظ…ط¤ظƒط¯', 'Confirmed')),
          const SizedBox(width: 16), _buildLegend(Colors.amber, t('ط§ط­طھظٹط§ط·', 'Standby')),
          const SizedBox(width: 16), _buildLegend(Colors.white.withValues(alpha: 0.2), t('ظ…طھط§ط­', 'Available')),
        ]),
        if (_aiInsight.isNotEmpty) ...[
          const SizedBox(height: 12),
          AnimatedBuilder(animation: _aiAnim, builder: (c, ch) => Opacity(opacity: _aiAnim.value, child: ch!), child: Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3))),
            child: Text(_aiInsight, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, height: 1.6)),
          )),
        ],
        if (_isAiAnalyzing) ...[
          const SizedBox(height: 12),
          Row(children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent))),
            const SizedBox(width: 8),
            Text(t('ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ ظٹط­ظ„ظ„...', 'AI analyzing...'), style: GoogleFonts.cairo(color: Colors.purpleAccent, fontSize: 12)),
          ]),
        ],
      ]),
    );
  }


  Widget _buildSeatGrid() {
    final total = widget.maxCapacity + _standby.length;
    return Wrap(spacing: 4, runSpacing: 4, children: List.generate(total, (i) {
      Color color;
      if (i < _confirmed.length) {
        color = isFull ? Colors.redAccent : accent;
      } else if (i < widget.maxCapacity) {
        color = Colors.white.withValues(alpha: 0.15);
      } else {
        color = Colors.amber.withValues(alpha: 0.6);
      }
      return AnimatedContainer(duration: Duration(milliseconds: 300 + (i * 30)), width: 20, height: 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)));
    }));
  }


  Widget _buildLegend(Color color, String label) {
    return Row(children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
    ]);
  }

  Widget _buildTabBar() {
    final tabs = [
      (Icons.verified_user_outlined, t('ظ…ط¤ظƒط¯ظˆظ†', 'Confirmed'), _confirmed.length, Colors.green),
      (Icons.hourglass_empty, t('ط§ط­طھظٹط§ط·', 'Standby'), _standby.length, Colors.amber),
      (Icons.notifications_active_outlined, t('طھظ†ط¨ظٹظ‡ط§طھ', 'Alerts'), _activeAlert != null ? 1 : 0, Colors.redAccent),
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      child: Row(children: tabs.asMap().entries.map((entry) {
        final i = entry.key; final tab = entry.value; final selected = _tabIndex == i;
        return Expanded(child: GestureDetector(onTap: () => setState(() => _tabIndex = i), child: AnimatedContainer(
          duration: const Duration(milliseconds: 250), margin: const EdgeInsets.all(4), padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: selected ? accent : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Stack(alignment: Alignment.topRight, children: [
              Icon(tab.$1, color: selected ? Colors.black : dim, size: 20),
              if (tab.$3 > 0) Container(width: 14, height: 14, decoration: BoxDecoration(color: tab.$4, shape: BoxShape.circle),
                  child: Center(child: Text('${tab.$3}', style: const TextStyle(color: Colors.white, fontSize: 8)))),
            ]),
            const SizedBox(height: 2),
            Text(tab.$2, style: GoogleFonts.cairo(color: selected ? Colors.black : dim, fontSize: 11, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          ]),
        )));
      }).toList()),
    );
  }

  Widget _buildConfirmedList() {
    final absent = _craftsmen.where((c) => c.status == CraftsmanStatus.absent).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      if (absent.isNotEmpty) ...[
        _sectionHeader(Icons.warning_amber_rounded, t('ط؛ط§ط¦ط¨ظˆظ† (${absent.length})', 'Absent (${absent.length})'), Colors.redAccent),
        ...absent.map((c) => _craftsmanCard(c, isAbsent: true)),
        const SizedBox(height: 12),
      ],
      _sectionHeader(Icons.check_circle_outline, t('ظ…ط¤ظƒط¯ظˆظ† (${_confirmed.length}/${widget.maxCapacity})', 'Confirmed (${_confirmed.length}/${widget.maxCapacity})'), Colors.green),
      ..._confirmed.map((c) => _craftsmanCard(c)),
    ]);
  }

  Widget _buildStandbyList() {
    if (_standby.isEmpty) return _emptyState(Icons.hourglass_empty, t('ظ„ط§ ظٹظˆط¬ط¯ ط§ط­طھظٹط§ط· ط¨ط¹ط¯', 'No standby yet'), t('ظٹظ…ظƒظ† ظ„ظ„ط­ط±ظپظٹظٹظ† ط§ظ„طھط³ط¬ظٹظ„ ظƒط§ط­طھظٹط§ط· ط¹ظ†ط¯ظ…ط§ ظٹظ…طھظ„ط¦ ط§ظ„ظ…ط¹ط±ط¶', 'Craftsmen can join standby when exhibition is full'));
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.withValues(alpha: 0.3))),
        child: Row(children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 18), const SizedBox(width: 8),
          Expanded(child: Text(t('ط§ظ„طھط±طھظٹط¨ ظ…ط¯ط¹ظˆظ… ط¨ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ â€” ط§ظ„طھط®طµطµطŒ ط§ظ„طھظ‚ظٹظٹظ…طŒ ط§ظ„ط§ظ„طھط²ط§ظ…طŒ ط§ظ„ظ…ط³ط§ظپط©', 'AI-powered ordering â€” specialty, rating, commitment, distance'), style: GoogleFonts.cairo(color: Colors.amber, fontSize: 11))),
        ]),
      ),
      const SizedBox(height: 12),
      ..._standby.asMap().entries.map((e) => _standbyCard(e.value, e.key + 1)),
    ]);
  }

  Widget _buildAlertsTab() {
    if (_activeAlert == null) return _emptyState(Icons.notifications_none, t('ظ„ط§ ظٹظˆط¬ط¯ طھظ†ط¨ظٹظ‡ط§طھ', 'No alerts'), t('ط³طھط¸ظ‡ط± ظ‡ظ†ط§ طھظ†ط¨ظٹظ‡ط§طھ ط§ظ„ط؛ظٹط§ط¨ ظˆط§ظ„ط§ط³طھط¨ط¯ط§ظ„', 'Absence and replacement alerts appear here'));
    final absent = _craftsmen.firstWhere((c) => c.id == _activeAlert!.craftsmanId);
    return ListView(padding: const EdgeInsets.all(16), children: [
      _alertCard(absent),
      if (_suggestedReplacement != null) ...[const SizedBox(height: 12), _aiRecommendationCard(_suggestedReplacement!, absent)],
      const SizedBox(height: 16),
      _alertTimeline(),
    ]);
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      Icon(icon, color: color, size: 18), const SizedBox(width: 6),
      Text(title, style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 14)),
    ]));
  }

  Widget _craftsmanCard(ExhibitionCraftsman c, {bool isAbsent = false}) {
    final Color sc = isAbsent ? Colors.redAccent : c.commitmentScore >= 90 ? Colors.green : c.commitmentScore >= 80 ? Colors.amber : Colors.orange;
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: isAbsent ? Colors.redAccent.withValues(alpha: 0.4) : border)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: sc.withValues(alpha: 0.15), border: Border.all(color: sc.withValues(alpha: 0.4))),
            child: Center(child: Text((widget.isArabic ? c.nameAr : c.nameEn).substring(0, 1), style: TextStyle(color: sc, fontWeight: FontWeight.bold, fontSize: 18)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(widget.isArabic ? c.nameAr : c.nameEn, style: GoogleFonts.cairo(color: isAbsent ? Colors.redAccent : text, fontWeight: FontWeight.bold, fontSize: 13))),
            if (isAbsent) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)), child: Text(t('ط؛ط§ط¦ط¨', 'Absent'), style: const TextStyle(color: Colors.redAccent, fontSize: 10)))],
          ]),
          Row(children: [
            Icon(Icons.handyman_outlined, color: dim, size: 12), const SizedBox(width: 3),
            Text(widget.isArabic ? c.specialtyAr : c.specialtyEn, style: GoogleFonts.cairo(color: dim, fontSize: 11)),
            const SizedBox(width: 6), Icon(Icons.location_on_outlined, color: dim, size: 12),
            Text(c.city, style: GoogleFonts.cairo(color: dim, fontSize: 11)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star, color: Colors.amber, size: 12), const SizedBox(width: 2),
            Text(c.rating.toStringAsFixed(1), style: GoogleFonts.cairo(color: Colors.amber, fontSize: 11)),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t('ط§ظ„ط§ظ„طھط²ط§ظ…', 'Commitment'), style: GoogleFonts.cairo(color: dim, fontSize: 9)),
                Text('${c.commitmentScore}%', style: GoogleFonts.cairo(color: sc, fontSize: 9, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 2),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: c.commitmentScore / 100, minHeight: 4, backgroundColor: sc.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation<Color>(sc))),
            ])),
          ]),
        ])),
        if (!isAbsent) IconButton(icon: const Icon(Icons.person_remove_outlined, color: Colors.redAccent, size: 18), tooltip: t('ط§ظ„ط§ط¨ظ„ط§ط؛ ط¹ظ† ط؛ظٹط§ط¨', 'Report absence'), onPressed: () => _reportAbsence(c)),
      ]),
    );
  }

  Widget _standbyCard(ExhibitionCraftsman c, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: rank == 1 ? Colors.amber.withValues(alpha: 0.5) : border)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: rank == 1 ? Colors.amber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05), border: Border.all(color: rank == 1 ? Colors.amber : border)),
            child: Center(child: Text('#$rank', style: GoogleFonts.cairo(color: rank == 1 ? Colors.amber : dim, fontWeight: FontWeight.bold, fontSize: 12)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(widget.isArabic ? c.nameAr : c.nameEn, style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 13))),
            if (rank == 1) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)), child: Text(t('ط§ظ„ط§ظˆظ„ ظ„ظ„ط§ط³طھط¯ط¹ط§ط،', 'First to call'), style: const TextStyle(color: Colors.amber, fontSize: 9)))],
          ]),
          Text('${widget.isArabic ? c.specialtyAr : c.specialtyEn} â€¢ ${c.city} â€¢ ${c.distanceKm.toInt()} ظƒظ…', style: GoogleFonts.cairo(color: dim, fontSize: 11)),
          Row(children: [const Icon(Icons.star, color: Colors.amber, size: 12), Text(' ${c.rating}', style: GoogleFonts.cairo(color: Colors.amber, fontSize: 11)), const SizedBox(width: 8), Icon(Icons.history, color: dim, size: 12), Text(' ${c.commitmentScore}%', style: GoogleFonts.cairo(color: dim, fontSize: 11))]),
        ])),
        Column(children: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Colors.green, size: 18), tooltip: t('ط§طھطµط§ظ„', 'Call'), onPressed: () => _showContactDialog(c)),
          IconButton(icon: Icon(Icons.upgrade, color: accent, size: 18), tooltip: t('طھط±ظ‚ظٹط© ط§ظ„ظ‰ ظ…ط¤ظƒط¯', 'Promote to confirmed'), onPressed: () => _promoteStandby(c)),
        ]),
      ]),
    );
  }

  Widget _alertCard(ExhibitionCraftsman absent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20), const SizedBox(width: 8), Text(t('طھظ†ط¨ظٹظ‡ ط؛ظٹط§ط¨!', 'Absence Alert!'), style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16))]),
        const SizedBox(height: 10),
        Text(t('${absent.nameAr} (${absent.specialtyAr}) ط§ط¨ظ„ط؛ ط¹ظ† ط§ط¹طھط°ط§ط±ظ‡ ظ…ظ† ط§ظ„ظ…ط¹ط±ط¶.', '${absent.nameEn} (${absent.specialtyEn}) has reported inability to attend.'), style: GoogleFonts.cairo(color: text, fontSize: 13)),
        const SizedBox(height: 8),
        Text(t('ط§ظ„ط³ط¨ط¨: ${_activeAlert!.reason}', 'Reason: ${_activeAlert!.reason}'), style: GoogleFonts.cairo(color: dim, fontSize: 12)),
        Text('${t("ط§ظ„طھظˆظ‚ظٹطھ:", "Reported:")} ${_activeAlert!.reportedAt.hour}:${_activeAlert!.reportedAt.minute.toString().padLeft(2, '0')}', style: GoogleFonts.cairo(color: dim, fontSize: 12)),
      ]),
    );
  }

  Widget _aiRecommendationCard(ExhibitionCraftsman suggested, ExhibitionCraftsman absent) {
    final int matchScore = suggested.aiMatchScore(absent).toInt();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purpleAccent.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 18), const SizedBox(width: 8),
          Text(t('طھظˆطµظٹط© ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ', 'AI Recommendation'), style: GoogleFonts.cairo(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: Text('طھط·ط§ط¨ظ‚ $matchScore%', style: const TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 12),
        Text(t('ط§ظ„ط§ظ†ط³ط¨ ظ„ظ„ط§ط³طھط¨ط¯ط§ظ„ ظ‡ظˆ ${suggested.nameAr} (${suggested.specialtyAr}) - طھظ‚ظٹظٹظ… ${suggested.rating} - ط§ظ„طھط²ط§ظ… ${suggested.commitmentScore}% - ${suggested.distanceKm.toInt()} ظƒظ….', 'Best match: ${suggested.nameEn} (${suggested.specialtyEn}) â€” rating ${suggested.rating} â­گ, commitment ${suggested.commitmentScore}%, ${suggested.distanceKm.toInt()} km.'), style: GoogleFonts.cairo(color: text, fontSize: 12, height: 1.6)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: ElevatedButton.icon(onPressed: () => _showContactDialog(suggested), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)), icon: const Icon(Icons.send, size: 14), label: Text(t('ط§ط±ط³ط§ظ„ ط¯ط¹ظˆط©', 'Send Invite'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(onPressed: () => _promoteStandby(suggested), style: OutlinedButton.styleFrom(foregroundColor: Colors.purpleAccent, side: const BorderSide(color: Colors.purpleAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)), icon: const Icon(Icons.upgrade, size: 14), label: Text(t('طھط±ظ‚ظٹط© ظ…ط¨ط§ط´ط±ط©', 'Promote Now'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)))),
        ]),
      ]),
    );
  }

  Widget _alertTimeline() {
    final hour = _activeAlert!.reportedAt.hour;
    final min = _activeAlert!.reportedAt.minute.toString().padLeft(2, '0');
    final events = [
      (Icons.person_remove, Colors.redAccent, t('طھظ… ط§ظ„ط§ط¨ظ„ط§ط؛ ط¹ظ† ط§ظ„ط؛ظٹط§ط¨', 'Absence reported'), '$hour:$min', true),
      (Icons.auto_awesome, Colors.purpleAccent, t('ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ ط§ط®طھط§ط± ط§ظپط¶ظ„ ط¨ط¯ظٹظ„', 'AI selected best replacement'), t('ط§ظ„ط§ظ†', 'Now'), true),
      (Icons.send, Colors.blue, t('ظپظٹ ط§ظ†طھط¸ط§ط± ط§ظ„ط±ط¯ ظ…ظ† ط§ظ„ط§ط­طھظٹط§ط·', 'Waiting for standby response'), t('ظ‚ظٹط¯ ط§ظ„ط§ظ†طھط¸ط§ط±...', 'Pending...'), false),
      (Icons.check_circle_outline, Colors.green, t('طھط§ظƒظٹط¯ ط§ظ„ط­ط±ظپظٹ ط§ظ„ط¬ط¯ظٹط¯', 'New craftsman confirmed'), t('ظ‚ط±ظٹط¨ط§', 'Soon'), false),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t('ط®ط· ط³ظٹط± ط§ظ„ط§ط³طھط¨ط¯ط§ظ„', 'Replacement Timeline'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...events.asMap().entries.map((entry) {
          final i = entry.key; final ev = entry.value; final isLast = i == events.length - 1;
          return IntrinsicHeight(child: Row(children: [
            Column(children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: ev.$2.withValues(alpha: ev.$5 ? 0.2 : 0.05), border: Border.all(color: ev.$2.withValues(alpha: ev.$5 ? 0.8 : 0.3))), child: Icon(ev.$1, color: ev.$2, size: 16)),
              if (!isLast) Container(width: 2, height: 30, color: i == 0 ? ev.$2.withValues(alpha: 0.5) : border),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ev.$3, style: GoogleFonts.cairo(color: ev.$5 ? text : dim, fontWeight: ev.$5 ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
              Text(ev.$4, style: GoogleFonts.cairo(color: dim, fontSize: 11)),
            ]))),
          ]));
        }),
      ]),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 72, color: dim.withValues(alpha: 0.4)), const SizedBox(height: 16),
      Text(title, style: GoogleFonts.cairo(color: text, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.cairo(color: dim, fontSize: 13, height: 1.5))),
    ]));
  }

  void _showContactDialog(ExhibitionCraftsman c) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(t('ط§ظ„طھظˆط§طµظ„ ظ…ط¹ ط§ظ„ط­ط±ظپظٹ', 'Contact Craftsman'), style: GoogleFonts.cairo(color: text, fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.isArabic ? c.nameAr : c.nameEn, style: GoogleFonts.cairo(color: accent, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8), Text(c.phone, style: GoogleFonts.cairo(color: dim)),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3))),
          child: Text(t('ًں¤– ط±ط³ط§ظ„ط© AI:\n\nظ…ط±ط­ط¨ط§ ${c.nameAr}! طھط®طµطµظƒ ظپظٹ ${c.specialtyAr} ظ…ط·ظ„ظˆط¨ ظپظٹ ${widget.exhibitionName}. ط§ط­ط¯ ط§ظ„ط­ط±ظپظٹظٹظ† ط§ظ„ظ…ط¤ظƒط¯ظٹظ† ط§ط¹طھط°ط±. ظ‡ظ„ ظٹظ…ظƒظ†ظƒ ط§ظ„ط­ط¶ظˆط±طں', 'ًں¤– AI Message:\n\nHello ${c.nameEn}! Your ${c.specialtyEn} expertise is needed at ${widget.exhibitionName}. A confirmed craftsman has cancelled. Can you attend?'),
            style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, height: 1.5))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t('ط§ظ„ط؛ط§ط،', 'Cancel'), style: GoogleFonts.cairo(color: dim))),
        ElevatedButton(onPressed: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green.shade700, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), content: Text(t('âœ… طھظ… ط§ط±ط³ط§ظ„ ط§ظ„ط¯ط¹ظˆط©!', 'âœ… Invite sent!'), style: GoogleFonts.cairo(color: Colors.white))));
        },
          style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: Text(t('ط§ط±ط³ط§ظ„', 'Send'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold))),
      ],
    ));
  }
}

class _AbsenceAlertDialog extends StatefulWidget {
  final ExhibitionCraftsman absent;
  final ExhibitionCraftsman? suggested;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onConfirm;
  final VoidCallback onSkip;
  const _AbsenceAlertDialog({required this.absent, required this.suggested, required this.isArabic, required this.isDarkMode, required this.onConfirm, required this.onSkip});
  @override
  State<_AbsenceAlertDialog> createState() => _AbsenceAlertDialogState();
}

class _AbsenceAlertDialogState extends State<_AbsenceAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..forward();
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  String t(String ar, String en) => widget.isArabic ? ar : en;
  Color get surface => widget.isDarkMode ? const Color(0xFF1C2431) : Colors.white;
  Color get text => widget.isDarkMode ? Colors.white : Colors.black87;
  Color get dim => widget.isDarkMode ? Colors.white70 : Colors.black54;
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnim, child: AlertDialog(
      backgroundColor: surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(20),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent.withValues(alpha: 0.15)), child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 36)),
        const SizedBox(height: 12),
        Text(t('طھظ†ط¨ظٹظ‡ ط؛ظٹط§ط¨', 'Absence Alert'), style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(t('${widget.absent.nameAr} (${widget.absent.specialtyAr}) ط؛ط§ط¦ط¨ ط¹ظ† ط§ظ„ظ…ط¹ط±ط¶', '${widget.absent.nameEn} (${widget.absent.specialtyEn}) absent from exhibition'), textAlign: TextAlign.center, style: GoogleFonts.cairo(color: text, fontSize: 13)),
        if (widget.suggested != null) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3))), child: Column(children: [
            Row(children: [const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 16), const SizedBox(width: 6), Text(t('ط§ظ‚طھط±ط§ط­ ط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ:', 'AI Suggestion:'), style: GoogleFonts.cairo(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 13))]),
            const SizedBox(height: 8),
            Text(t('${widget.suggested!.nameAr} (${widget.suggested!.specialtyAr}) - طھظ‚ظٹظٹظ… ${widget.suggested!.rating} - ${widget.suggested!.distanceKm.toInt()} ظƒظ…', '${widget.suggested!.nameEn} (${widget.suggested!.specialtyEn}) â€” Rating ${widget.suggested!.rating} â€” ${widget.suggested!.distanceKm.toInt()} km'), textAlign: TextAlign.center, style: GoogleFonts.cairo(color: text, fontSize: 12)),
          ])),
        ],
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: widget.onSkip, style: OutlinedButton.styleFrom(foregroundColor: dim, side: BorderSide(color: dim.withValues(alpha: 0.4)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)), child: Text(t('ظ„ط§ط­ظ‚ط§', 'Later'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton.icon(onPressed: widget.onConfirm, style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)), icon: const Icon(Icons.upgrade, size: 16), label: Text(t('طھط±ظ‚ظٹط©', 'Promote'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)))),
        ]),
      ])),
    ));
  }
}