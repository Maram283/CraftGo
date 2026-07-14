// lib/features/hire_order/providers/hire_order_provider.dart
import 'package:flutter/material.dart';

// ── Models ──────────────────────────────────────────────────────────────────

class MaterialItem {
  final String name;
  final int quantity;
  final String unit;

  const MaterialItem({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
  };

  factory MaterialItem.fromJson(Map<String, dynamic> j) => MaterialItem(
    name: j['name'],
    quantity: j['quantity'] as int,
    unit: j['unit'],
  );
}

class DailySchedule {
  final int day;
  final List<String> tasks;
  final int hours;

  const DailySchedule({
    required this.day,
    required this.tasks,
    required this.hours,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'tasks': tasks,
    'hours': hours,
  };

  factory DailySchedule.fromJson(Map<String, dynamic> j) => DailySchedule(
    day: j['day'],
    tasks: List<String>.from(j['tasks']),
    hours: j['hours'] as int,
  );
}

class HireArtisanResponse {
  final double dailyRate;
  final double materialCost;
  final List<DailySchedule> schedule;
  final double totalPrice;
  final String notesAr;
  final String notesEn;

  const HireArtisanResponse({
    required this.dailyRate,
    required this.materialCost,
    required this.schedule,
    required this.totalPrice,
    required this.notesAr,
    required this.notesEn,
  });
}

class HireDailyLog {
  final DateTime date;
  final List<String> tasksCompleted;
  final int hoursWorked;
  final String notes;
  final List<String> images;
  final DateTime createdAt;

  const HireDailyLog({
    required this.date,
    required this.tasksCompleted,
    required this.hoursWorked,
    required this.notes,
    required this.images,
    required this.createdAt,
  });
}

class HireRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String artisanId;
  final String artisanName;
  final String jobDescription;
  final String location;
  final double? locationLat;
  final double? locationLng;
  final DateTime startDate;
  final DateTime endDate;
  final int dailyHours;
  final List<MaterialItem> materials;
  final List<String> toolsRequired;
  final String status;
  final HireArtisanResponse? artisanResponse;
  final bool contractSigned;
  final DateTime? contractSignedAt;
  final List<HireDailyLog>? dailyLogs;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const HireRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.artisanId,
    required this.artisanName,
    required this.jobDescription,
    required this.location,
    this.locationLat,
    this.locationLng,
    required this.startDate,
    required this.endDate,
    required this.dailyHours,
    required this.materials,
    required this.toolsRequired,
    required this.status,
    this.artisanResponse,
    this.contractSigned = false,
    this.contractSignedAt,
    this.dailyLogs,
    required this.createdAt,
    this.updatedAt,
  });

  HireRequest copyWith({
    String? status,
    HireArtisanResponse? artisanResponse,
    bool? contractSigned,
    DateTime? contractSignedAt,
    List<HireDailyLog>? dailyLogs,
    DateTime? updatedAt,
  }) => HireRequest(
    id: id,
    customerId: customerId,
    customerName: customerName,
    artisanId: artisanId,
    artisanName: artisanName,
    jobDescription: jobDescription,
    location: location,
    locationLat: locationLat,
    locationLng: locationLng,
    startDate: startDate,
    endDate: endDate,
    dailyHours: dailyHours,
    materials: materials,
    toolsRequired: toolsRequired,
    status: status ?? this.status,
    artisanResponse: artisanResponse ?? this.artisanResponse,
    contractSigned: contractSigned ?? this.contractSigned,
    contractSignedAt: contractSignedAt ?? this.contractSignedAt,
    dailyLogs: dailyLogs ?? this.dailyLogs,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );

  bool get isPendingArtisan => status == 'pending_artisan';
  bool get isPendingCustomer => status == 'pending_customer';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

// ── Provider ─────────────────────────────────────────────────────────────────

class HireOrderProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  bool get isLoading => _loading;
  String? get error => _error;

  final List<HireRequest> _requests = [];

  List<HireRequest> get requests => List.unmodifiable(_requests);

  List<HireRequest> requestsForCustomer(String customerId) =>
      _requests.where((r) => r.customerId == customerId).toList();

  List<HireRequest> requestsForArtisan(String artisanId) =>
      _requests.where((r) => r.artisanId == artisanId).toList();

  List<HireRequest> get pendingForArtisan =>
      _requests.where((r) => r.status == 'pending_artisan').toList();

  List<HireRequest> get pendingForCustomer =>
      _requests.where((r) => r.status == 'pending_customer').toList();

  HireRequest? findRequest(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  HireOrderProvider() {
    _seedMockData();
  }

  void _seedMockData() {
    _requests.addAll([
      HireRequest(
        id: 'hire-001',
        customerId: 'customer-demo',
        customerName: 'أحمد محمد',
        artisanId: 'artisan-amjad',
        artisanName: 'أمجد الخطيب',
        jobDescription: 'تركيب أرضيات خشبية في غرفة المعيشة، المساحة 30 متر مربع، خشب بلوط فاتح.',
        location: 'نابلس، شارع القدس 15',
        locationLat: 32.2211,
        locationLng: 35.2544,
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 8)),
        dailyHours: 6,
        materials: [
          MaterialItem(name: 'خشب بلوط', quantity: 30, unit: 'متر مربع'),
          MaterialItem(name: 'مسامير', quantity: 2, unit: 'كيس'),
          MaterialItem(name: 'غراء خشب', quantity: 1, unit: 'لتر'),
        ],
        toolsRequired: ['منشار', 'مطرقة', 'شريط قياس'],
        status: 'pending_artisan',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      HireRequest(
        id: 'hire-002',
        customerId: 'customer-demo2',
        customerName: 'ليلى حسن',
        artisanId: 'artisan-fatima',
        artisanName: 'فاطمة محمود',
        jobDescription: 'دهان ثلاث غرف نوم بألوان هادئة، مع تشطيب الأسقف.',
        location: 'رام الله، شارع الإذاعة 8',
        locationLat: 31.9038,
        locationLng: 35.2034,
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 12)),
        dailyHours: 8,
        materials: [
          MaterialItem(name: 'دهان أبيض', quantity: 3, unit: 'جالون'),
          MaterialItem(name: 'فرشاة', quantity: 2, unit: 'قطعة'),
        ],
        toolsRequired: ['فرشاة', 'سلم', 'شريط لاصق'],
        status: 'pending_artisan',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  // ── Fixed: Proper named parameters ──────────────────────────────────────────
  Future<HireRequest> createJob({
    required String customerId,
    required String customerName,
    required String artisanId,
    required String artisanName,
    required String jobDescription,
    required String location,
    double? locationLat,
    double? locationLng,
    required DateTime startDate,
    required DateTime endDate,
    required int dailyHours,
    required List<MaterialItem> materials,
    required List<String> toolsRequired,
  }) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final request = HireRequest(
      id: 'hire-${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      customerName: customerName,
      artisanId: artisanId,
      artisanName: artisanName,
      jobDescription: jobDescription,
      location: location,
      locationLat: locationLat,
      locationLng: locationLng,
      startDate: startDate,
      endDate: endDate,
      dailyHours: dailyHours,
      materials: materials,
      toolsRequired: toolsRequired,
      status: 'pending_artisan',
      createdAt: DateTime.now(),
    );
    _requests.insert(0, request);
    _loading = false;
    notifyListeners();
    return request;
  }

  // ── Fixed: Proper named parameters ──────────────────────────────────────────
  Future<void> artisanRespond({
    required String requestId,
    required double dailyRate,
    required double materialCost,
    required List<DailySchedule> schedule,
    required String notesAr,
    required String notesEn,
  }) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final totalPrice = (dailyRate * schedule.length) + materialCost;
      final response = HireArtisanResponse(
        dailyRate: dailyRate,
        materialCost: materialCost,
        schedule: schedule,
        totalPrice: totalPrice,
        notesAr: notesAr,
        notesEn: notesEn,
      );
      _requests[idx] = _requests[idx].copyWith(
        status: 'pending_customer',
        artisanResponse: response,
        updatedAt: DateTime.now(),
      );
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> customerAccept(String id) async {
    _updateStatus(id, 'accepted');
    notifyListeners();
  }

  Future<void> customerReject(String id) async {
    _updateStatus(id, 'cancelled');
    notifyListeners();
  }

  Future<void> customerConfirmCompletion(String id) async {
    _updateStatus(id, 'completed');
    notifyListeners();
  }

  Future<void> signContract(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final i = _requests.indexWhere((r) => r.id == id);
    if (i != -1) {
      _requests[i] = _requests[i].copyWith(
        contractSigned: true,
        contractSignedAt: DateTime.now(),
        status: 'in_progress',
        updatedAt: DateTime.now(),
      );
    }
    notifyListeners();
  }

  Future<void> simulatePayment(String id) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    await signContract(id);
    _loading = false;
    notifyListeners();
  }

  void _updateStatus(String id, String status) {
    final i = _requests.indexWhere((r) => r.id == id);
    if (i != -1) {
      _requests[i] = _requests[i].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }
}