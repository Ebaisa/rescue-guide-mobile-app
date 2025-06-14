// sos_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// sos_history_screen.dart

import 'package:shared_preferences/shared_preferences.dart';

class SosService {
  final String baseUrl = 'https://eba.onrender.com';

  Future<Map<String, dynamic>> getSosHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-sos-by-user/?userId=$userId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load SOS history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching SOS history: $e');
    }
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final SosService _sosService = SosService();
  List<dynamic> _sosHistory = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print(111111);
    _loadSosHistory();
  }

  Future<void> _loadSosHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await _sosService.getSosHistory(userId);
      print(response['sosData']);

      if (response['status'] == 200 && response['sosData'] != null) {
        setState(() {
          _sosHistory = response['sosData'];
          _isLoading = false;
        });
      } else if (response['status'] == 404) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No SOS history found';
        });
      } else {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadSosHistory,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_sosHistory.isEmpty) {
      return const Center(child: Text('No SOS requests found'));
    }

    return ListView.builder(
      itemCount: _sosHistory.length,
      itemBuilder: (context, index) {
        final sos = _sosHistory[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('Hospital: ${sos['hospital_name'] ?? 'Unknown'}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('date: ${sos['date']}'),
                Text('email: ${sos['email'] ?? 'Unknown'}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to SOS details if needed
            },
          ),
        );
      },
    );
  }
}
