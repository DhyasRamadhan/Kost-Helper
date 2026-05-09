import 'package:flutter/material.dart';
import '../../../controllers/tenant_update_controller.dart';
import '../../../widgets/custom_app_bar.dart';

class TenantEditRequestView extends StatefulWidget {
  const TenantEditRequestView({super.key});

  @override
  State<TenantEditRequestView> createState() => _TenantEditRequestViewState();
}

class _TenantEditRequestViewState extends State<TenantEditRequestView> {
  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  final emergencyController = TextEditingController();

  final notesController = TextEditingController();

  bool isLoading = false;

  Future<void> submitRequest() async {
    setState(() {
      isLoading = true;
    });

    final result = await TenantUpdateController.submitUpdateRequest(
      phone: phoneController.text,

      address: addressController.text,

      emergencyContact: emergencyController.text,

      notes: notesController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Update request submitted' : result['message'],
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
      appBar: const CustomAppBar(title: 'Edit Request'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: phoneController,

              decoration: const InputDecoration(labelText: 'Phone'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: addressController,

              decoration: const InputDecoration(labelText: 'Address'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emergencyController,

              decoration: const InputDecoration(labelText: 'Emergency Contact'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: notesController,

              maxLines: 4,

              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : submitRequest,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
