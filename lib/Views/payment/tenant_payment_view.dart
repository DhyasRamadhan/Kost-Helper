import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/payment_controller.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../Widgets/BottomBars/tenant_bottom_bar.dart';

class TenantPaymentView extends StatefulWidget {
  const TenantPaymentView({super.key});

  @override
  State<TenantPaymentView> createState() => _TenantPaymentViewState();
}

class _TenantPaymentViewState extends State<TenantPaymentView> {
  List payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    final result = await PaymentController.getTenantPayments();

    if (result['success']) {
      setState(() {
        payments = result['data']['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> payNow(int id) async {
    final result = await PaymentController.getPaymentToken(id);

    if (!mounted) return;

    if (result['success']) {
      final url = result['data']['redirect_url'];

      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Payments'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No payments found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadPayments,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  print(payment);
                  final status =
                      payment['status']?.toString().toLowerCase() ?? 'unknown';
                  final isPaid = status == 'paid';
                  final isPending = status == 'pending';

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.receipt_long,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      'Rp ${payment['amount']}',

                                      style: const TextStyle(
                                        fontSize: 18,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),

                                      decoration: BoxDecoration(
                                        color: isPaid
                                            ? Colors.green.withOpacity(0.1)
                                            : (isPending
                                                  ? Colors.orange.withOpacity(
                                                      0.1,
                                                    )
                                                  : Colors.red.withOpacity(
                                                      0.1,
                                                    )),

                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: Text(
                                        status.toUpperCase(),

                                        style: TextStyle(
                                          color: isPaid
                                              ? Colors.green
                                              : (isPending
                                                    ? Colors.orange
                                                    : Colors.red),

                                          fontWeight: FontWeight.bold,

                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.meeting_room,
                                      size: 16,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      'Room ${payment['contract']?['room']?['room_number'] ?? '-'}',

                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      payment['payment_date']?.toString() ??
                                          '-',

                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                if (isPending)
                                  SizedBox(
                                    width: double.infinity,

                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        payNow(payment['id']);
                                      },

                                      icon: const Icon(Icons.payment, size: 18),

                                      label: const Text('Pay Now'),

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,

                                        foregroundColor: Colors.white,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
      bottomNavigationBar: const TenantBottomBar(currentIndex: 1),
    );
  }
}
