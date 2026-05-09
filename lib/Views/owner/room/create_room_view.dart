import 'package:flutter/material.dart';

import '../../../controllers/room_controller.dart';

class CreateRoomView extends StatefulWidget {
  const CreateRoomView({super.key});

  @override
  State<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<CreateRoomView> {
  final roomNumberController = TextEditingController();
  final priceController = TextEditingController();

  bool isLoading = false;

  Future<void> handleCreateRoom() async {
    setState(() {
      isLoading = true;
    });

    final result = await RoomController.createRoom(
      roomNumber: roomNumberController.text,
      price: double.parse(priceController.text),
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Room created successfully' : result['message'],
        ),
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: roomNumberController,

              decoration: const InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : handleCreateRoom,

                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Room'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
