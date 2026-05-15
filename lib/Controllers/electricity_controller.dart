import '../services/electricity_service.dart';

class ElectricityController {
  static Future<Map<String, dynamic>> getElectricityUsages() async {
    try {
      return await ElectricityService.getElectricityUsages();
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createElectricityUsage({
    required int roomId,
    required String usageDate,
    double? meterStart,
    double? meterEnd,
    int? tokenAmount,
  }) async {
    try {
      return await ElectricityService.createElectricityUsage(
        roomId: roomId,
        usageDate: usageDate,
        meterStart: meterStart,
        meterEnd: meterEnd,
        tokenAmount: tokenAmount,
      );
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteElectricityUsage(int id) async {
    try {
      return await ElectricityService.deleteElectricityUsage(id);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
