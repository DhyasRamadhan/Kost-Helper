import 'dart:convert';

import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../config/api_config.dart';

class DashboardService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getDashboard() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }
}
