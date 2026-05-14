import 'package:flutter/material.dart';

import '../../Widgets/BottomBars/owner_bottom_bar.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../controllers/dashboard_controller.dart';
import 'room/room_list_view.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  Map<String, dynamic>? dashboardData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final result = await DashboardController.getDashboard();

    if (result['success']) {
      setState(() {
        dashboardData = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Role: ${dashboardData?['role']}',
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  if (dashboardData?['role'] == 'owner') ...[
                    Text('Total Rooms: ${dashboardData?['rooms']['total']}'),

                    Text(
                      'Occupied Rooms: ${dashboardData?['rooms']['occupied']}',
                    ),

                    Text(
                      'Available Rooms: ${dashboardData?['rooms']['available']}',
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoomListView(),
                            ),
                          );
                        },

                        child: const Text('Manage Rooms'),
                      ),
                    ),
                  ],

                  if (dashboardData?['role'] == 'tenant') ...[
                    Text(
                      'Welcome Tenant',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ],
              ),
            ),

      bottomNavigationBar: OwnerBottomBar(currentIndex: 0),
    );
  }
}
