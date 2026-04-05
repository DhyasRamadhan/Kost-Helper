import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payments")),

      body: ListView.builder(
        itemCount: 5,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Tenant ${index + 1}"),
            subtitle: Text("Paid - March"),

            trailing: Icon(Icons.check_circle, color: Colors.green),
          );
        },
      ),
    );
  }
}
