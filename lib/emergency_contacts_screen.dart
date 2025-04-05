import 'package:flutter/material.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<Map<String, String>> contacts = [
    {'name': 'John Doe', 'relationship': 'Father', 'phone': '123-456-7890'},
    {'name': 'Jane Smith', 'relationship': 'Friend', 'phone': '987-654-3210'},
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void addContact() {
    setState(() {
      contacts.add({
        'name': nameController.text,
        'relationship': relationshipController.text,
        'phone': phoneController.text,
      });
      nameController.clear();
      relationshipController.clear();
      phoneController.clear();
    });
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields with gaps
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10), // Gap between fields
            TextField(
              controller: relationshipController,
              decoration: InputDecoration(labelText: 'Relationship'),
            ),
            SizedBox(height: 10), // Gap between fields
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20), // Gap before Add button
            ElevatedButton(
              onPressed: addContact,
              child: Text('Add'),
            ),
            SizedBox(height: 20), // Gap before list

            // List of contacts inside a SingleChildScrollView
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.contact_phone),
                      title: Text(contacts[index]['name']!),
                      subtitle: Text(
                          '${contacts[index]['relationship']} - ${contacts[index]['phone']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteContact(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
