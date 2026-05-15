import 'package:flutter/material.dart';
import '../../../controllers/electricity_controller.dart';
import '../../../controllers/room_controller.dart';
import '../../../Widgets/custom_app_bar.dart';

class AddElectricityView extends StatefulWidget {
  const AddElectricityView({super.key});

  @override
  State<AddElectricityView> createState() => _AddElectricityViewState();
}

class _AddElectricityViewState extends State<AddElectricityView> {
  final meterStartController = TextEditingController();
  final meterEndController = TextEditingController();
  final tokenController = TextEditingController();
  List rooms = [];
  int? selectedRoomId;
  DateTime? usageDate;
  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    final result = await RoomController.getRooms();

    if (result['success']) {
      setState(() {
        rooms = result['data'] is List ? result['data'] : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => usageDate = picked);
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> handleSubmit() async {
    if (selectedRoomId == null || usageDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a room and date'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final result = await ElectricityController.createElectricityUsage(
      roomId: selectedRoomId!,
      usageDate: formatDate(usageDate),
      meterStart: double.tryParse(meterStartController.text),
      meterEnd: double.tryParse(meterEndController.text),
      tokenAmount: int.tryParse(tokenController.text),
    );

    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Electricity usage recorded!' : result['message'] ?? 'Failed'),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Electricity Usage'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    child: const Icon(Icons.electric_meter, size: 40, color: Colors.amber),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: selectedRoomId,
                            decoration: InputDecoration(
                              labelText: 'Select Room',
                              prefixIcon: const Icon(Icons.meeting_room),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: rooms.map<DropdownMenuItem<int>>((r) {
                              return DropdownMenuItem<int>(
                                value: r['id'],
                                child: Text('Room ${r['room_number']}'),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => selectedRoomId = v),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () => pickDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Usage Date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(formatDate(usageDate)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: meterStartController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meter Start',
                              prefixIcon: const Icon(Icons.speed),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: meterEndController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meter End',
                              prefixIcon: const Icon(Icons.speed),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: tokenController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Token Amount (optional)',
                              prefixIcon: const Icon(Icons.numbers),
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
                      onPressed: isSubmitting ? null : handleSubmit,
                      icon: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Record Usage'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
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
