import 'package:flutter/material.dart';
import '../../controllers/contract_controller.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../Widgets/custom_app_bar.dart';

class CreateContractView extends StatefulWidget {
  const CreateContractView({super.key});

  @override
  State<CreateContractView> createState() => _CreateContractViewState();
}

class _CreateContractViewState extends State<CreateContractView> {
  final monthlyRentController = TextEditingController();
  List tenants = [];
  List rooms = [];
  int? selectedTenantId;
  int? selectedRoomId;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final tenantResult = await TenantController.getTenants();
    final roomResult = await RoomController.getRooms();

    setState(() {
      if (tenantResult['success']) {
        tenants = tenantResult['data'] is List ? tenantResult['data'] : [];
      }
      if (roomResult['success']) {
        final allRooms = roomResult['data'] is List ? roomResult['data'] : [];
        // Only show available rooms
        rooms = allRooms.where((r) => r['status'] == 'available').toList();
      }
      isLoading = false;
    });
  }

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> handleCreate() async {
    if (selectedTenantId == null || selectedRoomId == null || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final result = await ContractController.createContract(
      tenantId: selectedTenantId!,
      roomId: selectedRoomId!,
      startDate: formatDate(startDate),
      endDate: formatDate(endDate),
      monthlyRent: double.tryParse(monthlyRentController.text) ?? 0,
    );

    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Contract created!' : result['message'] ?? 'Failed'),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Contract'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(Icons.description_rounded, size: 40, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Tenant Dropdown
                          DropdownButtonFormField<int>(
                            value: selectedTenantId,
                            decoration: InputDecoration(
                              labelText: 'Select Tenant',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: tenants.map<DropdownMenuItem<int>>((t) {
                              return DropdownMenuItem<int>(
                                value: t['id'],
                                child: Text(t['user']?['name'] ?? 'Unknown'),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => selectedTenantId = v),
                          ),
                          const SizedBox(height: 20),
                          // Room Dropdown
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
                                child: Text('Room ${r['room_number']} — Rp ${r['price']}'),
                              );
                            }).toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedRoomId = v;
                                // Auto-fill rent from room price
                                final room = rooms.firstWhere((r) => r['id'] == v, orElse: () => null);
                                if (room != null) {
                                  monthlyRentController.text = room['price'].toString();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          // Start Date
                          InkWell(
                            onTap: () => pickDate(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(formatDate(startDate)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // End Date
                          InkWell(
                            onTap: () => pickDate(context, false),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                prefixIcon: const Icon(Icons.event),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(formatDate(endDate)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Monthly Rent
                          TextField(
                            controller: monthlyRentController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Monthly Rent (Rp)',
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
                      onPressed: isSubmitting ? null : handleCreate,
                      icon: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Create Contract'),
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
