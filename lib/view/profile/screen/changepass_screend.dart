import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/view/profile/service/password_service.dart';
import 'package:provider/provider.dart'; // Import provider package

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final PasswordService _passwordService = PasswordService();
  bool _isLoading = false;
  bool _isSuccess = false;
  String _responseMessage = '';

  @override
  void initState() {
    super.initState();
    _passwordService.loadUserId();
  }

  Future<void> _changePassword() async {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;

    if (_passwordService.newPasswordController.text !=
        _passwordService.confirmPasswordController.text) {
      setState(() {
        _responseMessage = provider.getText('passwords_do_not_match');
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    final result = await _passwordService.changePassword(
      userId: _passwordService.userId!,
      oldPassword: _passwordService.oldPasswordController.text,
      newPassword: _passwordService.newPasswordController.text,
    );

    setState(() {
      _isLoading = false;
      _isSuccess = result['success'];
      _responseMessage = result['message'];
    });

    if (_isSuccess) {
      _passwordService.clearControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.getText('change_password')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.getText('create_new_password'),
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.getText('password_difference_instruction'),
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                controller: _passwordService.oldPasswordController,
                label: provider.getText('current_password'),
                obscureText: _passwordService.obscureOldPassword,
                onToggle:
                    () => setState(() {
                      _passwordService.obscureOldPassword =
                          !_passwordService.obscureOldPassword;
                    }),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _passwordService.newPasswordController,
                label: provider.getText('new_password'),
                obscureText: _passwordService.obscureNewPassword,
                onToggle:
                    () => setState(() {
                      _passwordService.obscureNewPassword =
                          !_passwordService.obscureNewPassword;
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return provider.getText('please_enter_new_password');
                  }
                  if (value.length < 6) {
                    return provider.getText('password_too_short');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _passwordService.confirmPasswordController,
                label: provider.getText('confirm_new_password'),
                obscureText: _passwordService.obscureConfirmPassword,
                onToggle:
                    () => setState(() {
                      _passwordService.obscureConfirmPassword =
                          !_passwordService.obscureConfirmPassword;
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return provider.getText('please_confirm_new_password');
                  }
                  if (value != _passwordService.newPasswordController.text) {
                    return provider.getText('passwords_do_not_match');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              if (_responseMessage.isNotEmpty) _buildStatusMessage(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey[600],
          ),
          onPressed: onToggle,
          splashRadius: 22,
          tooltip:
              obscureText
                  ? provider.getText('show_password')
                  : provider.getText('hide_password'),
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _isSuccess ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isSuccess ? Colors.green.shade300 : Colors.red.shade300,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color:
                _isSuccess
                    ? const Color.fromARGB(255, 219, 255, 220)
                    : Colors.red.shade100,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon(
          //   _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
          //   color: _isSuccess ? Colors.green.shade700 : Colors.red.shade700,
          //   size: 28,
          // ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _responseMessage,
              style: TextStyle(
                color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _changePassword,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.blueAccent.shade200,
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  provider.getText('change_password'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordService.dispose();
    super.dispose();
  }
}
