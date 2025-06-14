import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:provider/provider.dart';

class QuickActions extends StatelessWidget {
  final Function(String) onActionSelected;

  const QuickActions({Key? key, required this.onActionSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF0288D1); // Light Medical Blue

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Provider.of<LanguageProvider>(context).getText('quick_action'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children: [
            _buildActionButton(
              'first aid',
              Provider.of<LanguageProvider>(context).getText('first_aid'),
              Icons.medical_services_outlined,
              primaryColor,
            ),
            _buildActionButton(
              'nearby hospital',
              Provider.of<LanguageProvider>(context).getText('nearby_hospital'),
              Icons.local_hospital_outlined,
              primaryColor,
            ),
            _buildActionButton(
              'emergency contacts',
              Provider.of<LanguageProvider>(
                context,
              ).getText('emergency_contacts'),
              Icons.contact_phone_outlined,
              Colors.redAccent,
            ),
            _buildActionButton(
              'profile',
              Provider.of<LanguageProvider>(context).getText('profile'),
              Icons.person_outline,
              Colors.deepPurple,
            ),
            _buildActionButton(
              'sos emergency',
              Provider.of<LanguageProvider>(context).getText('sos_emergency'),
              Icons.sos,
              Colors.orange,
            ),
            _buildActionButton(
              'chat with doctor',
              Provider.of<LanguageProvider>(
                context,
              ).getText('chat_with_doctor'),
              Icons.chat_bubble_outline,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String route,String text, IconData icon, Color color) {
    return SizedBox(
      width: 150,
      child: GestureDetector(
        onTap: () {
          print(text);
          onActionSelected(route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
