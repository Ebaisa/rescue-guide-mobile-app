import 'package:health/auth/models/user_model.dart';

class RegisterResponse {
  final bool success;
  final String message;
  final User? user;
  final List<String>? errors;

  RegisterResponse({
    required this.success,
    required this.message,
    this.user,
    this.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['status'] == 200,
      message:
          json['message']?.toString() ??
          (json['status'] == 200
              ? 'Registration successful'
              : 'Registration failed'),
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
