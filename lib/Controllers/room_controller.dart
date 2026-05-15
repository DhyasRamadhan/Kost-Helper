import '../services/room_service.dart';

class RoomController {
  static Future<Map<String, dynamic>> getRooms() async {
    try {
      final result = await RoomService.getRooms();

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createRoom({
    required String roomNumber,
    required double price,
  }) async {
    try {
      final result = await RoomService.createRoom(
        roomNumber: roomNumber,
        price: price,
      );

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteRoom(int id) async {
    try {
      final result = await RoomService.deleteRoom(id);

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateRoom(int id, {
    required String roomNumber,
    required double price,
  }) async {
    try {
      final result = await RoomService.updateRoom(
        id,
        roomNumber: roomNumber,
        price: price,
      );

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
