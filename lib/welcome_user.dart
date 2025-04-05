import 'package:flutter/material.dart';
import 'package:profile_page/hospital_screen.dart';
import 'home_screen.dart';
import 'sos_alert_screen.dart';
import 'first_aid_topics_page.dart';
import 'setting_screen.dart';

class WelcomeUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Welcome, User!",
          style: TextStyle(
            color: Colors.black, 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Info Cards
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      title: "Nearby Hospitals",
                      subtitle: "Nearest hospitals for emergencies",
                      icon: Icons.local_hospital,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HospitalScreen()),
                      ),
                    ),
              )],
              ),
              
              SizedBox(height: 20),
              
              // Recommended Section
              Text(
                "Recommended", 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              
              // Recommended List
              Expanded(
                child: ListView(
                  children: [
                    _ListItem(
                      title: "SOS Alerts",
                      subtitle: "Immediate assistance available",
                      icon: Icons.warning,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SosAlertScreen()),
                      ),
                    ),
                    _ListItem(
                      title: "First Aid Scenarios",
                      subtitle: "Written guides for emergencies",
                      icon: Icons.book,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FirstAidTopicsPage()),
                      ),
                    ),
                    _ListItem(
                      title: "Nearby Hospitals",
                      subtitle: "Find the closest hospitals",
                      icon: Icons.local_hospital,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HospitalScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom Navigation Emojis
              _BottomNavigationEmojis(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF06A881)),
                SizedBox(width: 8),
                Text(
                  title, 
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              subtitle, 
              style: TextStyle(fontSize: 12, color: Colors.black54)
            ),
          ],
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: ListTile(
          leading: Icon(icon, color: Color(0xFF06A881)),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

class _BottomNavigationEmojis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _EmojiButton(
            emoji: '🚨',
            label: 'SOS Alert',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SosAlertScreen()),
            ),
          ),
          _EmojiButton(
            emoji: '🩺',
            label: 'First Aid',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FirstAidTopicsPage()),
            ),
          ),
          _EmojiButton(
            emoji: '🚑',
            label: 'Hospital',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HospitalScreen()),
            ),
          ),
          _EmojiButton(
            emoji: '⚙️',
            label: 'Settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onPressed;

  const _EmojiButton({
    required this.emoji,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}