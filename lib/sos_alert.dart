import 'package:flutter/material.dart';

void main() {
  runApp(const RescueGuideApp());
}

class RescueGuideApp extends StatelessWidget {
  const RescueGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SosAlert(),
    );
  }
}

class SosAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RescueGuide App'),
        elevation: 0, // Removes the shadow under the AppBar
        backgroundColor: Colors.transparent, // Makes the background transparent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Removed the Row with icons at the top

            // User Greeting
            Text('User Name\nWelcome!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('John Doe'),
              subtitle: Text('+123456789'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Jane Smith'),
              subtitle: Text('+987654321'),
            ),
            SizedBox(height: 20),
            Text('First Aid Guidelines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Emergency'),
                          Text('Burns'),
                          Text('Steps to follow')
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Urgent'),
                          Text('Cuts'),
                          Text('Procedure details')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF06A881), // Green background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rectangular shape
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40), // More rectangular look
                ),
                child: Text(
                  'Send SOS Alert',
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 16, // Optional: Adjust text size for a better appearance
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
