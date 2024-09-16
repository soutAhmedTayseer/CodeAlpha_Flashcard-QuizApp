import 'package:flutter/material.dart';

class LanguagesTranslationScreen extends StatelessWidget {
  const LanguagesTranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
