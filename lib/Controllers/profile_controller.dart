import '../services/profile_service.dart';

class ProfileController {
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final result = await ProfileService.getProfile();
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
