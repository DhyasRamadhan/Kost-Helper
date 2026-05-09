import 'package:flutter/material.dart';
import '../../../Widgets/BottomBars/tenant_bottom_bar.dart';
import '../../../services/auth_service.dart';
import '../../auth/login_view.dart';
import '../../../widgets/custom_app_bar.dart';
import 'tenant_edit_request_view.dart';

class TenantProfileView extends StatefulWidget {
  const TenantProfileView({super.key});

  @override
  State<TenantProfileView> createState() => _TenantProfileViewState();
}

class _TenantProfileViewState extends State<TenantProfileView> {
  Map<String, dynamic>? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    final token = await AuthService.getToken();

    setState(() {
      user = {
        'name': 'Tenant User',
        'email': 'tenant@mail.com',
        'phone': '08123456789',
        'role': 'tenant',
      };

      isLoading = false;
    });
  }

  Future<void> logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const LoginView()),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    user?['name'] ?? '-',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(user?['email'] ?? '-'),

                  const SizedBox(height: 10),

                  Text(user?['phone'] ?? '-'),

                  const SizedBox(height: 10),

                  Text('Role: ${user?['role']}'),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const TenantEditRequestView(),
                          ),
                        );
                      },

                      child: const Text('Edit Profile Request'),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: logout,

                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: TenantBottomBar(currentIndex: 3),
    );
  }
}
