import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? actions;

  final PreferredSizeWidget? bottom;

  const CustomAppBar({super.key, required this.title, this.actions, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0, // Keeps it strictly white without Material 3 tint
      iconTheme: const IconThemeData(color: Colors.black87),
      actionsIconTheme: const IconThemeData(color: Colors.black87),
      actions: actions,
      bottom: bottom,
      bottomOpacity: 1.0,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
  }
}
