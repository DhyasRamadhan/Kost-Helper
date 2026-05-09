import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import 'register_view.dart';
import '../owner/owner_dashboard_view.dart';
import '../tenant/tenant_dashboard_view.dart';
import '../admin/admin_dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final result = await AuthController.login(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Login Success' : result['message']),
      ),
    );

    if (result['success']) {
      final user = result['data']['user'];
      final role = user['role'].toString().trim().toLowerCase();

      if (role == 'owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OwnerDashboardView()),
        );
      } else if (role == 'tenant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TenantDashboardView()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : handleLogin,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterView()),
                );
              },

              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
