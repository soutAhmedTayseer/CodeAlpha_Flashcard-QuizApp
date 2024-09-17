import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QuizInfoTimerCard extends StatelessWidget {
  final int timeRemaining;
  final int quizNumber;
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isSmallScreen;

  const QuizInfoTimerCard({
    required this.timeRemaining,
    required this.quizNumber,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.isSmallScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double progress = timeRemaining / 600;
    Color timerColor;
    if (timeRemaining < 60) {
      timerColor = Colors.red;
    } else if (timeRemaining < 180) {
      timerColor = Colors.yellow;
    } else {
      timerColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[800],
        elevation: 4,
        margin: const EdgeInsets.only(top: 30.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Timer section
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                      strokeWidth: 8.0,
                    ),
                  ),
                  Text(
                    '${timeRemaining ~/ 60}:${(timeRemaining % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Quiz info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Quiz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                        const SizedBox(width: 10),
                        Text('$quizNumber'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Question',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ).tr(),
                        Text(
                          ' ${currentQuestionIndex + 1} ',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ).tr(),
                        const Text(
                          'of',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ).tr(),
                        Text(
                          ' $totalQuestions ',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ).tr(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
