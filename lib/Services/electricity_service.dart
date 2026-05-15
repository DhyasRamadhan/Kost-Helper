import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ElectricityService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getElectricityUsages() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/electricity'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data']};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to load electricity data'};
  }

  static Future<Map<String, dynamic>> createElectricityUsage({
    required int roomId,
    required String usageDate,
    double? meterStart,
    double? meterEnd,
    int? tokenAmount,
  }) async {
    final token = await AuthService.getToken();

    final body = <String, dynamic>{
      'room_id': roomId,
      'usage_date': usageDate,
    };

    if (meterStart != null) body['meter_start'] = meterStart;
    if (meterEnd != null) body['meter_end'] = meterEnd;
    if (tokenAmount != null) body['token_amount'] = tokenAmount;

    final response = await http.post(
      Uri.parse('$baseUrl/electricity'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to create record'};
  }

  static Future<Map<String, dynamic>> deleteElectricityUsage(int id) async {
    final token = await AuthService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/electricity/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to delete'};
  }
}
