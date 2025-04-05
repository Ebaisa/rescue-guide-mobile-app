
import 'package:flutter/material.dart';
import 'verify_phone_number_page.dart';

void main() {
  runApp(MaterialApp(
    home: PhoneSignUpPage(),
    debugShowCheckedModeBanner: false, // Hide the debug banner
  ));
}

class PhoneSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Get started with Hunger Hub",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Enter your phone number to use Hunger Hub and enjoy",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Phone number",
                hintText: "62 823-7762-8154",  // Format example for the phone number
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerifyPhonePage()),
                      );                },              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
