import 'package:flutter/material.dart';
import 'contract_form_page.dart';

class ContractPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rental Contracts")),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ContractFormPage()),
          );
        },
      ),

      body: ListView.builder(
        itemCount: 5,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Tenant ${index + 1}"),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Room A${index + 1}"),
                Text("Start: 01 Jan 2026"),
                Text("End: 01 Jan 2027"),
              ],
            ),

            trailing: Icon(Icons.edit),
          );
        },
      ),
    );
  }
}
