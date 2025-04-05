import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerifyScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerificationComplete;

  const EmailVerifyScreen({
    Key? key,
    required this.email,
    required this.onVerificationComplete,
  }) : super(key: key);

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimeout = 30;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() => _resendTimeout--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // In a real app, you would verify the OTP with your backend
      // This is just a mock implementation
      await Future.delayed(const Duration(seconds: 1));

      // Check if email is verified
      await _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified ?? false) {
        widget.onVerificationComplete();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isResending = true;
      _resendTimeout = 30;
    });

    try {
      await _auth.currentUser?.sendEmailVerification();
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New OTP sent to your email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend OTP: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter OTP',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit code to ${widget.email}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // OTP Input Field
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 56,
                fieldWidth: 48,
                activeFillColor: Colors.white,
                activeColor: Theme.of(context).colorScheme.primary,
                selectedColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Colors.grey.shade300,
              ),
              keyboardType: TextInputType.number,
              animationDuration: const Duration(milliseconds: 200),
              enableActiveFill: false,
              onCompleted: (value) => _verifyOTP(),
            ),
            const SizedBox(height: 24),

            // Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify'),
              ),
            ),
            const SizedBox(height: 16),

            // Resend Code
            Center(
              child: TextButton(
                onPressed:
                    _isResending || _resendTimeout > 0 ? null : _resendOTP,
                child: Text(
                  _resendTimeout > 0
                      ? 'Resend code in $_resendTimeout seconds'
                      : 'Resend code',
                  style: TextStyle(
                    color: _isResending || _resendTimeout > 0
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
