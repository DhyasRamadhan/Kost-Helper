import 'package:flutter/material.dart';
import '../contract/contract_page.dart';
import '../room/room_list_page.dart';
import '../tenant/tenant_list_page.dart';
import '../payment/payment_page.dart';
import '../electricity/electricity_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),

      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),

        children: [
          dashboardButton(context, "Rooms", RoomListPage()),
          dashboardButton(context, "Tenants", TenantListPage()),
          dashboardButton(context, "Contracts", ContractPage()),
          dashboardButton(context, "Payments", PaymentPage()),
          dashboardButton(context, "Electricity", ElectricityPage()),
        ],
      ),
    );
  }

  Widget dashboardButton(context, title, page) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Center(child: Text(title)),
      ),
    );
  }
}
