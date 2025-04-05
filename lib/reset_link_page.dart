import 'package:flutter/material.dart';

class ResendLinkPage extends StatefulWidget {
  @override
  _ResendLinkPageState createState() => _ResendLinkPageState();
}

class _ResendLinkPageState extends State<ResendLinkPage> {
  int _counter = 30;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Check your email",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("We have just sent an instructions email to abc@gmail.com"),
            SizedBox(height: 20),
            Text("Having a problem?"),
            SizedBox(height: 10),
            Text(
              _counter > 0 ? "Resend in $_counter" : "",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _counter == 0 ? () {} : null,
              child: Text("Resend Link"),
            ),
          ],
        ),
      ),
    );
  }
}
