import 'package:flutter/material.dart';
import 'package:Kostify/Widgets/mini_dashboard_card.dart';
import 'package:Kostify/Widgets/quick_action_button.dart';
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
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.admin_panel_settings, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selamat Datang, ${dashboardData?['owner']?['name'] ?? 'Owner'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if ((dashboardData?['alerts'] ?? []).isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Perlu Perhatian!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          ...List.generate(dashboardData!['alerts'].length, (
                            index,
                          ) {
                            final alert = dashboardData!['alerts'][index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '• ${alert['message']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: MiniDashboardCard(
                          title: 'Kamar',
                          icon: Icons.meeting_room,
                          content1:
                              '${dashboardData?['rooms']?['total'] ?? 0} Total',
                          content2:
                              '${dashboardData?['rooms']?['occupied'] ?? 0} Terisi',
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: MiniDashboardCard(
                          title: 'Penyewa',
                          icon: Icons.people,
                          content1:
                              '${dashboardData?['tenants']?['total'] ?? 0} Penyewa',
                          content2:
                              '${dashboardData?['contracts']?['active'] ?? 0} Kontrak Aktif',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tingkat Hunian',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          LinearProgressIndicator(
                            value:
                                (dashboardData?['rooms']?['occupancy_rate'] ??
                                    0) /
                                100,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(12),
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            '${dashboardData?['rooms']?['occupancy_rate'] ?? 0}% Terisi',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Keuangan',
                    icon: Icons.attach_money,
                    content1:
                        'Total Pemasukan: Rp ${dashboardData?['payments']?['total_income'] ?? 0}',
                    content2:
                        'Pembayaran tertunda: ${dashboardData?['payments']?['pending_payments'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  _buildDashboardCard(
                    title: 'Listrik',
                    icon: Icons.electric_bolt,
                    content1: 'Total Estimasi Tagihan',
                    content2:
                        'Rp ${dashboardData?['electricity']?['total_estimated_bill'] ?? 0}',
                  ),
                  const SizedBox(height: 16),
                  if ((dashboardData?['expiring_contracts'] ?? [])
                      .isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kontrak Akan Berakhir',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      dashboardData!['expiring_contracts'].length,
                      (index) {
                        final contract =
                            dashboardData!['expiring_contracts'][index];

                        return Card(
                          color: Colors.orange.shade50,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                            ),
                            title: Text(
                              'Kamar No ${contract['room_number']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${contract['tenant_name']} • Berakhir dalam ${contract['days_remaining']} hari',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],

                  if ((dashboardData?['overdue_payments'] ?? [])
                      .isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pembayaran Terlambat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(dashboardData!['overdue_payments'].length, (
                      index,
                    ) {
                      final payment = dashboardData!['overdue_payments'][index];

                      return Card(
                        color: Colors.red.shade50,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.payments_outlined,
                            color: Colors.red,
                          ),
                          title: Text(
                            'Kamar No ${payment['room_number']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${payment['tenant_name']} • ${payment['days_late']} hari terlambat',
                          ),
                          trailing: Text(
                            'Rp ${payment['amount']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],

                  if ((dashboardData?['potential_vacant_rooms'] ?? [])
                      .isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Potensi Kamar Kosong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      dashboardData!['potential_vacant_rooms'].length,
                      (index) {
                        final room =
                            dashboardData!['potential_vacant_rooms'][index];

                        return Card(
                          color: Colors.deepOrange.shade50,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.meeting_room_outlined,
                              color: Colors.deepOrange,
                            ),
                            title: Text(
                              'Kamar No ${room['room_number']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${room['tenant_name']} • Kontrak berakhir dalam ${room['days_remaining']} hari',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Aksi Cepat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionButton(
                          label: 'Kelola Kontrak',
                          icon: Icons.description_outlined,
                          backgroundColor: Colors.deepPurple.shade50,
                          foregroundColor: Colors.deepPurple.shade700,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ContractListView(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: QuickActionButton(
                          label: 'Manajemen Listrik',
                          icon: Icons.electric_bolt_outlined,
                          backgroundColor: Colors.deepPurple.shade50,
                          foregroundColor: Colors.deepPurple.shade700,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ElectricityListView(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  QuickActionButton(
                    label: 'Permintaan Update Data Penghuni',
                    icon: Icons.edit_note_outlined,
                    backgroundColor: Colors.orange.shade50,
                    foregroundColor: Colors.orange.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TenantUpdateRequestsView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      bottomNavigationBar: const OwnerBottomBar(currentIndex: 0),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required String content1,
    required String content2,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(content1, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    content2,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
