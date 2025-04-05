import 'package:flutter/material.dart';
// Import the necessary pages (like FeedbackFormPage and RealTimeLocationPage)
import 'location.dart'; // Assuming your RealTimeLocationPage is located here
// import 'feedback_form.dart'; // Assuming the FeedbackFormPage is in this file
import 'sos_alert.dart'; 
import 'contacts.dart';
import 'first_aid_topics_page.dart';
import 'emergency_contacts_screen.dart';

class SosAlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SOS Alert')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SOS Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF06A881), // Green background for SOS Button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // More padding for rectangular look
                ),
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SosAlert()),
                    );                },
                child: Text('Large SOS Button', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),

            // Emergency Contacts
            Text('Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.phone),
                iconColor: Color(0xFF06A881), // You can change this to any color you prefer

              title: Text('Emergency Contact 1'),
              subtitle: Text('123-456-7890'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Emergency Contact 2'),
                iconColor: Color(0xFF06A881), // You can change this to any color you prefer

              subtitle: Text('987-654-3210'),
            ),
            SizedBox(height: 20),

            // Additional Information
            Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Are you sure you want to send an SOS alert?'),
            ),
            SizedBox(height: 20),

            // Cancel and Send Alert buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // When pressed, return to the previous screen
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background for Cancel button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      side: BorderSide(color: Color(0xFF06A881), width: 0.5), // Green border for Cancel button
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Color(0xFF06A881))), // Green text color
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF019874),  // Green background for Send Alert button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  onPressed: () {
                    // Navigate to SosAlertScreen when "Send Alert" is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RealTimeLocationPage()),
                    );
                  },
                  child: Text('Send Alert', style: TextStyle(color: Colors.white)), // White text color
                ),
              ],
            ),

            SizedBox(height: 60),

            // Section for buttons with icons (Updated with better layout)
            _buildIconRow(context),
          ],
        ),
      ),
    );
  }

  // This method creates a row with icon buttons
  Widget _buildIconRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconWithName(context, '🚨', 'SOS Alert', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SosAlert()));

        }),
        _buildIconWithName(context, '🩺', 'First Aid', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FirstAidTopicsPage()));

        }),
        _buildIconWithName(context, '🚑', 'Emergency', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContacts()));

        }),
        _buildIconWithName(context, '📞', 'Contact', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContacts()));

        }),
      ],
    );
  }

  // Method to create an individual button with icon and label
  Widget _buildIconWithName(BuildContext context, String icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: Color(0xFF06A881), // Green background for buttons
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
