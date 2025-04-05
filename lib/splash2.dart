import 'package:flutter/material.dart';
import 'splash3.dart'; 
import 'signin_page.dart'; 
import 'signup_page.dart'; 

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to\nFirst Aid App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),  // Darker purple color
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/doctors.jpg',
                height: 150,
              ),
              SizedBox(height: 20),

              // Emergency Call Button (Smaller)
              SizedBox(
                width: 200,  // Fixed width for the smaller button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF019874),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {},
                  child: Text('Emergency Call', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),

              // Emergency Contact Button (Full width)
              SizedBox(
                width: double.infinity,  // Makes the button stretch across the screen
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF2D55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Splash3()),
                    );
                  },
                  child: Text('Emergency Contact', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),

              // Login Button (Full width)
              SizedBox(
                width: double.infinity,  // Makes the button stretch across the screen
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF6A1B9A)), // Darker purple border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text('Login', style: TextStyle(color: Color(0xFF6A1B9A))), // Darker purple text
                ),
              ),
              SizedBox(height: 10),

              // Sign Up Button (Full width)
              SizedBox(
                width: double.infinity,  // Makes the button stretch across the screen
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF6A1B9A)), // Darker purple border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Sign Up', style: TextStyle(color: Color(0xFF6A1B9A))), // Darker purple text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
