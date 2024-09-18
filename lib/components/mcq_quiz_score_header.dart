import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Color titleColor;

  const ScoreDisplay({
    required this.score,
    required this.totalQuestions,
    required this.titleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800], // Background color of the card
      elevation: 6, // Shadow depth of the card
      margin: const EdgeInsets.only(top: 30.0), // Outer margin for spacing
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the score display horizontally
            children: [
              Text(
                'Your Score'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Custom color for the score title
                ),
              ),
              Text(
                ': $score ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Custom color for the score
                ),
              ),
              Text(
                'out of'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Custom color for the 'out of' text
                ),
              ),
              Text(
                ' $totalQuestions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Custom color for the total questions
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
