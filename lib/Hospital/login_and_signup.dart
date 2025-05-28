import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Back!")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() => isLogin = true),
                  child: Text("Login", style: TextStyle(fontSize: 18)),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = false),
                  child: Text("Sign Up", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Email or Phone Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text(isLogin ? "Login" : "Sign Up"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 16),
            if (isLogin)
              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?"),
              ),
            SwitchListTile(
              title: Text("Switch to Dark Mode"),
              value: false,
              onChanged: (bool value) {},
            ),
            if (!isLogin)
              Text(
                "Error message area for invalid inputs.",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
