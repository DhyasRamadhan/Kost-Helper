import 'package:flutter/material.dart';

class TenantFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Tenant")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Tenant Name")),

            TextField(decoration: InputDecoration(labelText: "Phone")),

            TextField(decoration: InputDecoration(labelText: "Room")),

            SizedBox(height: 20),

            ElevatedButton(child: Text("Save"), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
