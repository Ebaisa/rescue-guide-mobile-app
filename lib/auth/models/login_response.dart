import 'package:health/auth/models/user_model.dart';
import 'package:health/auth/service/auth_service.dart';

class LoginResponse {
  final bool success;
  final String message;
  final User? user;
  final List<String>? errors;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.errors,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['status'] == null) {
      AuthService authService = AuthService();
      authService.saveUserData(User.fromJson(json));
    }
    return LoginResponse(
      success: json['status'] == 200,
      message:
          json['message']?.toString() ??
          (json['status'] == 200 ? 'Login successful' : 'Login failed'),
      user: json['status'] == 200 ? User.fromJson(json) : null,
      errors: _parseErrors(json),
    );
  }

  static List<String>? _parseErrors(Map<String, dynamic> json) {
    try {
      if (json['detail'] is List) {
        return (json['detail'] as List)
            .map((e) => e['msg']?.toString() ?? 'Validation error')
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
