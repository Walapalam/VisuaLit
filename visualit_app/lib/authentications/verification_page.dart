// verification_page.dart
import 'package:flutter/material.dart';
import 'new_password_page.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _otpController = TextEditingController(); // Single controller

  void _verifyOTP() {
    String enteredOTP = _otpController.text;

    if (enteredOTP.length == 6) {
      print('OTP Verified for email: ${widget.email}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordPage(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter the 6-digit verification code sent to your email:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField( // Single TextFormField
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6, // Limit to 6 digits
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) { // Validator
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose(); // Dispose the controller
    super.dispose();
  }
}