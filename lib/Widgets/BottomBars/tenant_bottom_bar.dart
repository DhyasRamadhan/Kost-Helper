import 'package:flutter/material.dart';
import 'package:Kostify/Views/payment/tenant_payment_view.dart';
import 'package:Kostify/Views/tenant/profile/tenant_profile_view.dart';
import 'package:Kostify/Views/tenant/electricity/tenant_electricity_view.dart';

import '../../views/tenant/tenant_dashboard_view.dart';

class TenantBottomBar extends StatelessWidget {
  final int currentIndex;

  const TenantBottomBar({super.key, required this.currentIndex});

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
        _createRoute(const TenantDashboardView()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        _createRoute(const TenantPaymentView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        _createRoute(const TenantElectricityView()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        _createRoute(const TenantProfileView()),
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
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_rounded),
            label: 'Electricity',
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
