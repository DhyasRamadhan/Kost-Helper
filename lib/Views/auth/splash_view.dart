import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/dashboard_service.dart';

import '../owner/owner_dashboard_view.dart';
import '../tenant/tenant_dashboard_view.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {
    final token = await AuthService.getToken();

    if (token == null) {
      goToLogin();

      return;
    }

    final result = await DashboardService.getDashboard();

    if (!result['success']) {
      goToLogin();

      return;
    }

    final role = result['data']['role'];

    if (!mounted) return;

    if (role == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerDashboardView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TenantDashboardView()),
      );
    }
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
