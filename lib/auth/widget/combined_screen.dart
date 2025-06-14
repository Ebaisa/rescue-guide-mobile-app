import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:health/provider/languageprovider.dart';

class CustomFields {
  static Widget dobField({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: languageProvider.getText('date_of_birth'),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: onTap,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return languageProvider.getText('select_date_of_birth');
        }
        return null;
      },
    );
  }

  static Widget emailField({
    required BuildContext context,
    required TextEditingController controller,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: languageProvider.getText('email'),
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return languageProvider.getText('enter_email');
        }
        if (!value.contains('@')) {
          return languageProvider.getText('enter_valid_email');
        }
        return null;
      },
    );
  }

  static Widget genderDropdown({
    required BuildContext context,
    required String? selectedGender,
    required Function(String?) onChanged,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: languageProvider.getText('gender'),
        prefixIcon: const Icon(Icons.transgender_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: 'Male',
          child: Text(languageProvider.getText('male')),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text(languageProvider.getText('female')),
        ),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return languageProvider.getText('select_gender');
        }
        return null;
      },
    );
  }

  static Widget loginButton({
    required BuildContext context,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  languageProvider.getText('login'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  static Widget loginPrompt(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(languageProvider.getText('already_have_account')),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            languageProvider.getText('login'),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Widget passwordField({
    required BuildContext context,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
    String label = 'Password',
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: languageProvider.getText(label.toLowerCase()),
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator,
    );
  }

  static Widget registerButton({
    required BuildContext context,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  languageProvider.getText('register'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  static Widget registerPrompt(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(languageProvider.getText('no_account')),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            languageProvider.getText('register'),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Widget responseMessage({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    bool showIcon = true,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final Color bgColor = isSuccess ? Colors.green[50]! : Colors.red[50]!;
    final Color borderColor = isSuccess ? Colors.green : Colors.red;
    final Color textColor = isSuccess ? Colors.green[800]! : Colors.red[800]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon)
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: textColor,
            ),
          if (showIcon) const SizedBox(width: 8),
          Flexible(
            child: Text(
              languageProvider.getText(message.toLowerCase()) ==
                      message.toLowerCase()
                  ? message
                  : languageProvider.getText(message.toLowerCase()),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static Widget textFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: languageProvider.getText(label.toLowerCase()),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
