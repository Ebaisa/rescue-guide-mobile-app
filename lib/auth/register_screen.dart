import 'package:flutter/material.dart';
import 'package:health/auth/service/auth_service.dart';
import 'package:health/auth/service/user_service.dart';
import 'package:health/auth/widget/register_form.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize services directly in the screen
    final UserService userService = UserService();
    final AuthService authService = AuthService();
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
           languageProvider.getText('create_account') , 
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            RegisterForm(userService: userService, authService: authService),
          ],
        ),
      ),
    );
  }
}
