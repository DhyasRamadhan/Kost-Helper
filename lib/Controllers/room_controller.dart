import '../models/room.dart';
import '../Services/room_service.dart';

class RoomController {
  final RoomService _service = RoomService();

  Future<List<Room>> fetchRooms() async {
    return await _service.getRooms();
  }
}
