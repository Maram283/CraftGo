// ============================================================
// CustomOrderProvider — Manages templates and requests
// Uses ChangeNotifier for Provider integration
// ============================================================

import 'package:flutter/material.dart';
import 'custom_order_template.dart';
import 'custom_order_request.dart';

class CustomOrderProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────────────────
  bool _loading = false;
  String? _error;
  bool get isLoading => _loading;
  String? get error => _error;

  final List<CustomOrderTemplate> _templates = [];
  final List<CustomOrderRequest> _requests = [];

  List<CustomOrderTemplate> get templates => List.unmodifiable(_templates);
  List<CustomOrderRequest> get requests => List.unmodifiable(_requests);

  // ── Filtered Getters ──────────────────────────────────────────────────────
  List<CustomOrderTemplate> templatesFor(String artisanId) =>
      _templates.where((t) => t.artisanId == artisanId).toList();

  List<CustomOrderRequest> requestsForCustomer(String customerId) =>
      _requests.where((r) => r.customerId == customerId).toList();

  List<CustomOrderRequest> requestsForArtisan(String artisanId) =>
      _requests.where((r) => r.artisanId == artisanId).toList();

  List<CustomOrderRequest> get pendingForArtisan =>
      _requests.where((r) => r.status == 'pending_artisan').toList();

  List<CustomOrderRequest> get pendingForCustomer =>
      _requests.where((r) => r.status == 'pending_customer').toList();

  CustomOrderRequest? findRequest(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Init ──────────────────────────────────────────────────────────────────
  CustomOrderProvider() {
    _seedMockData();
  }

  void _seedMockData() {
    _templates.addAll([
      CustomOrderTemplate(
        id: 'tmpl-001',
        artisanId: 'artisan-amjad',
        artisanName: 'أمجد الخطيب',
        titleAr: 'قطعة خشبية مخصصة',
        titleEn: 'Custom Woodwork Piece',
        categoryAr: 'أعمال خشبية',
        categoryEn: 'Woodwork',
        descriptionAr: 'اطلب أي قطعة خشبية حسب مواصفاتك الخاصة.',
        descriptionEn: 'Order any wooden piece to your exact specifications.',
        basePrice: 60.0,
        estimatedDays: 7,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        fields: const [
          TemplateField(
            id: 'piece_type',
            type: 'dropdown',
            labelAr: 'نوع القطعة',
            labelEn: 'Piece Type',
            required: true,
            options: ['صندوق / Box', 'رف / Shelf', 'إطار / Frame', 'طاولة / Table', 'أخرى / Other'],
          ),
          TemplateField(
            id: 'wood_type',
            type: 'dropdown',
            labelAr: 'نوع الخشب',
            labelEn: 'Wood Type',
            required: true,
            options: ['خشب الزيتون / Olive', 'الجوز / Walnut', 'الصنوبر / Pine', 'البلوط / Oak'],
          ),
          TemplateField(
            id: 'dimensions',
            type: 'dimensions',
            labelAr: 'الأبعاد (ط × ع × ار)',
            labelEn: 'Dimensions (L × W × H)',
            required: true,
          ),
          TemplateField(
            id: 'engrave',
            type: 'checkbox',
            labelAr: 'هل تريد نقشاً؟',
            labelEn: 'Add engraving?',
          ),
          TemplateField(
            id: 'engraving_text',
            type: 'text',
            labelAr: 'نص النقش (اختياري)',
            labelEn: 'Engraving text (optional)',
          ),
          TemplateField(
            id: 'reference',
            type: 'image_upload',
            labelAr: 'صور مرجعية',
            labelEn: 'Reference images',
            maxImages: 3,
          ),
          TemplateField(
            id: 'notes',
            type: 'textarea',
            labelAr: 'ملاحظات إضافية',
            labelEn: 'Additional notes',
          ),
        ],
      ),
      CustomOrderTemplate(
        id: 'tmpl-002',
        artisanId: 'artisan-fatima',
        artisanName: 'فاطمة محمود',
        titleAr: 'تطريز مخصص',
        titleEn: 'Custom Embroidery',
        categoryAr: 'تطريز',
        categoryEn: 'Embroidery',
        descriptionAr: 'اطلب قطعة تطريز فلسطيني أصيل بألوانك وأبعادك.',
        descriptionEn: 'Order authentic Palestinian embroidery in your colors and size.',
        basePrice: 35.0,
        estimatedDays: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        fields: const [
          TemplateField(
            id: 'item_type',
            type: 'dropdown',
            labelAr: 'نوع القطعة',
            labelEn: 'Item type',
            required: true,
            options: ['وشاح / Scarf', 'مفرش / Tablecloth', 'وسادة / Cushion', 'حقيبة / Bag'],
          ),
          TemplateField(
            id: 'size',
            type: 'dropdown',
            labelAr: 'المقاس',
            labelEn: 'Size',
            required: true,
            options: ['صغير / Small', 'وسط / Medium', 'كبير / Large'],
          ),
          TemplateField(
            id: 'color_scheme',
            type: 'color_picker',
            labelAr: 'اللون الرئيسي',
            labelEn: 'Primary color',
            required: true,
          ),
          TemplateField(
            id: 'pattern',
            type: 'dropdown',
            labelAr: 'نمط التطريز',
            labelEn: 'Embroidery pattern',
            options: ['تقليدي / Traditional', 'حديث / Modern', 'هندسي / Geometric', 'زهري / Floral'],
          ),
          TemplateField(
            id: 'notes',
            type: 'textarea',
            labelAr: 'ملاحظات',
            labelEn: 'Notes',
          ),
        ],
      ),
    ]);

    // Seed one request so the inbox has data
    _requests.add(CustomOrderRequest(
      id: 'req-001',
      templateId: 'tmpl-001',
      templateTitleAr: 'قطعة خشبية مخصصة',
      templateTitleEn: 'Custom Woodwork Piece',
      customerId: 'customer-demo',
      customerName: 'أحمد محمد',
      artisanId: 'artisan-amjad',
      artisanName: 'أمجد الخطيب',
      status: 'pending_artisan',
      filledFields: {
        'piece_type': 'صندوق / Box',
        'wood_type': 'خشب الزيتون / Olive',
        'dimensions': '30 × 20 × 15',
        'engrave': true,
        'engraving_text': 'هدية بمناسبة الزفاف',
        'notes': 'أريد أن يكون اللون داكناً مع لمسة من الذهب على الحواف.',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ));

    _requests.add(CustomOrderRequest(
      id: 'req-002',
      templateId: 'tmpl-002',
      templateTitleAr: 'تطريز مخصص',
      templateTitleEn: 'Custom Embroidery',
      customerId: 'customer-demo2',
      customerName: 'ليلى حسن',
      artisanId: 'artisan-fatima',
      artisanName: 'فاطمة محمود',
      status: 'pending_artisan',
      filledFields: {
        'item_type': 'وشاح / Scarf',
        'size': 'وسط / Medium',
        'color_scheme': '#8B0000',
        'pattern': 'تقليدي / Traditional',
        'notes': 'أريد وشاحاً حريرياً بنقوش حمراء وذهبية.',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ));
  }

  // ── Template CRUD ─────────────────────────────────────────────────────────
  Future<void> addTemplate(CustomOrderTemplate t) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _templates.insert(0, t);
    _loading = false;
    notifyListeners();
  }

  Future<void> updateTemplate(CustomOrderTemplate updated) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    final i = _templates.indexWhere((t) => t.id == updated.id);
    if (i != -1) _templates[i] = updated;
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteTemplate(String id) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _templates.removeWhere((t) => t.id == id);
    _loading = false;
    notifyListeners();
  }

  // ── Customer Actions ──────────────────────────────────────────────────────
  Future<CustomOrderRequest> submitRequest({
    required CustomOrderTemplate template,
    required Map<String, dynamic> filledFields,
    required String customerId,
    required String customerName,
  }) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final req = CustomOrderRequest(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      templateId: template.id,
      templateTitleAr: template.titleAr,
      templateTitleEn: template.titleEn,
      customerId: customerId,
      customerName: customerName,
      artisanId: template.artisanId,
      artisanName: template.artisanName,
      status: 'pending_artisan',
      filledFields: filledFields,
      createdAt: DateTime.now(),
    );

    _requests.insert(0, req);
    _loading = false;
    notifyListeners();
    return req;
  }

  Future<void> customerAccept(String requestId) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _updateStatus(requestId, 'in_progress');
    _loading = false;
    notifyListeners();
  }

  Future<void> customerReject(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _updateStatus(requestId, 'rejected');
    notifyListeners();
  }

  Future<void> customerCancel(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _updateStatus(requestId, 'cancelled');
    notifyListeners();
  }

  // ── Artisan Actions ──────────────────────────────────────────────────────
  Future<void> artisanRespond({
    required String requestId,
    required List<PriceRow> breakdown,
    required List<String> tasks,
    required DateTime deliveryDate,
    required String notesAr,
    required String notesEn,
  }) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final response = ArtisanResponse(
        breakdown: breakdown,
        tasks: tasks,
        deliveryDate: deliveryDate,
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

  Future<void> artisanUpdateStatus(String requestId, String status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _updateStatus(requestId, status);
    notifyListeners();
  }
  Future<void> deleteAllTemplatesForArtisan(String artisanId) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _templates.removeWhere((t) => t.artisanId == artisanId);
    _loading = false;
    notifyListeners();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  void _updateStatus(String requestId, String status) {
    final i = _requests.indexWhere((r) => r.id == requestId);
    if (i != -1) {
      _requests[i] = _requests[i].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  // ── Sign Contract ──────────────────────────────────────────────────────
  Future<void> signContract(String requestId) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    final i = _requests.indexWhere((r) => r.id == requestId);
    if (i != -1) {
      _requests[i] = _requests[i].copyWith(
        contractSigned: true,
        contractSignedAt: DateTime.now(),
        status: 'in_progress',
        updatedAt: DateTime.now(),
      );
    }
    _loading = false;
    notifyListeners();
  }

  // ── Payment Simulation ──────────────────────────────────────────────────
  Future<void> simulatePayment(String requestId) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    // Payment successful — mark contract signed
    await signContract(requestId);
    _loading = false;
    notifyListeners();
  }
}



// // lib/providers/custom_order_provider.dart
// import 'package:flutter/material.dart';
// import '../models/custom_order_template.dart';
// import '../models/custom_order_request.dart';
//
// class CustomOrderProvider extends ChangeNotifier {
//   // ── State ─────────────────────────────────────────────────────────────────
//   bool _loading = false;
//   String? _error;
//   bool get isLoading => _loading;
//   String? get error => _error;
//
//   final List<CustomOrderTemplate> _templates = [];
//   final List<CustomOrderRequest>  _requests  = [];
//
//   List<CustomOrderTemplate> get templates => List.unmodifiable(_templates);
//   List<CustomOrderRequest>  get requests  => List.unmodifiable(_requests);
//
//   // Filtered getters
//   List<CustomOrderTemplate> templatesFor(String artisanId) =>
//       _templates.where((t) => t.artisanId == artisanId).toList();
//
//   List<CustomOrderRequest> requestsForCustomer(String customerId) =>
//       _requests.where((r) => r.customerId == customerId).toList();
//
//   List<CustomOrderRequest> requestsForArtisan(String artisanId) =>
//       _requests.where((r) => r.artisanId == artisanId).toList();
//
//   List<CustomOrderRequest> get pendingForArtisan =>
//       _requests.where((r) => r.status == 'pending_artisan').toList();
//
//   // ── Init ──────────────────────────────────────────────────────────────────
//   CustomOrderProvider() {
//     _seedMockData();
//   }
//
//   void _seedMockData() {
//     _templates.addAll([
//       CustomOrderTemplate(
//         id: 'tmpl-001',
//         artisanId: 'artisan-amjad',
//         artisanName: 'أمجد الخطيب',
//         titleAr: 'قطعة خشبية مخصصة',
//         titleEn: 'Custom Woodwork Piece',
//         categoryAr: 'أعمال خشبية',
//         categoryEn: 'Woodwork',
//         descriptionAr: 'اطلب أي قطعة خشبية حسب مواصفاتك الخاصة.',
//         descriptionEn: 'Order any wooden piece to your exact specifications.',
//         basePrice: 60.0,
//         estimatedDays: 7,
//         createdAt: DateTime.now().subtract(const Duration(days: 10)),
//         fields: const [
//           TemplateField(
//             id: 'piece_type', type: 'dropdown',
//             labelAr: 'نوع القطعة', labelEn: 'Piece Type',
//             required: true,
//             options: ['صندوق / Box', 'رف / Shelf', 'إطار / Frame', 'طاولة / Table', 'أخرى / Other'],
//           ),
//           TemplateField(
//             id: 'wood_type', type: 'dropdown',
//             labelAr: 'نوع الخشب', labelEn: 'Wood Type',
//             required: true,
//             options: ['خشب الزيتون / Olive', 'الجوز / Walnut', 'الصنوبر / Pine', 'البلوط / Oak'],
//           ),
//           TemplateField(
//             id: 'dimensions', type: 'dimensions',
//             labelAr: 'الأبعاد (ط × ع × ار)', labelEn: 'Dimensions (L × W × H)',
//             required: true,
//           ),
//           TemplateField(
//             id: 'engrave', type: 'checkbox',
//             labelAr: 'هل تريد نقشاً؟', labelEn: 'Add engraving?',
//           ),
//           TemplateField(
//             id: 'engraving_text', type: 'text',
//             labelAr: 'نص النقش (اختياري)', labelEn: 'Engraving text (optional)',
//           ),
//           TemplateField(
//             id: 'reference', type: 'image_upload',
//             labelAr: 'صور مرجعية', labelEn: 'Reference images',
//             maxImages: 3,
//           ),
//           TemplateField(
//             id: 'notes', type: 'textarea',
//             labelAr: 'ملاحظات إضافية', labelEn: 'Additional notes',
//           ),
//         ],
//       ),
//
//       CustomOrderTemplate(
//         id: 'tmpl-002',
//         artisanId: 'artisan-fatima',
//         artisanName: 'فاطمة محمود',
//         titleAr: 'تطريز مخصص',
//         titleEn: 'Custom Embroidery',
//         categoryAr: 'تطريز',
//         categoryEn: 'Embroidery',
//         descriptionAr: 'اطلب قطعة تطريز فلسطيني أصيل بألوانك وأبعادك.',
//         descriptionEn: 'Order authentic Palestinian embroidery in your colors and size.',
//         basePrice: 35.0,
//         estimatedDays: 5,
//         createdAt: DateTime.now().subtract(const Duration(days: 5)),
//         fields: const [
//           TemplateField(
//             id: 'item_type', type: 'dropdown',
//             labelAr: 'نوع القطعة', labelEn: 'Item type',
//             required: true,
//             options: ['وشاح / Scarf', 'مفرش / Tablecloth', 'وسادة / Cushion', 'حقيبة / Bag'],
//           ),
//           TemplateField(
//             id: 'size', type: 'dropdown',
//             labelAr: 'المقاس', labelEn: 'Size',
//             required: true,
//             options: ['صغير / Small', 'وسط / Medium', 'كبير / Large'],
//           ),
//           TemplateField(
//             id: 'color_scheme', type: 'color_picker',
//             labelAr: 'اللون الرئيسي', labelEn: 'Primary color',
//             required: true,
//           ),
//           TemplateField(
//             id: 'pattern', type: 'dropdown',
//             labelAr: 'نمط التطريز', labelEn: 'Embroidery pattern',
//             options: ['تقليدي / Traditional', 'حديث / Modern', 'هندسي / Geometric', 'زهري / Floral'],
//           ),
//           TemplateField(
//             id: 'notes', type: 'textarea',
//             labelAr: 'ملاحظات', labelEn: 'Notes',
//           ),
//         ],
//       ),
//     ]);
//
//     // One existing request so the inbox isn't empty on first load
//     _requests.add(CustomOrderRequest(
//       id: 'req-001',
//       templateId: 'tmpl-001',
//       templateTitleAr: 'قطعة خشبية مخصصة',
//       templateTitleEn: 'Custom Woodwork Piece',
//       customerId: 'customer-demo',
//       customerName: 'أحمد محمد',
//       artisanId: 'artisan-amjad',
//       artisanName: 'أمجد الخطيب',
//       status: 'pending_artisan',
//       filledFields: const {
//         'piece_type': 'صندوق / Box',
//         'wood_type': 'خشب الزيتون / Olive',
//         'dimensions': '30 × 20 × 15',
//         'engrave': true,
//         'engraving_text': 'هدية بمناسبة الزفاف',
//         'notes': 'أريد أن يكون اللون داكناً مع لمسة من الذهب على الحواف.',
//       },
//       createdAt: DateTime.now().subtract(const Duration(hours: 3)),
//     ));
//   }
//
//   // ── Template CRUD ─────────────────────────────────────────────────────────
//
//   Future<void> addTemplate(CustomOrderTemplate t) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 600));
//     _templates.insert(0, t);
//     _loading = false; notifyListeners();
//   }
//
//   Future<void> updateTemplate(CustomOrderTemplate updated) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 500));
//     final i = _templates.indexWhere((t) => t.id == updated.id);
//     if (i != -1) _templates[i] = updated;
//     _loading = false; notifyListeners();
//   }
//
//   Future<void> deleteTemplate(String id) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 400));
//     _templates.removeWhere((t) => t.id == id);
//     _loading = false; notifyListeners();
//   }
//
//   // ── Customer actions ──────────────────────────────────────────────────────
//
//   Future<CustomOrderRequest> submitRequest({
//     required CustomOrderTemplate template,
//     required Map<String, dynamic> filledFields,
//     required String customerId,
//     required String customerName,
//   }) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     final req = CustomOrderRequest(
//       id: 'req-${DateTime.now().millisecondsSinceEpoch}',
//       templateId: template.id,
//       templateTitleAr: template.titleAr,
//       templateTitleEn: template.titleEn,
//       customerId: customerId,
//       customerName: customerName,
//       artisanId: template.artisanId,
//       artisanName: template.artisanName,
//       status: 'pending_artisan',
//       filledFields: filledFields,
//       createdAt: DateTime.now(),
//     );
//
//     _requests.insert(0, req);
//     _loading = false; notifyListeners();
//     return req;
//   }
//
//   Future<void> customerAccept(String requestId) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 700));
//     _updateStatus(requestId, 'in_progress');
//     _loading = false; notifyListeners();
//   }
//
//   Future<void> customerReject(String requestId) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _updateStatus(requestId, 'cancelled');
//     notifyListeners();
//   }
//
//   // ── Artisan actions ───────────────────────────────────────────────────────
//
//   Future<void> artisanRespond({
//     required String requestId,
//     required List<PriceRow> breakdown,
//     required List<String> tasks,
//     required DateTime deliveryDate,
//     required String notesAr,
//     required String notesEn,
//   }) async {
//     _loading = true; notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     final idx = _requests.indexWhere((r) => r.id == requestId);
//     if (idx != -1) {
//       _requests[idx] = _requests[idx].copyWith(
//         status: 'pending_customer',
//         artisanResponse: ArtisanResponse(
//           breakdown: breakdown,
//           tasks: tasks,
//           deliveryDate: deliveryDate,
//           notesAr: notesAr,
//           notesEn: notesEn,
//         ),
//         updatedAt: DateTime.now(),
//       );
//     }
//     _loading = false; notifyListeners();
//   }
//
//   Future<void> artisanUpdateStatus(String requestId, String status) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _updateStatus(requestId, status);
//     notifyListeners();
//   }
//
//   // ── Helpers ───────────────────────────────────────────────────────────────
//
//   void _updateStatus(String requestId, String status) {
//     final i = _requests.indexWhere((r) => r.id == requestId);
//     if (i != -1) _requests[i] = _requests[i].copyWith(status: status);
//   }
//
//   CustomOrderRequest? findRequest(String id) =>
//       _requests.cast<CustomOrderRequest?>().firstWhere(
//           (r) => r?.id == id, orElse: () => null);
// }
