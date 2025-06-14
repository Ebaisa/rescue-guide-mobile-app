import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PasswordService {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  String responseMessage = '';
  bool isSuccess = false;
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;
  String? userId;

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
  }

  Future<Map<String, dynamic>> changePassword({required String userId, required String newPassword, required String oldPassword}) async {
    if (newPasswordController.text != confirmPasswordController.text) {
      return {'success': false, 'message': 'New passwords do not match'};
    }

    if (userId == null) {
      return {'success': false, 'message': 'User not authenticated'};
    }

    isLoading = true;
    responseMessage = '';

    try {
      final response = await http.post(
        Uri.parse('https://eba.onrender.com/change-user-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'userId': userId!,
          'oldPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) { 
        return {
          'success': true,
          'message':
              responseBody['message'] ?? 'Password changed successfully!',
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    } finally {
      isLoading = false;
    }
  }

  Map<String, dynamic> _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);

      if (response.statusCode == 422) {
        final errors = (errorData['detail'] as List)
            .map((e) => e['msg'] ?? 'Validation error')
            .join('\n');
        return {'success': false, 'message': errors};
      } else {
        return {
          'success': false,
          'message':
              errorData['message'] ??
              'Password change failed (${response.statusCode})',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Failed to change password'};
    }
  }

  void clearControllers() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
