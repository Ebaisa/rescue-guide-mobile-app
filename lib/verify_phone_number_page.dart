import 'package:flutter/material.dart';
import 'dart:async';  // For the timer
import 'register_emergency_contact_page.dart'; 

class VerifyPhonePage extends StatefulWidget {
  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  // List to hold the values of OTP digits
  List<String> otp = ["", "", "", ""];
  
  // Variables for the countdown timer
  int _start = 32;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _startTimer();
  }

  // Start the countdown timer
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centering the "Verify phone number" text
            Center(
              child: Text(
                "Verify phone number",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Enter the 4-digit code sent to you on +9985 9565654",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => OTPBox(
                onChanged: (value) {
                  setState(() {
                    otp[index] = value;  // Update the otp list with the value entered
                  });
                },
                initialValue: otp[index],  // Show current value in the box
              )),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Didn’t receive? Send again",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Resend in $_start",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _start == 0 ? _startTimer : null, // Only allow clicking when countdown ends
                child: Text("RESEND LINK"),
              ),
            ),
            SizedBox(height: 20),
            // Terms and conditions & Privacy policy text
            Center(
              child: Text(
                "By signing up, you have agreed to our \nTerms and conditions & Privacy policy",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterEmergencyPage()),
                      );                },
                child: Text("START"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPBox extends StatelessWidget {
  final Function(String) onChanged;
  final String initialValue;

  OTPBox({required this.onChanged, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        keyboardType: TextInputType.number,
        maxLength: 1,  // Restrict input to 1 character
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "", // Hide the character counter
          border: InputBorder.none,
        ),
        onChanged: onChanged,  // Handle text changes
      ),
    );
  }
}
