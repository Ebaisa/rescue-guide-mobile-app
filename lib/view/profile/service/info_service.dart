// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserinfoService {
  final String baseUrl = 'https://eba.onrender.com';

  Future<Map<String, dynamic>> addUserInfo({
    required String userId,
    required String bloodType,
    required String height,
    required String weight,
    required String allergies,
    required String medicalConditions,
    required String medications,
    required String disabilities,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-user-info/'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'accept': 'application/json',
        },
        body: {
          'userId': userId,
          'bloodType': bloodType,
          'height': height,
          'weight': weight,
          'allergies': allergies,
          'medicalConditions': medicalConditions,
          'medications': medications,
          'disabilities': disabilities,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message':
              responseData['message'] ?? 'Information saved successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to save information',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
