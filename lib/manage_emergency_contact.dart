import 'package:flutter/material.dart';

class EmergencyContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Emergency Contacts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Family", style: TextStyle(fontWeight: FontWeight.bold)),
            contactItem("John Doe", "Brother"),
            SizedBox(height: 10),
            Text("Friends", style: TextStyle(fontWeight: FontWeight.bold)),
            contactItem("Jane Smith", "Best Friend"),
            SizedBox(height: 10),
            Text("Emergency Services", style: TextStyle(fontWeight: FontWeight.bold)),
            contactItem("911", "Local Emergency Number"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text("Add Contact"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Edit Contact"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Delete Contact"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Name")),
            TextField(decoration: InputDecoration(labelText: "Relationship")),
            TextField(decoration: InputDecoration(labelText: "Phone Number")),
          ],
        ),
      ),
    );
  }

  Widget contactItem(String name, String relationship) {
    return ListTile(
      title: Text(name),
      subtitle: Text(relationship),
      leading: Icon(Icons.person),
    );
  }
}
