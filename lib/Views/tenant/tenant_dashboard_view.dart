import 'package:flutter/material.dart';
import 'package:Kostify/Widgets/BottomBars/tenant_bottom_bar.dart';
import 'package:Kostify/Widgets/custom_app_bar.dart';
import '../../controllers/dashboard_controller.dart';

class TenantDashboardView extends StatefulWidget {
  const TenantDashboardView({super.key});

  @override
  State<TenantDashboardView> createState() => _TenantDashboardViewState();
}

class _TenantDashboardViewState extends State<TenantDashboardView> {
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
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.dashboard, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, ${dashboardData?['tenant']['name'] ?? '-'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildDashboardCard(
                    title: 'My Room',
                    icon: Icons.meeting_room,
                    content1: 'Room ${dashboardData?['room']?['room_number'] ?? '-'}',
                    content2: 'Status: ${dashboardData?['contract']?['status'] ?? '-'}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Payments',
                    icon: Icons.payment,
                    content1: 'Pending: ${dashboardData?['payments']['pending_count'] ?? 0}',
                    content2: 'Paid: ${dashboardData?['payments']['paid_count'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Electricity Usage',
                    icon: Icons.electric_bolt,
                    content1: 'Usage: ${dashboardData?['electricity_usage']?['usage_kwh'] ?? 0} kWh',
                    content2: 'Bill: Rp ${dashboardData?['electricity_usage']?['estimate_bill'] ?? 0}',
                  ),
                ],
              ),
            ),
          ),
      bottomNavigationBar: const TenantBottomBar(currentIndex: 0),
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
