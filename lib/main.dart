import 'package:flutter/material.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/view/profile/edit_user_info.dart';
import 'package:health/websocket/nearby_hospital.dart';
import 'package:health/auth/loginscreen.dart';
import 'package:health/auth/register_screen.dart';
import 'package:health/view/homescreen.dart';
import 'package:health/view/profile/editprofile.dart';
import 'package:health/view/chatbotscreen.dart';
import 'package:health/view/aid/firstaidscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedLanguage =
      prefs.getString('language') ?? 'en'; // Default to English

  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider()..init(langCode: savedLanguage),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'NotoSansEthiopic'),
          bodyMedium: TextStyle(fontFamily: 'NotoSansEthiopic'),
        ),
      ),
      home: const AuthChecker(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/editprofile': (context) => const EditProfileScreen(),
        '/chat': (context) => const ChatBotScreen(),
        '/aid': (context) => const FirstAidScreen(),
        // '/sos': (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        //   return HospitalScreen(userId: args['userId']);
        // },
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUserData = prefs.getString('user_id') != null;

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, hasUserData ? '/home' : '/login');

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isLoading ? const CircularProgressIndicator() : const SizedBox(),
      ),
    );
  }
}
