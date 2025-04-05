import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:profile_page/home_screen.dart';

import 'phone_number_signup_page.dart';
import 'screens/email_verify_screen.dart';// New page for OTP verification

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1. Enhanced Email/Password Signup with Verification
  Future<void> _signUpWithEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update user display name
      await userCredential.user
          ?.updateDisplayName(_fullNameController.text.trim());

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Navigate to OTP verification page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerifyScreen(
            email: _emailController.text.trim(),
            onVerificationComplete: () {
              // This callback will be triggered after successful verification
              //Navigator.pushReplacementNamed(context, '/home');
               Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
            );  }
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(_getFirebaseErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. Google Signup with Verification Check
  Future<void> _signUpWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Google accounts are typically already verified
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showErrorSnackbar(_getSocialLoginErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 3. Error Message Handlers
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Signup failed: ${e.message}';
    }
  }

  String _getSocialLoginErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      return _getFirebaseErrorMessage(e);
    }
    return 'Login failed: ${e.toString()}';
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Let's Sign you up",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 30),

                // Full Name Field
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your full name' : null,
                ),
                SizedBox(height: 15),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email address",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your email';
                    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: () {}, // Add toggle functionality
                    ),
                  ),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'Password must be 6+ characters'
                      : null,
                ),
                SizedBox(height: 25),

                // Email Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signUpWithEmail,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign Up", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 15),

                Text(
                  "By signing up, you agree to our Terms and Conditions & Privacy Policy",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),

                // Divider with OR text
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 25),

                // Phone Signup Button
                _buildSocialButton(
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: "Continue with Phone",
                  color: Colors.blue,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneSignUpPage()),
                  ),
                ),
                SizedBox(height: 12),

                // Google Signup Button
                _buildSocialButton(
                  icon: Icon(Icons.g_mobiledata, size: 28),
                  label: "Continue with Google",
                  color: Colors.white,
                  textColor: Colors.black87,
                  onPressed: _signUpWithGoogle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable social login button widget
  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: color == Colors.white
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide(color: Colors.transparent, width: 0),
          ),
        ),
        icon: icon,
        label: Text(label, style: TextStyle(fontSize: 16)),
        onPressed: _isLoading ? null : onPressed,
      ),
    );
  }
}
