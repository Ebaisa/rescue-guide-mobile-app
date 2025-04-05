import 'package:flutter/material.dart';
import 'package:profile_page/splash1.dart';
import 'window3.dart'; // Import the Window3 screen
  // Import the Splash1Screen file

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Window2(),
  ));
}

class Window2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Updated Image
              Image.asset(
                'assets/images/contact_doctor.png', // Replace with the actual image path
                width: 150,  // Adjust width as needed
                height: 150, // Adjust height as needed
                fit: BoxFit.cover, // Ensures the image fits well within the box
              ),

              SizedBox(height: 20),

              // Title text
              Text(
                "Contact Doctor",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              // Description text
              Text(
                "Emergency contact lists where users can store important phone numbers for family, friends, and local emergency services.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              SizedBox(height: 30),

              // Row of 4 dots in the center (Second dot green)
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
                      color: index == 1 ? Color(0xFF019874) : Colors.grey.shade300, // Only the second dot is green
                      borderRadius: BorderRadius.circular(4), // Rounded dots
                    ),
                  );
                }),
              ),

              SizedBox(height: 40),  // Adjust space after dots

              // Next Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Window3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF019874),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded button
                  ),
                ),
                child: Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              SizedBox(height: 10),

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
