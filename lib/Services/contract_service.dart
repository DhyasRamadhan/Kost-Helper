import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ContractService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getContracts() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/contracts'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data']};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to load contracts'};
  }

  static Future<Map<String, dynamic>> createContract({
    required int tenantId,
    required int roomId,
    required String startDate,
    required String endDate,
    required double monthlyRent,
  }) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/contracts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tenant_id': tenantId,
        'room_id': roomId,
        'start_date': startDate,
        'end_date': endDate,
        'monthly_rent': monthlyRent,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to create contract'};
  }

  static Future<Map<String, dynamic>> deleteContract(int id) async {
    final token = await AuthService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/contracts/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to delete contract'};
  }
}
