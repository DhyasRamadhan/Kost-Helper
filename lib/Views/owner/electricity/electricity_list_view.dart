import 'package:flutter/material.dart';
import '../../../controllers/electricity_controller.dart';
import '../../../Widgets/custom_app_bar.dart';
import 'add_electricity_view.dart';

class ElectricityListView extends StatefulWidget {
  const ElectricityListView({super.key});

  @override
  State<ElectricityListView> createState() => _ElectricityListViewState();
}

class _ElectricityListViewState extends State<ElectricityListView> {
  List usages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsages();
  }

  Future<void> loadUsages() async {
    final result = await ElectricityController.getElectricityUsages();

    if (result['success']) {
      setState(() {
        usages = result['data'] is List ? result['data'] : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteUsage(int id) async {
    final result = await ElectricityController.deleteElectricityUsage(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Record deleted' : result['message'] ?? 'Failed'),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) loadUsages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Electricity Management'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddElectricityView()),
          );
          if (created == true) loadUsages();
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.electric_bolt, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No electricity records.',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: usages.length,
                  itemBuilder: (context, index) {
                    final usage = usages[index];
                    final room = usage['room'];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.amber.withOpacity(0.1),
                                  child: const Icon(Icons.electric_meter, color: Colors.amber),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room ${room?['room_number'] ?? '-'}',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        usage['usage_date'] ?? '-',
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => deleteUsage(usage['id']),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.speed, 'Meter', '${usage['meter_start'] ?? 0} → ${usage['meter_end'] ?? 0}'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.flash_on, 'Usage', '${usage['usage_kwh'] ?? 0} kWh'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.payments, 'Bill', 'Rp ${usage['estimate_bill'] ?? 0}'),
                            if (usage['token_amount'] != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.numbers, 'Token', '${usage['token_amount']}'),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}
