import 'package:flutter/material.dart';
import 'reset_link_page.dart'; 

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
        elevation: 0, // Removes shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // To handle keyboard overlap on smaller screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title and description with better styling
              Padding(
                padding: const EdgeInsets.only(top: 40.0), // Add some top padding
                child: Text(
                  "Reset Your Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF019874),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your email address and we will send you a reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),

              // Email input field with styling
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  prefixIcon: Icon(Icons.email, color:  Color(0xFF019874)),
                ),
              ),
              SizedBox(height: 30),

              // Reset Password Button with white text color
              ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResendLinkPage()),
                      );
                    },
                child: Text("RESET PASSWORD", style: TextStyle(fontSize: 16, color: Colors.white)),  // Set text color to white
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFF019874),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
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
}
