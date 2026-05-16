import 'package:flutter/material.dart';
import '../../../controllers/contract_controller.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/BottomBars/owner_bottom_bar.dart';

class OwnerTenantListView extends StatefulWidget {
  const OwnerTenantListView({super.key});

  @override
  State<OwnerTenantListView> createState() => _OwnerTenantListViewState();
}

class _OwnerTenantListViewState extends State<OwnerTenantListView> {
  List tenants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTenants();
  }

  Future<void> loadTenants() async {
    final result = await ContractController.getContracts();

    if (result['success']) {
      final contracts = result['data'] is List ? result['data'] : [];
      final Map<int, dynamic> uniqueTenants = {};

      for (var contract in contracts) {
        if (contract['tenant'] != null) {
          // You can also add `&& contract['status'] == 'active'` if you only want active ones
          uniqueTenants[contract['tenant']['id']] = contract['tenant'];
        }
      }

      setState(() {
        tenants = uniqueTenants.values.toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tenants'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tenants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_alt, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No tenants found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadTenants,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final tenant = tenants[index];
                  final user = tenant['user'];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
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
                                  user?['email'] ?? '-',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      user?['phone'] ?? '-',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                if (tenant['address'] != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          tenant['address'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: const OwnerBottomBar(currentIndex: 2),
    );
  }
}
