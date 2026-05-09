import 'package:flutter/material.dart';

import '../../../controllers/room_controller.dart';
import 'create_room_view.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  List rooms = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadRooms();
  }

  Future<void> loadRooms() async {
    final result = await RoomController.getRooms();

    if (result['success']) {
      setState(() {
        rooms = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteRoom(int id) async {
    await RoomController.deleteRoom(id);

    loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rooms')),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRoomView()),
          );

          loadRooms();
        },

        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rooms.length,

              itemBuilder: (context, index) {
                final room = rooms[index];

                return Card(
                  child: ListTile(
                    title: Text(room['room_number']),

                    subtitle: Text('Rp ${room['price']}'),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),

                      onPressed: () {
                        deleteRoom(room['id']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
