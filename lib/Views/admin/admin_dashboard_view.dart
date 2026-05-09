import 'package:flutter/material.dart';

import '../../Widgets/custom_app_bar.dart';
import '../../controllers/admin_controller.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  List owners = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadOwners();
  }

  Future<void> loadOwners() async {
    final result = await AdminController.getPendingOwners();

    if (result['success']) {
      setState(() {
        owners = result['data']['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> approveOwner(int id) async {
    await AdminController.approveOwner(id);

    loadOwners();
  }

  Future<void> rejectOwner(int id) async {
    await AdminController.rejectOwner(id);

    loadOwners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: owners.length,

              itemBuilder: (context, index) {
                final owner = owners[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          owner['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(owner['email']),

                        Text(owner['phone']),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  approveOwner(owner['id']);
                                },

                                child: const Text('Approve'),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  rejectOwner(owner['id']);
                                },

                                child: const Text('Reject'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
