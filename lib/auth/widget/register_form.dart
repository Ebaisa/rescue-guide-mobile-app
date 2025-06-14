import 'package:flutter/material.dart';
import 'package:health/auth/service/auth_service.dart';
import 'package:health/auth/service/user_service.dart';
import 'package:health/auth/widget/combined_screen.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterForm extends StatefulWidget {
  final UserService userService;
  final AuthService authService;

  const RegisterForm({
    Key? key,
    required this.userService,
    required this.authService,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}



class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();


  String? _selectedGender;
  DateTime? _selectedDate;
  String _responseMessage = '';
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _obscurePassword = true;

  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      setState(() {
        _responseMessage = 'Please select your gender';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseMessage = '';
      _isSuccess = false;
    });


    try {
      final response = await widget.userService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender!,
        bornDate: _dobController.text.trim(),
      );
      
      if (response.success && response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await _saveProfileDataLocally(prefs);
        // await widget.authService.saveUserData(response.user!);
        setState(() {
          _isSuccess = true;
          _responseMessage = response.message;
        });

        if (mounted) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        }
      } else {
        setState(() {
          _isSuccess = false;
          _responseMessage = response.errors?.join('\n') ?? response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _responseMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
     final languageProvider = Provider.of<LanguageProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFields.textFormField(
             context: context,controller: _nameController , label: languageProvider.getText('full_name') ,  icon: Icons.person_outline, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },),
          // TextFormFieldWidget(
          //   controller: _nameController,
          //   label: 'Full Name',
          //   icon: Icons.person_outline,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your full name';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(height: 16),
          CustomFields.textFormField(
            context: context,
            controller: _emailController , label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },),
          // TextFormFieldWidget(
          //   controller: _emailController,
          //   label: 'Email',
          //   icon: Icons.email_outlined,
          //   keyboardType: TextInputType.emailAddress,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your email';
          //     }
          //     if (!RegExp(
          //       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
          //     ).hasMatch(value)) {
          //       return 'Please enter a valid email';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(height: 16),
          CustomFields.passwordField(
            context: context,
            controller: _passwordController , obscureText: _obscurePassword ,
           validator: (value){
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
           },
           onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },),
          // PasswordField(
         //   controller: _passwordController,
          //   obscureText: _obscurePassword,
          //   onToggleVisibility: () {
          //     setState(() {
          //       _obscurePassword = !_obscurePassword;
          //      });
          //   },
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your password';
          //     }
          //     if (value.length < 6) {
          //       return 'Password must be at least 6 characters';
          //     }
          //     return null;
          //   }, label: '',
          // ),
          const SizedBox(height: 16),
          CustomFields.textFormField(context: context,
            controller: _phoneController , label: languageProvider.getText('phone_number'), icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },),
          // TextFormFieldWidget(
          //   controller: _phoneController,
          //   label: 'Phone Number',
          //   icon: Icons.phone_outlined,
          //   keyboardType: TextInputType.phone,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter your phone number';
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(height: 16),

          CustomFields.genderDropdown(
            context: context,
            selectedGender: _selectedGender, onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          }),


          

    
          // GenderDropdown(
          //   selectedGender: _selectedGender,
          //   onChanged: (value) {
          //     setState(() {
          //       _selectedGender = value;
          //     });
          //   },
          // ),
          const SizedBox(height: 16),
          CustomFields.dobField(context: context,
            controller: _dobController,
            onTap: () => _selectDate(context),
          ),
          // DobField(
          //   controller: _dobController,
          //   onTap: () => _selectDate(context),
          // ),
          const SizedBox(height: 32),
          CustomFields.registerButton(context: context,
            isLoading:_isLoading, onPressed: _registerUser),
          // RegisterButton(isLoading: _isLoading, onPressed: _registerUser),
          const SizedBox(height: 16),
          if (_responseMessage.isNotEmpty)
            CustomFields.responseMessage(context: context,
              message: _responseMessage, isSuccess: _isSuccess),
            // ResponseMessage(message: _responseMessage, isSuccess: _isSuccess),
          const SizedBox(height: 24),
          CustomFields.loginPrompt(context),
          // const LoginPrompt(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
