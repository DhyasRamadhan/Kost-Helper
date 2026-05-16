import 'package:flutter/material.dart';
import '../../../controllers/tenant_update_controller.dart';
import '../../../Widgets/custom_app_bar.dart';

class TenantUpdateRequestsView extends StatefulWidget {
  const TenantUpdateRequestsView({super.key});

  @override
  State<TenantUpdateRequestsView> createState() =>
      _TenantUpdateRequestsViewState();
}

class _TenantUpdateRequestsViewState extends State<TenantUpdateRequestsView> {
  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final result = await TenantUpdateController.getUpdateRequests();

    debugPrint(result.toString());

    if (result['success']) {
      setState(() {
        requests = result['data'] is List ? result['data'] : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleApprove(int id) async {
    final result = await TenantUpdateController.approveRequest(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? 'Request approved!'
              : result['message'] ?? 'Failed',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) loadRequests();
  }

  Future<void> handleReject(int id) async {
    final result = await TenantUpdateController.rejectRequest(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? 'Request rejected'
              : result['message'] ?? 'Failed',
        ),
        backgroundColor: result['success'] ? Colors.orange : Colors.red,
      ),
    );

    if (result['success']) loadRequests();
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Map<String, List> groupRequests(List requests) {
    Map<String, List> grouped = {};

    for (var req in requests) {
      final tenantId = req['tenant_id'];

      final createdAt = DateTime.parse(req['created_at']);

      final key =
          '${tenantId}_${createdAt.year}'
          '${createdAt.month}'
          '${createdAt.day}'
          '${createdAt.hour}'
          '${createdAt.minute}';

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(req);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedRequests = groupRequests(requests);
    final groupedList = groupedRequests.values.toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Requests'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No update requests.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadRequests,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: groupedList.length,
                itemBuilder: (context, index) {
                  final group = groupedList[index];
                  final req = group.first;
                  final tenant = req['tenant'];
                  final user = tenant?['user'];
                  final isPending = req['status'] == 'pending';

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
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: Icon(
                                  Icons.edit_note,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Field: ${req['field_name'] ?? '-'}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    req['status'],
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  req['status']?.toString().toUpperCase() ??
                                      'UNKNOWN',
                                  style: TextStyle(
                                    color: _statusColor(req['status']),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 24),

                          ...group.map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    Icons.label,
                                    'Field',
                                    item['field_name'] ?? '-',
                                  ),

                                  const SizedBox(height: 6),

                                  _buildInfoRow(
                                    Icons.arrow_back,
                                    'Old Value',
                                    item['old_value'] ?? '-',
                                  ),

                                  const SizedBox(height: 6),

                                  _buildInfoRow(
                                    Icons.arrow_forward,
                                    'New Value',
                                    item['new_value'] ?? '-',
                                  ),

                                  const Divider(height: 20),
                                ],
                              ),
                            );
                          }).toList(),

                          if (isPending) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => handleApprove(req['id']),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () => handleReject(req['id']),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
