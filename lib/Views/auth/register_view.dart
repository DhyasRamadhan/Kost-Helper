import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  String role = 'tenant';

  bool isLoading = false;

  void handleRegister() async {
    setState(() {
      isLoading = true;
    });

    final result = await AuthController.register(
      context: context,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: role,
      phone: phoneController.text,
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Register Success' : result['message'],
        ),
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: role,

              items: const [
                DropdownMenuItem(value: 'tenant', child: Text('Tenant')),

                DropdownMenuItem(value: 'owner', child: Text('Owner')),
              ],

              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
