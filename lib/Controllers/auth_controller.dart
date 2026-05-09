import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController {
  static Future<Map<String, dynamic>> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final result = await AuthService.login(email: email, password: password);

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
      );

      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> logout() async {
    try {
      await AuthService.logout();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
