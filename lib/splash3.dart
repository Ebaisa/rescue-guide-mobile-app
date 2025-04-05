import 'package:flutter/material.dart';
import 'signin_page.dart'; 
import 'signup_page.dart'; 

class Splash3 extends StatelessWidget {
  get screenWidth => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Add padding for the content
        child: SingleChildScrollView(  // Allow scrolling if content exceeds the screen height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Main title with smaller text size
              Text(
                "Welcome to\nFirst Aid App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,  // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF432C81),
                ),
              ),
              SizedBox(height: 10),  // Reduced height to bring text closer to the image

              // Image section
              Container(
                padding: EdgeInsets.only(top: 20), // Adjusted top padding for better spacing
                margin: EdgeInsets.zero,
                child: Image.asset(
                  'assets/images/emergency.jpeg', // Replace with actual image asset
                  width: screenWidth,  // Full screen width
                  height: 300, 
                  fit: BoxFit.cover, // Ensures image fits well within the box
                ),
              ),
              SizedBox(height: 10),  // Adjusted spacing between image and buttons

              // Login and SignUp buttons with better spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF06A881), // Background color set to #06A881
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10), // Spacing between buttons

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF06A881), // Background color set to #06A881
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 10),

              // "Already have an account?" TextButton
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.black), // Style the text as black
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Color(0xFF06A881), // Make it a link color (#06A881)
                    decoration: TextDecoration.underline, // Optional: underline to indicate a link
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

class EmergencyContact extends StatelessWidget {
  final String service;
  final String number;

  EmergencyContact(this.service, this.number);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8), // Add margin between contacts
      child: ListTile(
        leading: Icon(Icons.local_phone, color: Colors.blue),
        title: Text("$service - $number"),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }
}
