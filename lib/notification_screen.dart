import 'package:flutter/material.dart';
import 'sos_alert_screen.dart';
import 'feedback.dart';
import 'contacts.dart';
import 'first_aid_topics_page.dart';
import 'emergency_contacts_screen.dart';
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Column( // Wrap the body with Column to organize both the ListView and the buttons.
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildNotificationItem("Notification Title", "Lorem ipsum dolor sit amet."),
                _buildNotificationItem("Notification Title", "Lorem ipsum dolor sit amet."),
                _buildNotificationItem("Notification Title", "Lorem ipsum dolor sit amet."),
              ],
            ),
          ),
          _buildFourButtonsWithEmojis(context), // Add this at the bottom of the screen
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.notifications, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }

  // The bottom emoji buttons widget
  Widget _buildFourButtonsWithEmojis(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonWithEmojiAndText(context, '🚨', 'SOS Alert', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SosAlertScreen()),
            );
          }),
          _buildButtonWithEmojiAndText(context, '🩺', 'First Aid', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FirstAidTopicsPage()),
            );
          }),
          _buildButtonWithEmojiAndText(context, '🚑', 'Hospital', () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HospitalScreen()),
            // );
          }),
          _buildButtonWithEmojiAndText(context, '📞', 'Contact', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmergencyContacts()),
            );
          }),
          _buildButtonWithEmojiAndText(context, '📋', 'Feedback', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackFormPage()),
            );
          }),
        ],
      ),
    );
  }

  // Updated method to use emojis with text
  Widget _buildButtonWithEmojiAndText(BuildContext context, String emoji, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 15), // Increase the emoji size
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
