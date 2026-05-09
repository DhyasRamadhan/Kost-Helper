import 'package:flutter/material.dart';
import 'package:kost_helper/Views/payment/payment_list_view.dart';

import '../../views/owner/owner_dashboard_view.dart';

class OwnerBottomBar extends StatelessWidget {
  final int currentIndex;

  const OwnerBottomBar({super.key, required this.currentIndex});

  void onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerDashboardView()),
      );
    } else if (index == 1) {
      // TODO:
      // navigate rooms page
    } else if (index == 2) {
      // TODO:
      // navigate tenants page
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaymentListView()),
      );
    } else if (index == 4) {
      // TODO:
      // navigate profile page
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

        BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Rooms'),

        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Tenants'),

        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
