import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/view/profile/service/info_service.dart';
import 'package:provider/provider.dart'; // Import provider package

class AddUserInfoScreen extends StatefulWidget {
  const AddUserInfoScreen({super.key});

  @override
  State<AddUserInfoScreen> createState() => _AddUserInfoScreenState();
}

class _AddUserInfoScreenState extends State<AddUserInfoScreen> {
  final UserinfoService _userService = UserinfoService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  // Form data
  String? _selectedBloodType;
  double _height = 160;
  double _weight = 60;
  final List<String> _allergies = [];
  final TextEditingController _allergyInputController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _disabilitiesController = TextEditingController();

  List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) throw Exception('User not logged in');

      final response = await _userService.addUserInfo(
        userId: userId,
        bloodType: _selectedBloodType ?? '',
        height: _height.toString(),
        weight: _weight.toString(),
        allergies: _allergies.join(', '),
        medicalConditions: _medicalConditionsController.text,
        medications: _medicationsController.text,
        disabilities: _disabilitiesController.text,
      );

      setState(() {
        _isLoading = false;
        _isSuccess = response['success'];
        _message = response['message'];
      });

      if (_isSuccess) _formKey.currentState!.reset();
    } catch (e) {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = provider.getText('please_try_again');
      });
    }
  }

  void _addAllergy() {
    final text = _allergyInputController.text.trim();
    if (text.isNotEmpty && !_allergies.contains(text)) {
      setState(() {
        _allergies.add(text);
        _allergyInputController.clear();
      });
    }
  }

  void _removeAllergy(String item) {
    setState(() => _allergies.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text(provider.getText('your_medical_info')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blood Type
              Text(
                provider.getText('blood_type'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                items:
                    bloodTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (val) => setState(() => _selectedBloodType = val),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.bloodtype),
                  border: OutlineInputBorder(),
                  hintText: provider.getText('select_blood_type'),
                ),
                validator:
                    (val) =>
                        val == null
                            ? provider.getText('please_select_blood_type')
                            : null,
              ),
              const SizedBox(height: 20),

              // Height
              Text(
                "${provider.getText('height')}: ${_height.toInt()} cm",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 100,
                max: 250,
                value: _height,
                divisions: 150,
                label: '${_height.toInt()} cm',
                onChanged: (val) => setState(() => _height = val),
              ),
              const SizedBox(height: 20),

              // Weight
              Text(
                "${provider.getText('weight')}: ${_weight.toInt()} kg",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 30,
                max: 200,
                value: _weight,
                divisions: 170,
                label: '${_weight.toInt()} kg',
                onChanged: (val) => setState(() => _weight = val),
              ),
              const SizedBox(height: 20),

              // Allergies
              Text(
                provider.getText('allergies'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children:
                    _allergies.map((item) {
                      return Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeAllergy(item),
                      );
                    }).toList(),
              ),
              TextFormField(
                controller: _allergyInputController,
                decoration: InputDecoration(
                  labelText: provider.getText('add_allergy'),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addAllergy,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Other Fields
              _buildTextField(
                _medicalConditionsController,
                provider.getText('medical_conditions'),
                Icons.medical_services,
                provider.getText('please_enter_medical_conditions'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _medicationsController,
                provider.getText('medications'),
                Icons.medication,
                provider.getText('please_enter_medications'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _disabilitiesController,
                provider.getText('disabilities'),
                Icons.accessible,
                provider.getText('please_enter_disabilities'),
              ),

              const SizedBox(height: 24),

              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(provider.getText('save_information')),
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String validatorMessage,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator:
          (value) => value == null || value.isEmpty ? validatorMessage : null,
    );
  }
}
