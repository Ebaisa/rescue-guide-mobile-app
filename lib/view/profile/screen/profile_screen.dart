import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/view/profile/screen/userinfo.dart';
import 'package:health/view/profile/service/info_service.dart';
import 'package:health/view/profile/edit_user_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/auth/loginscreen.dart';
import 'package:health/view/homescreen.dart';
import 'package:health/view/profile/screen/edit_screen.dart';
import 'changepass_screend.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAddress = '';
  String emergencyContact = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    setState(() {
      userName = prefs.getString('user_name') ?? 'Noname';
      userEmail = prefs.getString('user_email') ?? 'No email';
      userPhone = prefs.getString('user_phone') ?? 'Nohone';
      userAddress = prefs.getString('user_address') ?? 'No address';
      emergencyContact = prefs.getString('emergency_contact') ?? 'No contact';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title:  Text(
          Provider.of<LanguageProvider>(
                    context,
                  ).getText('profile'), style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          userName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(userEmail, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, Provider.of<LanguageProvider>(
                    context,
                  ).getText('phone_number'), userPhone),

            const Divider(),
        
            _buildInfoRow(Icons.email, Provider.of<LanguageProvider>(
                    context,
                  ).getText('email'), userEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
         _buildActionButton(Provider.of<LanguageProvider>(
                    context,
                  ).getText('user_info'),Icons.info, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Userinfo()),
          );
        }),
        _buildActionButton(Provider.of<LanguageProvider>(
                    context,
                  ).getText('edit_profile'), Icons.edit, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );
        }),
        _buildActionButton(Provider.of<LanguageProvider>(
                    context,
                  ).getText('change_password'), Icons.lock, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
          );
        }),
        _buildActionButton(
          Provider.of<LanguageProvider>(context).getText('change_language'),
          Icons.language,
          () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Select Language"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("English"),
                        onTap: () async {
                          await Provider.of<LanguageProvider>(
                            context,
                            listen: false,
                          ).changeLanguage('en');
                          Navigator.of(context).pop(); // close dialog
                        },
                      ),
                      ListTile(
                        title: Text("Amharic"),
                        onTap: () async {
                          await Provider.of<LanguageProvider>(
                            context,
                            listen: false,
                          ).changeLanguage('am');
                          Navigator.of(context).pop(); // close dialog
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        _buildActionButton(
          Provider.of<LanguageProvider>(context).getText('logout'),
          Icons.logout,
          () => _showLogoutConfirmation(context),
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title:  Text(
            Provider.of<LanguageProvider>(context).getText('logout'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content:  Text(
            Provider.of<LanguageProvider>(context).getText('are_you_sure_want_to_logout'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text(Provider.of<LanguageProvider>(context).getText('cancel'), style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  Text(
                Provider.of<LanguageProvider>(context).getText('logout'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontSize: 16, color: color)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
