import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_service.dart';

class OwnerVerificationService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getPendingOwners() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/owners/pending'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> approveOwner(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/owners/$id/approve'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> rejectOwner(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/owners/$id/reject'),

      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true};
    }

    return {'success': false, 'message': data['message']};
  }
}
