import 'package:flutter/material.dart';

class TenantPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Payment")),

      body: Center(child: Text("Payment Status: Paid")),
    );
  }
}
