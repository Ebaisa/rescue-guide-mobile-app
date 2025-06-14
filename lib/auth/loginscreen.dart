import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/auth/service/auth_service.dart';
import 'package:health/auth/service/user_service.dart';
import 'package:health/auth/widget/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final AuthService authService = AuthService();
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: IconButton(
              onPressed: () {
                final newLanguage =
                    languageProvider.currentLanguage == 'en' ? 'am' : 'en';
                languageProvider.changeLanguage(newLanguage);
              },
              icon: Text(
                languageProvider.currentLanguage == 'en' ? 'AM' : 'EN',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              tooltip: languageProvider.getText('toggle_language'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              languageProvider.getText('welcome_back'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.getText('login_to_account'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            LoginForm(userService: userService, authService: authService),
          ],
        ),
      ),
    );
  }
}
