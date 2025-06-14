import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:health/view/homescreen.dart';
import '../service/edit_service.dart';

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
  final EditProfileService _profileService = EditProfileService();

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
    final result = await _profileService.loadUserData();

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      setState(() {
        _userId = data['userId'];
        _nameController.text = data['name'];
        _emailController.text = data['email'];
        _phoneController.text = data['phone'];
        _selectedGender = data['gender'];
        _dobController.text = data['dob'];

        if (_dobController.text.isNotEmpty) {
          try {
            _selectedDate = DateTime.parse(_dobController.text);
          } catch (e) {
            debugPrint('Error parsing DOB: $e');
          }
        }
      });
    } else {
      setState(() => _responseMessage = result['message']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
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

    final result = await _profileService.updateProfile(
      userId: _userId!,
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: _selectedGender ?? '',
      bornDate: _dobController.text.trim(),
    );

    setState(() {
      _isLoading = false;
      _isSuccess = result['success'];
      _responseMessage = result['message'];
    });

    if (_isSuccess && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.getText('edit_profile'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ),
        ),
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 16),
                    Text(
                      provider.getText('updating_profile'),
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
                      Text(
                        provider.getText('personal_information'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: provider.getText('full_name'),
                        icon: Icons.person_outline_rounded,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? provider.getText('required')
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: provider.getText('email'),
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return provider.getText('required');
                          if (!value!.contains('@'))
                            return provider.getText('invalid_email');
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: provider.getText('phone_number'),
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? provider.getText('required')
                                    : null,
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
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: provider.getText('gender'),
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
      items: [
        DropdownMenuItem(
          value: 'Male',
          child: Text(provider.getText('male'), style: TextStyle(fontSize: 16)),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text(
            provider.getText('female'),
            style: TextStyle(fontSize: 16),
          ),
        ),
        DropdownMenuItem(
          value: 'Other',
          child: Text(
            provider.getText('other'),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onChanged: (value) => setState(() => _selectedGender = value),
      validator: (value) => value == null ? provider.getText('required') : null,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.arrow_drop_down_rounded),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildDateOfBirthField() {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: provider.getText('date_of_birth'),
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
      validator:
          (value) =>
              value?.isEmpty ?? true ? provider.getText('required') : null,
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
    final provider = Provider.of<LanguageProvider>(context, listen: false);
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
        child: Text(
          provider.getText('save_changes'),
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
