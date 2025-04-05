import 'package:flutter/material.dart';
import 'splash2.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class Splash1 extends StatelessWidget {
  // Function to launch the USSD code
  Future<void> _launchUSSD() async {
    const String ussdCode = "*123#";  // Replace with your desired USSD code
    final String url = 'tel:$ussdCode';  // Format as a dial URL
    
    if (await canLaunch(url)) {
      await launch(url);  // Launch the dialer with the USSD code
    } else {
      throw 'Could not launch $url';  // Handle error if URL cannot be launched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/doctors.jpg', height: 150),
                SizedBox(height: 20),
                Text(
                  'Consult Specialist Doctors\nSecurely And Privately',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Malesuada vulputate facilisi eget neque, nunc suspendisse massa augue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),

                // Row of 4 dots in the center (Fourth dot green)
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
                        color: index == 3 ? Color(0xFF019874) : Colors.grey.shade300, // Only the fourth dot is green
                        borderRadius: BorderRadius.circular(4), // Rounded dots
                      ),
                    );
                  }),
                ),

                SizedBox(height: 40),  // Adjust space after dots

                // Get Started Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF019874),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Splash2()),
                    );
                  },
                  child: Text('Get Started', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                // USSD Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF019874),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                  onPressed: _launchUSSD,  // Call the function to launch USSD code
                  child: Text('USSD', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
