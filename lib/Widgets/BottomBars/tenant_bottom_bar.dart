import 'package:flutter/material.dart';
import 'package:kost_helper/Views/payment/tenant_payment_view.dart';
import 'package:kost_helper/Views/tenant/profile/tenant_profile_view.dart';

import '../../views/tenant/tenant_dashboard_view.dart';

class TenantBottomBar extends StatelessWidget {
  final int currentIndex;

  const TenantBottomBar({super.key, required this.currentIndex});

  void onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TenantDashboardView()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TenantPaymentView()),
      );
    } else if (index == 2) {
      // Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(builder: (_) => const TenantElectricityView()),
      // );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TenantProfileView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        onTap(context, index);
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),

        BottomNavigationBarItem(
          icon: Icon(Icons.electric_bolt),
          label: 'Electricity',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
