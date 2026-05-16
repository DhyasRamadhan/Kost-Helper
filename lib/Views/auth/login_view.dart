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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Login berhasil' : result['message']),
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

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(icon),

      filled: true,
      fillColor: Colors.grey.shade50,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),

                  child: Icon(
                    Icons.home_work_rounded,
                    size: 42,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Selamat Datang',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Masuk untuk melanjutkan ke Kostify',
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 32),

                Card(
                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,

                          decoration: buildInputDecoration(
                            label: 'Email',
                            icon: Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: passwordController,
                          obscureText: true,

                          decoration: buildInputDecoration(
                            label: 'Password',
                            icon: Icons.lock_outline,
                          ),
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: isLoading ? null : handleLogin,

                            style: ElevatedButton.styleFrom(
                              elevation: 0,

                              padding: const EdgeInsets.symmetric(vertical: 16),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  },

                  child: const Text('Belum punya akun? Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
