import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../models/register_response.dart';

class UserService {
  final String baseUrl = 'https://eba.onrender.com';
 
  /// Login a user with email & password
  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/user-login/');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'email': email, 'password': password},
    );

    final responseBody = json.decode(response.body);
    // saved to shared preferences
    
    return LoginResponse.fromJson(responseBody);
  }

  /// Register a new user
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String gender,
    required String bornDate,
  }) async {
    final url = Uri.parse('$baseUrl/user-register/');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'bornDate': bornDate,
      },
    );

    final responseBody = json.decode(response.body);
    return RegisterResponse.fromJson(responseBody);
  }
}
