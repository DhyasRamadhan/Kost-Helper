import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,

        icon: Icon(icon, size: 20),

        label: Text(label, textAlign: TextAlign.center),

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,

          side: BorderSide(color: foregroundColor.withOpacity(0.2)),

          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
