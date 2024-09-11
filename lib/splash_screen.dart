import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_projects/home_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/flashcard_logo.png', // Add your splash image here
      nextScreen:  HomeLayout(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.blueAccent,
    );
  }
}
