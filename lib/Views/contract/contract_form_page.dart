import 'package:flutter/material.dart';

class ContractFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Rental Contract")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Tenant"),
                items: [
                  DropdownMenuItem(child: Text("Tenant 1"), value: "1"),
                  DropdownMenuItem(child: Text("Tenant 2"), value: "2"),
                ],
                onChanged: (v) {},
              ),

              SizedBox(height: 20),

              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Room"),
                items: [
                  DropdownMenuItem(child: Text("Room A1"), value: "A1"),
                  DropdownMenuItem(child: Text("Room A2"), value: "A2"),
                ],
                onChanged: (v) {},
              ),

              SizedBox(height: 20),

              TextField(decoration: InputDecoration(labelText: "Start Date")),

              SizedBox(height: 20),

              TextField(decoration: InputDecoration(labelText: "End Date")),

              SizedBox(height: 30),

              ElevatedButton(child: Text("Save Contract"), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
