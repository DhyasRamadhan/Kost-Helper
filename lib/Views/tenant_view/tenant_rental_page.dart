import 'package:flutter/material.dart';

class TenantRentalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rental Period")),

      body: Center(child: Text("Rental ends in 45 days")),
    );
  }
}
