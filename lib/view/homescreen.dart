import 'package:flutter/material.dart';
import 'package:health/view/widget/quick_action..dart';
import 'package:provider/provider.dart';
import 'package:health/models/contact_model.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/service/contact_service.dart';
import 'package:health/view/aid/firstaidscreen.dart';
import 'package:health/view/chatbotscreen.dart';
import 'package:health/view/emergency/emergencyscreen.dart';
import 'package:health/view/map.dart';
import 'package:health/view/profile/screen/profile_screen.dart';
import 'package:health/websocket/toggleview.dart';
import 'package:health/view/widget/contact_item.dart';
import 'package:health/view/widget/emergency_button.dart';
import 'package:health/view/widget/newsui.dart';

import 'package:health/view/widget/welcome_section.dart';
import 'package:health/websocket/nearby_hospital.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final ContactService _contactService = ContactService();

  String _userName = 'Guest';
  String _userEmail = 'No email';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.loadUserData();

    setState(() {
      print(userData);
      _userName = userData['name']?.toString() ?? 'Unknown User';
      _userEmail = userData['email']?.toString() ?? 'No email';
      _userId = userData['id']?.toString() ?? '';
    });
  }

void _handleActionSelected(BuildContext context, String actionKey) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final actionTranslations = {
      'first_aid': languageProvider.getText('first_aid'),
      'nearby_hospital': languageProvider.getText('nearby_hospital'),
      'emergency_contacts': languageProvider.getText('emergency_contacts'),
      'profile': languageProvider.getText('profile'),
      'sos_emergency': languageProvider.getText('sos_emergency'),
      'chat_with_doctor': languageProvider.getText('chat_with_doctor'),
    };

    final action = actionTranslations[actionKey] ?? actionKey;

    switch (actionKey) {
      case 'first aid':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstAidScreen()),
        );
        break;
      case 'nearby hospital':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HospitalFinderLauncher(),
          ),
        );
        break;
      case 'emergency contacts':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmergencyContactsScreen()),
        );
        break;
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 'sos emergency':
        print(_userId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SOSHistoryScreen(userId: _userId),
          ),
        );
        break;
      case 'chat with doctor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatBotScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageProvider
                  .getText('action_not_implemented')
                  .replaceAll('{action}', action),
            ),
          ),
        );
    }
  }

  Widget _buildEmergencyContacts() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return FutureBuilder<List<Contact>>(
      future: _contactService.fetchEmergencyContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text(languageProvider.getText('reload'));
        }

        final contacts = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getText('emergency_contacts'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            if (contacts.isEmpty)
              Text(
                languageProvider.getText('no_emergency_contacts'),
                style: const TextStyle(color: Colors.grey),
              )
            else
              ...contacts
                  .take(2)
                  .map(
                    (contact) => ContactItem(
                      name: contact.name,
                      phone: contact.phoneNumber,
                    ),
                  )
                  .toList(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_userId);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeSection(userName: _userName),
              const SizedBox(height: 30),
              QuickActions(
                onActionSelected:
                    (action) => _handleActionSelected(context, action),
              ),
              const SizedBox(height: 30),
              _buildEmergencyContacts(),
              const SizedBox(height: 30),
              healthNewsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
