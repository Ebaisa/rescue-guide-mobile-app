import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  Future<String> sendMessage(String text) async {
    final url = Uri.parse('https://chatbot-cvcd.onrender.com/ask?text=$text');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['message'];
      } else {
        throw Exception("Server couldn't process your request.");
      }
    } else {
      throw Exception('Failed to load response: ${response.statusCode}');
    }
  }
}
