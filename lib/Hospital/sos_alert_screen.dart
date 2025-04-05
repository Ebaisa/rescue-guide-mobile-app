import 'package:flutter/material.dart';

class SOSAlertsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Incoming SOS Alerts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: Central Park"),
            Text("Timestamp: 14:30"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text("Send Location Updates"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("View First Aid Guidelines"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Nearby Hospitals"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 16),
            Text("Alert #1 - Pending"),
            Text("5 min ago"),
            Text("Alert #2 - Confirmed"),
            Text("10 min ago"),
            Text("Alert #3 - Resolved"),
            Text("15 min ago"),
          ],
        ),
      ),
    );
  }
}
