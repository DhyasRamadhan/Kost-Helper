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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Registrasi berhasil' : result['message'],
        ),
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 42,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),

                child: Icon(
                  Icons.person_add_alt_1,
                  size: 42,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Daftar untuk mulai menggunakan Kostify',
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
                        controller: nameController,

                        decoration: buildInputDecoration(
                          label: 'Nama Lengkap',
                          icon: Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: emailController,

                        decoration: buildInputDecoration(
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: phoneController,

                        decoration: buildInputDecoration(
                          label: 'Nomor Telepon',
                          icon: Icons.phone_outlined,
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

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: role,

                        decoration: buildInputDecoration(
                          label: 'Daftar Sebagai',
                          icon: Icons.groups_outlined,
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: 'tenant',
                            child: Text('Penyewa'),
                          ),

                          DropdownMenuItem(
                            value: 'owner',
                            child: Text('Pemilik Kos'),
                          ),
                        ],

                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleRegister,

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
                                  'Daftar',
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
                  Navigator.pop(context);
                },

                child: const Text('Sudah punya akun? Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
