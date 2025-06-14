import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/view/profile/edit_user_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // Import provider package
// Import your LanguageProvider (adjust path as needed)

class Userinfo extends StatefulWidget {
  const Userinfo({Key? key}) : super(key: key);
  static const String routeName = '/user-profile';

  @override
  _Userinfo createState() => _Userinfo();
}

class _Userinfo extends State<Userinfo> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://eba.onrender.com/get-user-info/?userId=$userId'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userInfo = data['userInfo'];
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['detail'] as List;
        setState(() {
          _errorMessage = errors.map((e) => e['msg']).join('\n');
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Please Try Again';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoTile({
    required String titleKey,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color ?? Colors.blue.shade100,
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(
          provider.getText(titleKey),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.getText('user_profile')),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUserInfoScreen(),
                      ),
                    );
                  },
                  child: Text(
                    provider.getText('add'),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _userInfo == null
              ? Center(child: Text(provider.getText('no_user_data_available')))
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userInfo!['name'] ?? provider.getText('unknown_user'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Section Header
                    _sectionHeader(provider.getText('basic_information')),

                    _buildInfoTile(
                      titleKey: 'gender',
                      value:
                          _userInfo!['gender'] ??
                          provider.getText('not_provided'),
                      icon: Icons.wc,
                      color: Colors.purple.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'birth_date',
                      value:
                          _userInfo!['borndate'] ??
                          provider.getText('not_provided'),
                      icon: Icons.calendar_today,
                      color: Colors.teal.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'blood_type',
                      value:
                          _userInfo!['bloodType']?.toString().toUpperCase() ??
                          provider.getText('not_provided'),
                      icon: Icons.bloodtype,
                      color: Colors.red.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'height',
                      value:
                          _userInfo!['height'] != null
                              ? '${_userInfo!['height']} cm'
                              : provider.getText('not_provided'),
                      icon: Icons.height,
                      color: Colors.orange.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'weight',
                      value:
                          _userInfo!['weight'] != null
                              ? '${_userInfo!['weight']} kg'
                              : provider.getText('not_provided'),
                      icon: Icons.monitor_weight,
                      color: Colors.green.shade100,
                    ),

                    // Section Header
                    _sectionHeader(provider.getText('health_details')),

                    _buildInfoTile(
                      titleKey: 'allergies',
                      value:
                          _userInfo!['allergies'] ??
                          provider.getText('none_reported'),
                      icon: Icons.sick,
                      color: Colors.yellow.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'medical_conditions',
                      value:
                          _userInfo!['medicalConditions'] ??
                          provider.getText('none_reported'),
                      icon: Icons.medical_services,
                      color: Colors.deepOrange.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'medications',
                      value:
                          _userInfo!['medications'] ??
                          provider.getText('none_reported'),
                      icon: Icons.local_pharmacy,
                      color: Colors.cyan.shade100,
                    ),
                    _buildInfoTile(
                      titleKey: 'disabilities',
                      value:
                          _userInfo!['disabilities'] ??
                          provider.getText('none_reported'),
                      icon: Icons.accessible,
                      color: Colors.indigo.shade100,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
