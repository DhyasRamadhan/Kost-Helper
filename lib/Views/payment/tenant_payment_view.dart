import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Payments'),

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

                        Text('Payment Date: ${payment['payment_date']}'),

                        const SizedBox(height: 8),

                        Text(
                          'Room: ${payment['contract']['room']['room_number']}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: TenantBottomBar(currentIndex: 1),
    );
  }
}
