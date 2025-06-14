import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const EmergencyButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          const Text(
            'Emergency SOS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'PRESS TO HELP',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
