import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class PaymentService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getPayments() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/payments'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> getTenantPayments() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/tenant/payments'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> cancelPayment(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/payments/$id/cancel'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }
}
