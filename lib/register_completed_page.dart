import 'package:flutter/material.dart';

class RegistrationCompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thank you for registration",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset("assets/images/livesaver.png", height: 150), // Replace with an actual image
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Edit the contact addresses"),
            ),
            SizedBox(height: 20),
            Text("Don't have an account?"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.warning, size: 40), // SOS Alert
                Icon(Icons.medical_services, size: 40), // First Aid
                Icon(Icons.phone, size: 40), // Emergency
                Icon(Icons.feedback, size: 40), // Feedback
              ],
            ),
          ],
        ),
      ),
    );
  }
}
