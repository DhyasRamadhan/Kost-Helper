import 'package:flutter/material.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/BottomBars/tenant_bottom_bar.dart';

class TenantElectricityView extends StatefulWidget {
  const TenantElectricityView({super.key});

  @override
  State<TenantElectricityView> createState() => _TenantElectricityViewState();
}

class _TenantElectricityViewState extends State<TenantElectricityView> {
  Map<String, dynamic>? electricityData;
  Map<String, dynamic>? roomData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await DashboardController.getDashboard();

    if (result['success']) {
      setState(() {
        electricityData = result['data']['electricity_usage'];
        roomData = result['data']['room'];
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
      appBar: const CustomAppBar(title: 'My Electricity'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : electricityData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.electric_bolt, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No electricity data found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber.withOpacity(0.1),
                        child: const Icon(Icons.electric_meter, size: 50, color: Colors.amber),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Room ${roomData?['room_number'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latest Reading: ${electricityData?['usage_date'] ?? '-'}',
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDataRow('Usage (kWh)', '${electricityData?['usage_kwh'] ?? 0} kWh', Icons.flash_on),
                              const Divider(height: 30),
                              _buildDataRow('Estimated Bill', 'Rp ${electricityData?['estimate_bill'] ?? 0}', Icons.payments),
                              const Divider(height: 30),
                              _buildDataRow('Meter Start', '${electricityData?['meter_start'] ?? 0}', Icons.speed),
                              const Divider(height: 30),
                              _buildDataRow('Meter End', '${electricityData?['meter_end'] ?? 0}', Icons.speed),
                              if (electricityData?['token_amount'] != null) ...[
                                const Divider(height: 30),
                                _buildDataRow('Token Amount', '${electricityData?['token_amount']}', Icons.numbers),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const TenantBottomBar(currentIndex: 2),
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ],
    );
  }
}
