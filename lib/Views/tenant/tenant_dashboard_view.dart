import 'package:flutter/material.dart';
import 'package:kost_helper/Widgets/BottomBars/tenant_bottom_bar.dart';
import 'package:kost_helper/Widgets/custom_app_bar.dart';
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
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Welcome, ${dashboardData?['tenant']['name']}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'My Room',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    child: ListTile(
                      title: Text(
                        dashboardData?['room']?['room_number'] ?? '-',
                      ),

                      subtitle: Text(
                        'Status Contract: '
                        '${dashboardData?['contract']?['status'] ?? '-'}',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Payments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    child: ListTile(
                      title: Text(
                        'Pending Payments: '
                        '${dashboardData?['payments']['pending_count']}',
                      ),

                      subtitle: Text(
                        'Paid Payments: '
                        '${dashboardData?['payments']['paid_count']}',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Electricity Usage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    child: ListTile(
                      title: Text(
                        'Usage: '
                        '${dashboardData?['electricity_usage']?['usage_kwh'] ?? 0} kWh',
                      ),

                      subtitle: Text(
                        'Estimated Bill: Rp '
                        '${dashboardData?['electricity_usage']?['estimate_bill'] ?? 0}',
                      ),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: TenantBottomBar(currentIndex: 0),
    );
  }
}
