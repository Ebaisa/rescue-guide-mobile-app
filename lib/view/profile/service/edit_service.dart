// lib/services/profile_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileService {
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        return {
          'success': false,
          'message': 'User session expired. Please login again.',
          'data': null,
        };
      }

      return {
        'success': true,
        'data': {
          'userId': userId,
          'name': prefs.getString('user_name') ?? '',
          'email': prefs.getString('user_email') ?? '',
          'phone': prefs.getString('user_phone') ?? '',
          'gender': prefs.getString('user_gender'),
          'dob': prefs.getString('user_dob') ?? '',
        },
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to load profile data',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String email,
    required String name,
    required String phoneNumber,
    required String gender,
    required String bornDate,
  }) async {
    try {
      final payload = {
        'userId': userId,
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'bornDate': bornDate,
      };

      final response = await http.post(
        Uri.parse('https://eba.onrender.com/edit-user/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: Uri(queryParameters: payload).query,
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        await _saveProfileDataLocally(
          name: name,
          email: email,
          phone: phoneNumber,
          gender: gender,
          dob: bornDate,
        );

        return {
          'success': true,
          'message': responseBody['message'] ?? 'Profile updated successfully!',
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<void> _saveProfileDataLocally({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String dob,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_gender', gender);
      await prefs.setString('user_dob', dob);

      if (dob.isNotEmpty) {
        try {
          final age =
              DateTime.now().difference(DateTime.parse(dob)).inDays ~/ 365;
          await prefs.setInt('user_age', age);
        } catch (e) {
          debugPrint('Age calculation error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error saving profile locally: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      String errorMessage;

      if (response.statusCode == 401) {
        errorMessage = 'Session expired. Please login again.';
      } else if (response.statusCode == 422) {
        final errors = (errorData['detail'] as List)
            .map((e) => e['msg'] ?? 'Validation error')
            .join('\n');
        errorMessage = 'Validation errors:\n$errors';
      } else {
        errorMessage =
            errorData['message'] ?? 'Update failed (${response.statusCode})';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${response.body}'};
    }
  }
}
