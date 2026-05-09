import '../services/payment_service.dart';

class PaymentController {
  static Future<Map<String, dynamic>> getPayments() async {
    try {
      final result = await PaymentService.getPayments();

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getTenantPayments() async {
    try {
      final result = await PaymentService.getTenantPayments();

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> cancelPayment(int id) async {
    try {
      final result = await PaymentService.cancelPayment(id);

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
