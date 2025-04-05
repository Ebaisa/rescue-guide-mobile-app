import 'package:flutter/material.dart';

class SOSDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SOS Alert Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Incoming Alerts"),
            alertItem("Location: Central Park", "Timestamp: 14:30"),
            alertItem("Location: Main Street", "Timestamp: 14:32"),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Send Location"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("First Aid Guidelines"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Nearby Hospitals"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Recent SOS Logs"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Recent SOS Logs"),
            alertItem("Alert 1", "Status: Confirmed"),
            alertItem("Alert 2", "Status: Pending"),
            alertItem("Alert 3", "Status: Resolved"),
          ],
        ),
      ),
    );
  }

  Widget alertItem(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.all(16),
    );
  }
}
