import 'package:flutter/material.dart';

class MiniDashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content1;
  final String content2;

  const MiniDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content1,
    required this.content2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(content1, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 4),

            Text(
              content2,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
