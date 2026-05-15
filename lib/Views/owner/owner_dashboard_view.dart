import 'package:flutter/material.dart';
import '../../Widgets/BottomBars/owner_bottom_bar.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../controllers/dashboard_controller.dart';
import '../contract/contract_list_view.dart';
import 'electricity/electricity_list_view.dart';
import 'tenant/tenant_update_requests_view.dart';

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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.admin_panel_settings, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome Owner',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildDashboardCard(
                    title: 'Rooms',
                    icon: Icons.meeting_room,
                    content1: 'Total: ${dashboardData?['rooms']?['total'] ?? 0}',
                    content2: 'Occupied: ${dashboardData?['rooms']?['occupied'] ?? 0} | Available: ${dashboardData?['rooms']?['available'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Tenants & Contracts',
                    icon: Icons.people,
                    content1: 'Total Tenants: ${dashboardData?['tenants']?['total'] ?? 0}',
                    content2: 'Active Contracts: ${dashboardData?['contracts']?['active'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Finances',
                    icon: Icons.attach_money,
                    content1: 'Total Income: Rp ${dashboardData?['payments']?['total_income'] ?? 0}',
                    content2: 'Pending Payments: ${dashboardData?['payments']?['pending_payments'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Electricity',
                    icon: Icons.electric_bolt,
                    content1: 'Total Estimated Bill',
                    content2: 'Rp ${dashboardData?['electricity']?['total_estimated_bill'] ?? 0}',
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ContractListView()),
                        );
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('Manage Contracts'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ElectricityListView()),
                        );
                      },
                      icon: const Icon(Icons.electric_bolt),
                      label: const Text('Electricity Management'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TenantUpdateRequestsView()),
                        );
                      },
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Tenant Update Requests'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const OwnerBottomBar(currentIndex: 0),
    );
  }

  Widget _buildDashboardCard({required String title, required IconData icon, required String content1, required String content2}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(content1, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(content2, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
