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

  static Future<Map<String, dynamic>> getPaymentToken(int id) async {
    try {
      return await PaymentService.getPaymentToken(id);
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

  static Future<Map<String, dynamic>> createPayment(int contractId) async {
    try {
      return await PaymentService.createPayment(contractId);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
