import 'package:flutter/material.dart';

import '../../Widgets/custom_app_bar.dart';
import '../../controllers/admin_controller.dart';
import '../../services/auth_service.dart';
import '../auth/login_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  List pendingOwners = [];
  List historyOwners = [];

  bool isLoadingPending = true;
  bool isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    loadPendingOwners();
    loadHistoryOwners();
  }

  Future<void> loadPendingOwners() async {
    setState(() {
      isLoadingPending = true;
    });
    final result = await AdminController.getPendingOwners();

    if (result['success']) {
      setState(() {
        pendingOwners = result['data']['data'];
        isLoadingPending = false;
      });
    } else {
      setState(() {
        isLoadingPending = false;
      });
    }
  }

  Future<void> loadHistoryOwners() async {
    setState(() {
      isLoadingHistory = true;
    });
    final result = await AdminController.getHistoryOwners();

    if (result['success']) {
      setState(() {
        historyOwners = result['data']['data'];
        isLoadingHistory = false;
      });
    } else {
      setState(() {
        isLoadingHistory = false;
      });
    }
  }

  Future<void> approveOwner(int id) async {
    await AdminController.approveOwner(id);
    loadPendingOwners();
    loadHistoryOwners();
  }

  Future<void> rejectOwner(int id) async {
    await AdminController.rejectOwner(id);
    loadPendingOwners();
    loadHistoryOwners();
  }

  Widget _buildPendingList() {
    if (isLoadingPending) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pendingOwners.isEmpty) {
      return const Center(child: Text('No pending owners'));
    }

    return ListView.builder(
      itemCount: pendingOwners.length,
      itemBuilder: (context, index) {
        final owner = pendingOwners[index];

        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner['name']?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(owner['email']?.toString() ?? '-'),
                Text(owner['phone']?.toString() ?? '-'),
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
    );
  }

  Widget _buildHistoryList() {
    if (isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyOwners.isEmpty) {
      return const Center(child: Text('No history available'));
    }

    return ListView.builder(
      itemCount: historyOwners.length,
      itemBuilder: (context, index) {
        final owner = historyOwners[index];

        final status = owner['verification_status'] ?? 'unknown';
        final isApproved = status == 'approved';

        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      owner['name']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isApproved ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toString().toUpperCase(),
                        style: TextStyle(
                          color: isApproved ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(owner['email']?.toString() ?? '-'),
                Text(owner['phone']?.toString() ?? '-'),
                if (!isApproved && owner['rejected_reason'] != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Reason: ${owner['rejected_reason']}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Dashboard',
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'History'),
            ],
          ),
        ),
        
        body: TabBarView(
          children: [
            _buildPendingList(),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }
}
