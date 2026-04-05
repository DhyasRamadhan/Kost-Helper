import 'package:flutter/material.dart';

class ElectricityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Electricity Monitoring")),

      body: ListView(
        children: [
          ListTile(title: Text("Room A1"), subtitle: Text("Usage: 120 kWh")),

          ListTile(title: Text("Room A2"), subtitle: Text("Usage: 98 kWh")),
        ],
      ),
    );
  }
}
