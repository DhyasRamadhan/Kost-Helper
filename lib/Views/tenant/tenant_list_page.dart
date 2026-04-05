import 'package:flutter/material.dart';
import 'tenant_form_page.dart';

class TenantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tenants")),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TenantFormPage()),
          );
        },
      ),

      body: ListView.builder(
        itemCount: 5,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Tenant ${index + 1}"),
            subtitle: Text("Room A${index + 1}"),
          );
        },
      ),
    );
  }
}
