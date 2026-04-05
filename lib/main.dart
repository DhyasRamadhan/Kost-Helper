import 'package:flutter/material.dart';
import 'Views/auth/login_page.dart';

void main() {
  runApp(KostManagementApp());
}

class KostManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kost Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
