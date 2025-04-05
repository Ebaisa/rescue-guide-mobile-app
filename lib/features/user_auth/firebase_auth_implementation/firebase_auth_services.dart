import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Email/Password Signup with automatic verification email
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile
      await credential.user?.updateDisplayName(displayName);

      // Send verification email
      await _sendVerificationEmail(credential.user!);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      _showErrorToast(_getSignUpErrorMessage(e));
      return null;
    }
  }

  // 2. Email/Password Login with verification check
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!(credential.user?.emailVerified ?? false)) {
        await _auth.signOut();
        _showErrorToast('Please verify your email first');
        return null;
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      _showErrorToast(_getSignInErrorMessage(e));
      return null;
    }
  }

  // 3. Email Verification Methods
  Future<void> _sendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
      _showSuccessToast('Verification email sent to ${user.email}');
    } catch (e) {
      _showErrorToast('Failed to send verification email');
    }
  }

  Future<bool> checkEmailVerification() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      _showSuccessToast('Verification email resent');
    } catch (e) {
      _showErrorToast('Failed to resend verification email');
    }
  }

  // 4. Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSuccessToast('Password reset link sent');
    } on FirebaseAuthException catch (e) {
      _showErrorToast(_getPasswordResetErrorMessage(e));
    }
  }

  // 5. Error Handling
  String _getSignUpErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password must be 6+ characters';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Signup failed: ${e.message}';
    }
  }

  String _getSignInErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password';
      case 'user-disabled':
        return 'Account disabled';
      default:
        return 'Login failed: ${e.message}';
    }
  }

  String _getPasswordResetErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      default:
        return 'Password reset failed: ${e.message}';
    }
  }

  // 6. Helper Methods
  void _showErrorToast(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessToast(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 7. Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// Add this in your main.dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

