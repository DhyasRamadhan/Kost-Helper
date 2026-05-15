import '../services/contract_service.dart';

class ContractController {
  static Future<Map<String, dynamic>> getContracts() async {
    try {
      return await ContractService.getContracts();
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createContract({
    required int tenantId,
    required int roomId,
    required String startDate,
    required String endDate,
    required double monthlyRent,
  }) async {
    try {
      return await ContractService.createContract(
        tenantId: tenantId,
        roomId: roomId,
        startDate: startDate,
        endDate: endDate,
        monthlyRent: monthlyRent,
      );
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteContract(int id) async {
    try {
      return await ContractService.deleteContract(id);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
