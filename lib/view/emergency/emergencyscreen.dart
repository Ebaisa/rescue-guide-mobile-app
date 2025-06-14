import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<Map<String, String>> _contacts = [];
  bool _isLoading = true;
  String? _userId;
  String? _errorMessage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserIdAndContacts();
  }

  Future<void> _loadUserIdAndContacts() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');

    if (_userId == null || _userId!.isEmpty) {
      setState(() {
        _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
            .getText('error_user_not_authenticated');
        _isLoading = false;
      });
      return;
    }

    await _fetchEmergencyContacts();
  }

  Future<void> _fetchEmergencyContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://eba.onrender.com/get-emergency/?userId=$_userId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> emergencyContacts = responseData['emergency'];

        setState(() {
          _contacts = emergencyContacts.map<Map<String, String>>((contact) {
            return {
              'name': contact['name'].toString(),
              'phone': contact['phoneNumber'].toString(),
              'contactId': contact['contactId'].toString(),
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
              .getText('error_failed_to_load_contacts') +
              ': ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addEmergencyContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://eba.onrender.com/creat-emergency/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'userId': _userId, 'name': name, 'phoneNumber': phone},
      );

      if (response.statusCode == 200) {
        _nameController.clear();
        _phoneController.clear();
        await _fetchEmergencyContacts(); // Refresh the list
      } else {
        setState(() {
          _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
              .getText('error_failed_to_add_contact');
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
            .getText('error_generic') +
            ': ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEmergencyContact(String contactId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.delete(
        Uri.parse('https://eba.onrender.com/delete-emergency/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'contactId': contactId},
      );

      if (response.statusCode == 200) {
        await _fetchEmergencyContacts(); // Refresh the list
      } else {
        setState(() {
          _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
              .getText('error_failed_to_delete_contact') +
              ': ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = Provider.of<LanguageProvider>(context, listen: false)
            .getText('error_generic') +
            ': ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showAddContactDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_add,
                  size: 48,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 10),
                Text(
                  Provider.of<LanguageProvider>(context)
                      .getText('add_emergency_contact'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: Provider.of<LanguageProvider>(context)
                        .getText('full_name'),
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: Provider.of<LanguageProvider>(context)
                        .getText('phone_number'),
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: Text(
                        Provider.of<LanguageProvider>(context)
                            .getText('cancel'),
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _nameController.clear();
                        _phoneController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(
                          Provider.of<LanguageProvider>(context).getText('save')),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await _addEmergencyContact();
                        if (mounted) Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String contactId, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              Provider.of<LanguageProvider>(context).getText('delete_contact')),
          content: Text(Provider.of<LanguageProvider>(context)
              .getText('confirm_delete_contact')
              .replaceAll('{name}', name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  Text(Provider.of<LanguageProvider>(context).getText('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                await _deleteEmergencyContact(contactId);
                if (mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child:
                  Text(Provider.of<LanguageProvider>(context).getText('delete')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    Provider.of<LanguageProvider>(context)
                        .getText('emergency_contacts'),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      height: 1.2,
                    ),
                  ),
                ),
                // Add Button
                ElevatedButton(
                  onPressed: _showAddContactDialog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context)
                            .getText('add_emergency_contact'),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        Provider.of<LanguageProvider>(context)
                            .getText('contact'),
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color.fromARGB(255, 121, 115, 115)),
                ),
              ),

            // Loading indicator or contact list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _contacts.isEmpty
                      ? Center(
                          child: Text(
                            Provider.of<LanguageProvider>(context)
                                .getText('no_emergency_contacts'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return _buildContactCard(
                              title: contact['name'] ?? 'Unknown',
                              phone: contact['phone'] ?? 'N/A',
                              contactId: contact['contactId']!,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String phone,
    required String contactId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar Icon
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue[50],
            child: const Icon(Icons.person, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 16),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  phone,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Call button
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            tooltip: Provider.of<LanguageProvider>(context).getText('call'),
            onPressed: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: phone);
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Provider.of<LanguageProvider>(context)
                          .getText('error_could_not_launch_call')),
                    ),
                  );
                }
              }
            },
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: Provider.of<LanguageProvider>(context).getText('delete'),
            onPressed: () => _showDeleteConfirmationDialog(contactId, title),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}