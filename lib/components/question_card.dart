import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final bool isSmallScreen;

  const QuestionCard({required this.question, required this.isSmallScreen, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            question,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
