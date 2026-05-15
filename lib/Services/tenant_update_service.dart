import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class TenantUpdateService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// Submit a single field update request (matches backend: field_name + new_value)
  static Future<Map<String, dynamic>> submitFieldUpdate({
    required String fieldName,
    required String newValue,
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
        'field_name': fieldName,
        'new_value': newValue,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message'] ?? 'Request failed'};
  }

  /// Submit multiple field updates (calls API once per changed field)
  static Future<Map<String, dynamic>> submitUpdateRequest({
    required String phone,
    required String address,
    String? originalPhone,
    String? originalAddress,
  }) async {
    final List<String> errors = [];
    int submitted = 0;

    // Only submit fields that actually changed
    if (phone.isNotEmpty && phone != (originalPhone ?? '')) {
      final result = await submitFieldUpdate(fieldName: 'phone', newValue: phone);
      if (result['success']) {
        submitted++;
      } else {
        errors.add(result['message'] ?? 'Failed to update phone');
      }
    }

    if (address.isNotEmpty && address != (originalAddress ?? '')) {
      final result = await submitFieldUpdate(fieldName: 'address', newValue: address);
      if (result['success']) {
        submitted++;
      } else {
        errors.add(result['message'] ?? 'Failed to update address');
      }
    }

    if (submitted == 0 && errors.isEmpty) {
      return {'success': false, 'message': 'No fields were changed'};
    }

    if (errors.isNotEmpty) {
      return {'success': false, 'message': errors.join(', ')};
    }

    return {'success': true, 'message': '$submitted update request(s) submitted'};
  }

  /// Get all update requests (owner only)
  static Future<Map<String, dynamic>> getUpdateRequests() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/tenant/update-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data['data']};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to load requests'};
  }

  /// Approve an update request (owner only)
  static Future<Map<String, dynamic>> approveRequest(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/tenant/update-requests/$id/approve'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to approve'};
  }

  /// Reject an update request (owner only)
  static Future<Map<String, dynamic>> rejectRequest(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/tenant/update-requests/$id/reject'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message'] ?? 'Failed to reject'};
  }
}
