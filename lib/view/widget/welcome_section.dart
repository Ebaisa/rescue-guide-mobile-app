import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/view/profile/screen/profile_screen.dart';
import 'package:provider/provider.dart';

class WelcomeSection extends StatelessWidget {
  final String userName;

  const WelcomeSection({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
 
          const SizedBox(width: 20),
          // Welcome Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                  Provider.of<LanguageProvider>(
                    context,
                  ).getText('welcome_back'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    color: Colors.blueGrey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  userName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
  Provider.of<LanguageProvider>(context).getText('feeling_healthy'),
  style: theme.textTheme.bodySmall?.copyWith(
    fontSize: 13,
    color: Colors.blueGrey[500],
    fontStyle: FontStyle.italic,
  ),)
              ],
            ),
          ),
          // Health pulse icon
        Column(

            children:[ 
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1.5),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.person_2_outlined,
                  color: Color.fromARGB(255, 14, 0, 0),
                  size: 26,
                ),
                            ),
              ),
              SizedBox(height: 18,),
              Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromARGB(255, 42, 158, 197), width: 1.5),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.monitor_heart_rounded,
                color: Color(0xFFD32F2F),
                size: 26,
              ),
            )
            ],
          ),
        ],
      ),
    );
  }
}
