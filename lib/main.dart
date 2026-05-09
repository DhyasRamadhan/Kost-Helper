import 'package:flutter/material.dart';
import 'package:kost_helper/Views/auth/splash_view.dart';

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
      home: SplashView(),
    );
  }
}
