import 'package:flutter/material.dart';
import '../../../controllers/payment_controller.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/BottomBars/owner_bottom_bar.dart';

class PaymentListView extends StatefulWidget {
  const PaymentListView({super.key});

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  List payments = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadPayments();
  }

  Future<void> loadPayments() async {
    final result = await PaymentController.getPayments();

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

  Future<void> cancelPayment(int id) async {
    final result = await PaymentController.cancelPayment(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Payment cancelled' : result['message'],
        ),
      ),
    );

    if (result['success']) {
      loadPayments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payments'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(child: Text('No payments'))
          : ListView.builder(
              itemCount: payments.length,

              itemBuilder: (context, index) {
                final payment = payments[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Amount: Rp ${payment['amount']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text('Status: ${payment['status']}'),

                        Text('Date: ${payment['payment_date']}'),

                        const SizedBox(height: 10),

                        if (payment['status'] != 'paid' &&
                            payment['status'] != 'cancelled')
                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              onPressed: () {
                                cancelPayment(payment['id']);
                              },

                              child: const Text('Cancel Payment'),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: const OwnerBottomBar(currentIndex: 3),
    );
  }
}
