import '../services/dashboard_service.dart';

class DashboardController {
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final result = await DashboardService.getDashboard();

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
