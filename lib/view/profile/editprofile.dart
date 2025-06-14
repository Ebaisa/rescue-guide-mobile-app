import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health/view/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;
  String _responseMessage = '';
  bool _isSuccess = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedUserId = prefs.getString('user_id');

      if (loadedUserId == null || loadedUserId.isEmpty) {
        setState(
          () => _responseMessage = 'User session expired. Please login again.',
        );
        return;
      }

      setState(() {
        _userId = loadedUserId;
        _nameController.text = prefs.getString('user_name') ?? '';
        _emailController.text = prefs.getString('user_email') ?? '';
        _phoneController.text = prefs.getString('user_phone') ?? '';
        _selectedGender = prefs.getString('user_gender');
        _dobController.text = prefs.getString('user_dob') ?? '';

        if (_dobController.text.isNotEmpty) {
          try {
            _selectedDate = DateTime.parse(_dobController.text);
          } catch (e) {
            debugPrint('Error parsing DOB: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() => _responseMessage = 'Failed to load profile data');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 6570)), // ~18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = '';
      _isSuccess = false;
    });

    try {
      final payload = {
        'userId': _userId!,
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'gender': _selectedGender ?? '',
        'bornDate': _dobController.text.trim(),
      };

      debugPrint('Sending update payload: $payload');

      final response = await http.post(
        Uri.parse('https://eba.onrender.com/edit-user/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: Uri(queryParameters: payload).query,
      );

      debugPrint('API Response: ${response.statusCode} - ${response.body}');

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await _saveProfileDataLocally(prefs);

        setState(() {
          _isSuccess = true;
          _responseMessage =
              responseBody['message'] ?? 'Profile updated successfully!';
        });

        await Future.delayed(const Duration(seconds: 1));
        if (mounted)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      setState(() => _responseMessage = 'Please Try Again');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfileDataLocally(SharedPreferences prefs) async {
    try {
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_phone', _phoneController.text.trim());
      await prefs.setString('user_gender', _selectedGender ?? '');
      await prefs.setString('user_dob', _dobController.text.trim());

      if (_dobController.text.isNotEmpty) {
        try {
          final age =
              DateTime.now()
                  .difference(DateTime.parse(_dobController.text))
                  .inDays ~/
              365;
          await prefs.setInt('user_age', age);
        } catch (e) {
          debugPrint('Age calculation error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error saving profile locally: $e');
    }
  }

  void _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      debugPrint('Error response: $errorData');

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

      setState(() => _responseMessage = errorMessage);
    } catch (e) {
      debugPrint('Error parsing error response: $e');
      setState(() => _responseMessage = 'Error: ${response.body}');
    }
  }

  // [Keep all your existing methods exactly as they are]
  // _loadUserData(), _selectDate(), _updateProfile(),
  // _saveProfileDataLocally(), _handleErrorResponse()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 16),
                    Text(
                      'Updating profile...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Required';
                          if (!value!.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildGenderDropdown(),
                      const SizedBox(height: 16),
                      _buildDateOfBirthField(),
                      const SizedBox(height: 24),
                      if (_responseMessage.isNotEmpty) _buildStatusMessage(),
                      const SizedBox(height: 16),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.transgender_outlined, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: const [
        DropdownMenuItem(
          value: 'Male',
          child: Text('Male', style: TextStyle(fontSize: 16)),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text('Female', style: TextStyle(fontSize: 16)),
        ),
        DropdownMenuItem(
          value: 'Other',
          child: Text('Other', style: TextStyle(fontSize: 16)),
        ),
      ],

      onChanged: (value) => setState(() => _selectedGender = value),
      validator: (value) => value == null ? 'Required' : null,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.arrow_drop_down_rounded),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildDateOfBirthField() {
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildStatusMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isSuccess ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSuccess ? Colors.green[100]! : Colors.red[100]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: _isSuccess ? Colors.green : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _responseMessage,
              style: TextStyle(
                color: _isSuccess ? Colors.green[800] : Colors.red[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'SAVE CHANGES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
