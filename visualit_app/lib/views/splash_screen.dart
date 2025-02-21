import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start fade-in effect
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Start fade-out effect after 2.5 seconds
    Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    // Navigate to home screen after fade-out completes
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: Image.asset(
            'assets/visualit.png', // Ensure the image exists in the assets folder
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
