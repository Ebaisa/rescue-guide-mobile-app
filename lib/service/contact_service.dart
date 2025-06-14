import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact_model.dart';

class ContactService {
  Future<List<Contact>> fetchEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('https://eba.onrender.com/get-emergency/?userId=$userId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final contacts =
          (responseData['emergency'] as List?)
              ?.map((e) => Contact.fromJson(e))
              .toList() ??
          [];
      return contacts;
    } else if (response.statusCode == 422) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail']?[0]['msg'] ?? 'Validation error');
    } else {
      throw Exception('Failed to load contacts: ${response.statusCode}');
    }
  }
}
