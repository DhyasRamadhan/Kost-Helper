import 'package:flutter/material.dart';
import '../../Widgets/BottomBars/owner_bottom_bar.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../controllers/profile_controller.dart';
import '../../services/auth_service.dart';
import '../auth/login_view.dart';

class OwnerProfileView extends StatefulWidget {
  const OwnerProfileView({super.key});

  @override
  State<OwnerProfileView> createState() => _OwnerProfileViewState();
}

class _OwnerProfileViewState extends State<OwnerProfileView> {
  Map<String, dynamic>? ownerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await ProfileController.getProfile();

    if (result['success']) {
      setState(() {
        ownerData = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Profile'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileRow('Name', ownerData?['name']),
                          const Divider(),
                          _buildProfileRow('Email', ownerData?['email']),
                          const Divider(),
                          _buildProfileRow('Phone', ownerData?['phone']),
                          const Divider(),
                          _buildProfileRow('Status', ownerData?['verification_status']?.toString().toUpperCase()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const OwnerBottomBar(currentIndex: 4),
    );
  }

  Widget _buildProfileRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value ?? '-', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
