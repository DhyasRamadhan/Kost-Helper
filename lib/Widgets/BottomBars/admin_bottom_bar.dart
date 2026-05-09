import 'package:flutter/material.dart';

import '../../views/admin/admin_dashboard_view.dart';

class AdminBottomBar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomBar({super.key, required this.currentIndex});

  void onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardView()),
      );
    } else if (index == 1) {
      // TODO:
      // navigate rooms page
    } else if (index == 2) {
      // TODO:
      // navigate tenants page
    } else if (index == 3) {
      // TODO:
      // navigate payments page
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

        BottomNavigationBarItem(
          icon: Icon(Icons.verified),
          label: 'Verification',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
