import '../services/owner_verification_service.dart';

class AdminController {
  static Future<Map<String, dynamic>> getPendingOwners() async {
    try {
      final result = await OwnerVerificationService.getPendingOwners();

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> approveOwner(int id) async {
    try {
      final result = await OwnerVerificationService.approveOwner(id);

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> rejectOwner(int id) async {
    try {
      final result = await OwnerVerificationService.rejectOwner(id);

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
