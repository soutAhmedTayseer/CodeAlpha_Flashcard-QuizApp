import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'login_screen.dart'; // Adjust the path if needed

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/flashcard_logo.png', // Add your splash image here
      nextScreen: LoginScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.blueAccent,
    );
  }
}
