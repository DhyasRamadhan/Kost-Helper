import '../services/tenant_service.dart';

class TenantController {
  static Future<Map<String, dynamic>> getTenants() async {
    try {
      return await TenantService.getTenants();
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
