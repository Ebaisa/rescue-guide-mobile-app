import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sos_alert_screen.dart';
import 'feedback.dart';
import 'contacts.dart';
import 'first_aid_topics_page.dart';
import 'emergency_contacts_screen.dart';
import 'welcome_user.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _profileImage = File(pickedFile.path);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied')),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : AssetImage('assets/profile_image.jpg')) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFF019874),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'Guest User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user?.email != null)
                Text(
                  user!.email!,
                  style: TextStyle(fontSize: 14),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildUserProfile(context),
            SizedBox(height: 20),
            _buildElevatedButton(context, 'First Aid Guidelines', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FirstAidTopicsPage()));
            }),
            _buildElevatedButton(context, 'Emergency Services', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmergencyContactsScreen()));
            }),
            _buildElevatedButton(
              context,
              'Contacts',
              () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmergencyContacts()));
              },
            ),
            _buildElevatedButton(
              context,
              'Feedback',
              () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackFormPage()));
              },
            ),
            SizedBox(height: 20),
            _buildElevatedButton(
              context,
              'SOS Alert',
              () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SosAlertScreen()));
              },
              textColor: Colors.white,
              backgroundColor: Color(0xFF019874),
            ),
            SizedBox(height: 20),
            _buildFourButtonsWithIcons(context),
            SizedBox(height: 20),
            _buildIconRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ));
  }

  Widget _buildIconRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconWithName(context, '🚨', 'SOS Alert', SosAlertScreen()),
        _buildIconWithName(context, '🩺', 'First Aid', FirstAidTopicsPage()),
        _buildIconWithName(context, '🚑', 'Emergency', EmergencyContacts()),
        _buildIconWithName(context, '📞', 'Contact', EmergencyContacts()),
        _buildIconWithName(context, '📋', 'Feedback', FeedbackFormPage()),
      ],
    );
  }

  Widget _buildIconWithName(
      BuildContext context, String emoji, String name, Widget page) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          Text(name, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFourButtonsWithIcons(BuildContext context) {
    return Column(
      children: [
        _buildButtonWithIcon(context, '🚨', 'SOS Alert', SosAlertScreen()),
        _buildButtonWithIcon(context, '🩺', 'First Aid', FirstAidTopicsPage()),
        _buildButtonWithIcon(context, '🚑', 'Emergency', EmergencyContacts()),
        _buildButtonWithIcon(context, '📞', 'Contact', EmergencyContacts()),
        _buildButtonWithIcon(context, '📋', 'Feedback', FeedbackFormPage()),
      ],
    );
  }

  Widget _buildButtonWithIcon(
      BuildContext context, String icon, String text, Widget page) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(icon, style: TextStyle(fontSize: 20)),
            Text(text, style: TextStyle(color: Colors.black)),
            Text('🙂', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}