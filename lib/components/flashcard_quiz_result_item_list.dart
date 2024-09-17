import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/components/results_card.dart';

class ResultListItem extends StatelessWidget {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  const ResultListItem({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                'Your Answer: '.tr(),
                style: TextStyle(
                  color: userAnswer == 'No Answer Given'
                      ? Colors.red
                      : (isCorrect ? Colors.green : Colors.red),
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              Flexible(
                child: Text(
                  userAnswer.tr(),
                  style: TextStyle(
                    color: userAnswer == 'No Answer Given'
                        ? Colors.red
                        : (isCorrect ? Colors.green : Colors.red),
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Text(
                'Correct Answer: '.tr(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              Flexible(
                child: Text(
                  correctAnswer.tr(),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
