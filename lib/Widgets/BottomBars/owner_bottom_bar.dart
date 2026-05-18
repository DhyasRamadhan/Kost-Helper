import 'package:flutter/material.dart';
import 'package:Kostify/Views/payment/payment_list_view.dart';

import '../../views/owner/owner_dashboard_view.dart';
import '../../views/owner/owner_profile_view.dart';
import '../../views/owner/room/room_list_view.dart';
import '../../views/owner/tenant/owner_tenant_list_view.dart';

class OwnerBottomBar extends StatelessWidget {
  final int currentIndex;

  const OwnerBottomBar({super.key, required this.currentIndex});

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  void onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        _createRoute(const OwnerDashboardView()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        _createRoute(const RoomListView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        _createRoute(const OwnerTenantListView()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        _createRoute(const PaymentListView()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        _createRoute(const OwnerProfileView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        onTap: (index) {
          onTap(context, index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_rounded),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Tenants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_rounded),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
