import 'package:flutter/material.dart';
import 'package:profile_page/splash1.dart';


class Window3 extends StatelessWidget {
  const Window3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SOS Icon
              Image.asset(
                'assets/images/sos_icon.png', // Make sure this asset is added
                height: 150,
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                "Hospital",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              const Text(
                "SOS alerts. In case of an emergency, users can send out alerts",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Row of 4 dots in the center (Third dot green)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 8,  // Smaller dot size
                    height: 8, // Smaller dot size
                    decoration: BoxDecoration(
                      color: index == 2 ? Color(0xFF019874) : Colors.grey.shade300, // Only the third dot is green
                      borderRadius: BorderRadius.circular(4), // Rounded dots
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),  // Adjust space after dots

              // Next Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Splash1()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF019874),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded button
                  ),
                ),
                child: const Text(
                  "NEXT",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Skip Button
              TextButton(
                onPressed: () {
                  // Navigate to Splash1Screen (change to Splash1)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Splash1()), // Corrected name
                  );
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: const Color.fromARGB(136, 46, 40, 40)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
