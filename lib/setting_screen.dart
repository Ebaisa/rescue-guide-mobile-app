import 'package:flutter/material.dart';
import 'notification_screen.dart'; // Import NotificationScreen
// import 'account_screen.dart'; // Import other screens
// import 'appearance_screen.dart';
// import 'privacy_screen.dart';
// import 'sound_screen.dart';
// import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Color(0xFF06A881), // Make the settings text purple
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            // User profile section
            CircleAvatar(
              backgroundColor:Color(0xFF06A881),
              radius: 50, // You can adjust the size as needed
              child: Icon(Icons.person, color: Colors.white, size: 40), // Adjust size of icon
            ),
            SizedBox(height: 10), // Add some space between the avatar and text
            Text(
              "Julia Mario",
              style: TextStyle(
                color: Color(0xFF06A881), // Slightly purple color for the name
                fontWeight: FontWeight.bold, // Make the name bold
                fontSize: 18, // Adjust the font size
              ),
            ),
            SizedBox(height: 5), // Add some space between the name and email
            Text(
              "juliamario@email.com",
              style: TextStyle(
                color: Color(0xFF06A881), // Slightly lighter purple for the email
                fontSize: 14, // Smaller font size for the email
              ),
            ),
            Divider(),

            // Option items
            _buildOptionItem(context, Icons.account_circle, "Account", NotificationScreen()),
            _buildOptionItem(context, Icons.notifications, "Notification", NotificationScreen()), // Update navigation
            _buildOptionItem(context, Icons.palette, "Appearance", NotificationScreen()),
            _buildOptionItem(context, Icons.lock, "Privacy & Security", NotificationScreen()),
            _buildOptionItem(context, Icons.volume_up, "Sound", NotificationScreen()),
            _buildOptionItem(context, Icons.language, "Language", NotificationScreen()),

            SizedBox(height: 20), // Add some space after buttons
          ],
        ),
      ),
    );
  }

  // Pass context to this method explicitly
  Widget _buildOptionItem(BuildContext context, IconData icon, String title, Widget destinationScreen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          color:Color(0xFF06A881), // Slightly purple color for the option text
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to the specified screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
    );
  }
}
