import '../services/tenant_update_service.dart';

class TenantUpdateController {
  static Future<Map<String, dynamic>> submitUpdateRequest({
    required String phone,
    required String address,
    String? originalPhone,
    String? originalAddress,
  }) async {
    try {
      final result = await TenantUpdateService.submitUpdateRequest(
        phone: phone,
        address: address,
        originalPhone: originalPhone,
        originalAddress: originalAddress,
      );

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getUpdateRequests() async {
    try {
      return await TenantUpdateService.getUpdateRequests();
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> approveRequest(int id) async {
    try {
      return await TenantUpdateService.approveRequest(id);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> rejectRequest(int id) async {
    try {
      return await TenantUpdateService.rejectRequest(id);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
