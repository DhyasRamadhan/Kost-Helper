import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../config/api_config.dart';

class RoomService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> getRooms() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> createRoom({
    required String roomNumber,
    required double price,
  }) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'room_number': roomNumber, 'price': price}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return {'success': true, 'data': data};
    }

    return {'success': false, 'message': data['message']};
  }

  static Future<Map<String, dynamic>> deleteRoom(int id) async {
    final token = await AuthService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true};
    }

    return {'success': false, 'message': data['message']};
  }
}
