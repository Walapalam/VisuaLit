import 'package:flutter/material.dart';
import 'login_page.dart';
import 'splash_screen.dart';
import 'signup_page.dart';
import 'forget_password_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(nextScreen: LoginPage()), // Use SplashScreen as home
      routes: {
        // REMOVE THIS LINE: '/': (context) => const LoginPage(),  <- This causes the error
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}