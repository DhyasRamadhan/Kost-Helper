import '../services/tenant_update_service.dart';

class TenantUpdateController {
  static Future<Map<String, dynamic>> submitUpdateRequest({
    required String phone,
    required String address,
    required String emergencyContact,
    required String notes,
  }) async {
    try {
      final result = await TenantUpdateService.submitUpdateRequest(
        phone: phone,
        address: address,
        emergencyContact: emergencyContact,
        notes: notes,
      );

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
