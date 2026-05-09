import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class TenantUpdateService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> submitUpdateRequest({
    required String phone,
    required String address,
    required String emergencyContact,
    required String notes,
  }) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/tenant/update-request'),

      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'phone': phone,
        'address': address,
        'emergency_contact': emergencyContact,
        'notes': notes,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }
}
