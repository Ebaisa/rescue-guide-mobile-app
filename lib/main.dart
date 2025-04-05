import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'window2.dart'; // Import the Window2 screen
import 'home_screen.dart';

class WelcomeV1Screen extends StatefulWidget {
  @override
  _WelcomeV1ScreenState createState() => _WelcomeV1ScreenState();
}

class _WelcomeV1ScreenState extends State<WelcomeV1Screen> {
  // Current page index
  int currentPage = 0; // Track the current active dot

  @override
  Widget build(BuildContext context) {
    // Get the screen's width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align items to the top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First box for the image with padding at the top
              Container(
                padding: EdgeInsets.only(
                    top: 20), // Adjusted top padding for better spacing
                margin: EdgeInsets.zero,
                child: Image.asset(
                  'assets/images/phone.png', // Replace with actual image asset
                  width: screenWidth, // Full screen width
                  height: 300,
                  fit: BoxFit.cover, // Ensures image fits well within the box
                ),
              ),
              SizedBox(
                  height: 40), // Adjusted the space between the image and text

              // Row of 4 dots in the center
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 8, // Reduced dot width (smaller dot)
                    height: 8, // Reduced dot height (smaller dot)
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Color(0xFF019874)
                          : Colors.grey.shade300, // Only the first dot is green
                      borderRadius: BorderRadius.circular(4), // Rounded dots
                    ),
                  );
                }),
              ),
              SizedBox(height: 40), // Adjusted space after dots

              // Second box for the text content
              Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'Emergency Numbers',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The RescueGuide App is created to help people prepare for emergencies.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),

                    // Next Button with action
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Move to next dot (second dot for now)
                          if (currentPage < 3) {
                            currentPage++; // Change the current page to the next
                          }
                        });

                        // Navigate to the next screen (Window2) when clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Window2()),
                        );
                      },
                      child: Text('NEXT'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Color(0xFF019874), // Light green background color
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded button
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Home screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text('HOME'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Color(0xFF019874), // Light green background color
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded button
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*void main() {
  runApp(MaterialApp(
    home: WelcomeV1Screen(),
    debugShowCheckedModeBanner: false, // Hide the debug banner
  ));
}*/
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAy7IsQpJ93HUBJO4NFewV1QWLpmUEMBBo",
        appId: "1:81088833868:web:926ca049b5e770baf607e9",
        messagingSenderId:  "81088833868",
        projectId: "rescueguide-dc93c",

        // Your web Firebase config options
 ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MaterialApp(
    home: WelcomeV1Screen(),
    debugShowCheckedModeBanner: false, // Hide the debug banner
  ));
}