import 'package:flutter/material.dart';
import 'register_completed_page.dart'; // Make sure to import the RegistrationCompletedPage

class RegisterEmergencyPage extends StatefulWidget {
  @override
  _RegisterEmergencyPageState createState() => _RegisterEmergencyPageState();
}

class _RegisterEmergencyPageState extends State<RegisterEmergencyPage> {
  final _formKey = GlobalKey<FormState>(); // Key to manage form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Wrap the body with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "REGISTER YOUR EMERGENCY",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,  // Assign form key for validation
                child: Column(
                  children: [
                    CustomTextField(
                      hint: "Full Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Blood Type",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your blood type';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Full Name Emergency",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the emergency contact name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Phone No",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      hint: "Password",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // If the form is valid, show a snackbar and navigate
                        if (_formKey.currentState?.validate() ?? false) {
                          // Form is valid, handle registration logic here
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registering...')));
                          
                          // After successful registration, navigate to the RegistrationCompletedPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationCompletedPage(),
                            ),
                          );
                        }
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final String? Function(String?)? validator; // Validator for input validation

  CustomTextField({required this.hint, this.obscureText = false, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        validator: validator, // Add the validator for required field and validation
      ),
    );
  }
}
