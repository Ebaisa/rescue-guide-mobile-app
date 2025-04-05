import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sos_alert_screen.dart';
import 'feedback.dart';
import 'first_aid_topics_page.dart';
import 'emergency_contacts_screen.dart';

class EmergencyContacts extends StatefulWidget {
  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addContact() async {
    if (_nameController.text.isEmpty ||
        _relationshipController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(_currentUser?.uid)
          .collection('emergency_contacts')
          .add({
        'name': _nameController.text,
        'relationship': _relationshipController.text,
        'phone': _phoneController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _relationshipController.clear();
      _phoneController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteContact(String docId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser?.uid)
          .collection('emergency_contacts')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete contact: ${e.toString()}')),
      );
    }
  }

  Future<void> _editContact(String docId) async {
    _nameController.text = '';
    _relationshipController.text = '';
    _phoneController.text = '';

    // First get the current contact data
    final doc = await _firestore
        .collection('users')
        .doc(_currentUser?.uid)
        .collection('emergency_contacts')
        .doc(docId)
        .get();

    if (doc.exists) {
      _nameController.text = doc['name'];
      _relationshipController.text = doc['relationship'];
      _phoneController.text = doc['phone'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, 'Name', 'Enter Name'),
              _buildTextField(_relationshipController, 'Relationship',
                  'Enter Relationship'),
              _buildTextField(
                  _phoneController, 'Phone Number', 'Enter Phone Number',
                  keyboardType: TextInputType.phone),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  await _firestore
                      .collection('users')
                      .doc(_currentUser?.uid)
                      .collection('emergency_contacts')
                      .doc(docId)
                      .update({
                    'name': _nameController.text,
                    'relationship': _relationshipController.text,
                    'phone': _phoneController.text,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contact updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Failed to update contact: ${e.toString()}')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Name', 'Enter Name'),
            SizedBox(height: 10),
            _buildTextField(
                _relationshipController, 'Relationship', 'Enter Relationship'),
            SizedBox(height: 10),
            _buildTextField(
                _phoneController, 'Phone Number', 'Enter Phone Number',
                keyboardType: TextInputType.phone),
            SizedBox(height: 10),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF06A881)),
              onPressed: _addContact,
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_currentUser?.uid)
                    .collection('emergency_contacts')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No contacts added yet'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.phone, color: Color(0xFF06A881)),
                          title: Text(data['name']),
                          subtitle: Text(
                              '${data['relationship']} - ${data['phone']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.edit, color: Color(0xFF06A881)),
                                onPressed: () => _editContact(doc.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteContact(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconButton(Icons.warning, 'SOS Alert', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SosAlertScreen()));
          }),
          _buildIconButton(Icons.health_and_safety, 'First Aid', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FirstAidTopicsPage()));
          }),
          _buildIconButton(Icons.local_hospital, 'Emergency', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmergencyContacts()));
          }),
          _buildIconButton(Icons.phone, 'Contacts', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmergencyContacts()));
          }),
          _buildIconButton(Icons.feedback, 'Feedback', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedbackFormPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(icon, color: Color(0xFF06A881)), onPressed: onTap),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
