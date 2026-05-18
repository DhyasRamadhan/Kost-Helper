import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Kostify/Views/auth/splash_view.dart';
import 'package:Kostify/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService().initialize();

  runApp(KostManagementApp());
}

class KostManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kostify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashView(),
    );
  }
}
