import 'package:flutter/material.dart';
import '../../../controllers/room_controller.dart';
import '../../../widgets/custom_app_bar.dart';

class EditRoomView extends StatefulWidget {
  final Map<String, dynamic> room;

  const EditRoomView({super.key, required this.room});

  @override
  State<EditRoomView> createState() => _EditRoomViewState();
}

class _EditRoomViewState extends State<EditRoomView> {
  final roomNumberController = TextEditingController();
  final priceController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    roomNumberController.text = widget.room['room_number']?.toString() ?? '';
    priceController.text = widget.room['price']?.toString() ?? '';
  }

  Future<void> handleUpdateRoom() async {
    setState(() => isLoading = true);

    final result = await RoomController.updateRoom(
      widget.room['id'],
      roomNumber: roomNumberController.text,
      price: double.parse(priceController.text),
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Room updated successfully' : result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Room'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(Icons.edit_rounded, size: 40, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: roomNumberController,
                      decoration: InputDecoration(
                        labelText: 'Room Number',
                        prefixIcon: const Icon(Icons.meeting_room),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (Rp)',
                        prefixIcon: const Icon(Icons.payments),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : handleUpdateRoom,
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
