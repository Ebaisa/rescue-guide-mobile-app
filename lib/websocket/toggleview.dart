import 'package:flutter/material.dart';
import 'package:health/auth/service/auth_service.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/websocket/nearby_hospital.dart';
import 'package:health/websocket/sos_history.dart';
import 'package:provider/provider.dart';

class SOSHistoryScreen extends StatefulWidget {
  final String userId;
  const SOSHistoryScreen({super.key, required  this.userId});

  @override
  State<SOSHistoryScreen> createState() => _SOSHistoryScreenState();
}

class _SOSHistoryScreenState extends State<SOSHistoryScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.userId);
    _loadUserData();
  }

  bool showHistory = false;
  final AuthService _authService = AuthService();

  String _userId = '';
  Future<void> _loadUserData() async {
    final userData = await _authService.loadUserData();

    setState(() {
      

      _userId = userData['id']?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          Provider.of<LanguageProvider>(context).getText('nearby_hospital'),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔁 Toggle Buttons Styled as Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton(Provider.of<LanguageProvider>(
                    context,
                  ).getText('sos'), !showHistory, () {
                  setState(() => showHistory = false);
                }),
                _buildTabButton(Provider.of<LanguageProvider>(
                    context,
                  ).getText('history'), showHistory, () {
                  setState(() => showHistory = true);
                }),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ✨ Swapping widgets with animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child:
                  showHistory
                      ? const HistoryScreen(key: ValueKey('history'))
                      : HospitalScreen(
                        key: const ValueKey('sos'),
                        userId: widget.userId,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔨 Tab-style toggle button
  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// class SOSWidget extends StatelessWidget {
//   const SOSWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         '🚨 SOS Details',
//         style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
// }

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '📜 History Details',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
      ),
    );
  }
}
