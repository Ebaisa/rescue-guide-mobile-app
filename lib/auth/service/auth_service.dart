import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  /// Save full user data including token
Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user.token != null && user.token!.isNotEmpty) {
      await prefs.setString('auth_token', user.token!);
    }
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);

    if (user.phone != null && user.phone!.isNotEmpty) {
      await prefs.setString('user_phone', user.phone!);
    }
    if (user.gender != null && user.gender!.isNotEmpty) {
      await prefs.setString('user_gender', user.gender!);
    }
    if (user.dob != null && user.dob!.isNotEmpty) {
      await prefs.setString('user_dob', user.dob!);
    }
    if (user.age != null) {
      await prefs.setInt('user_age', user.age!);
    }
  }

// 
  /// Load saved user data into a map
  Future<Map<String, dynamic>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('auth_token') ?? '',
      'id': prefs.getString('user_id') ?? '',
      'name': prefs.getString('user_name') ?? 'Guest',
      'email': prefs.getString('user_email') ?? 'No email',
      'phone': prefs.getString('user_phone') ?? '',
      'gender': prefs.getString('user_gender') ?? '',
      'dob': prefs.getString('user_dob') ?? '',
      'age': prefs.getInt('user_age') ?? 0,
    };
  }

  /// Clear all stored user data (for full logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_gender');
    await prefs.remove('user_dob');
    await prefs.remove('user_age');
  }

  /// Shortcut logout (clears only essential identifiers)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }
}
