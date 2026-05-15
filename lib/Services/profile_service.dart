import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ProfileService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data']};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to load profile'};
  }
}
