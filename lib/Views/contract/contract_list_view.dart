import 'package:flutter/material.dart';
import '../../controllers/contract_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../Widgets/custom_app_bar.dart';
import 'create_contract_view.dart';

class ContractListView extends StatefulWidget {
  const ContractListView({super.key});

  @override
  State<ContractListView> createState() => _ContractListViewState();
}

class _ContractListViewState extends State<ContractListView> {
  List contracts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContracts();
  }

  Future<void> loadContracts() async {
    final result = await ContractController.getContracts();

    if (result['success']) {
      setState(() {
        contracts = result['data'] is List ? result['data'] : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> generatePayment(int contractId) async {
    final result = await PaymentController.createPayment(contractId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Payment generated successfully!' : result['message'] ?? 'Failed'),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> deleteContract(int id) async {
    final result = await ContractController.deleteContract(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Contract deleted' : result['message'] ?? 'Failed'),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) loadContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Contracts'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateContractView()),
          );
          if (created == true) loadContracts();
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contracts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No contracts found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadContracts,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    final contract = contracts[index];
                    final tenant = contract['tenant'];
                    final user = tenant?['user'];
                    final room = contract['room'];
                    final isActive = contract['status'] == 'active';

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
                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                  child: Icon(Icons.description_rounded, color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?['name'] ?? 'Unknown Tenant',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Room ${room?['room_number'] ?? '-'}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    contract['status']?.toString().toUpperCase() ?? 'UNKNOWN',
                                    style: TextStyle(
                                      color: isActive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.calendar_today, 'Start', contract['start_date'] ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.event, 'End', contract['end_date'] ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.payments, 'Rent', 'Rp ${contract['monthly_rent'] ?? 0}'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isActive)
                                  ElevatedButton.icon(
                                    onPressed: () => generatePayment(contract['id']),
                                    icon: const Icon(Icons.payment, size: 18),
                                    label: const Text('Generate Payment'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () => deleteContract(contract['id']),
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
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
