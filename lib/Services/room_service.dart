import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';

class RoomService {
  final String baseUrl = "http://localhost:3000/api";

  Future<List<Room>> getRooms() async {
    final response = await http.get(Uri.parse("$baseUrl/rooms"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => Room.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load rooms");
    }
  }
}
