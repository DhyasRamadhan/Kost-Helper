import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../views/auth/login_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthController.logout();

            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }
}
