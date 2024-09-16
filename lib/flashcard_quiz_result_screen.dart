import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import localization

class FlashcardQuizResultScreen extends StatelessWidget {
  final int score;
  final List<Map<String, String>> results;

  const FlashcardQuizResultScreen({
    super.key,
    required this.score,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final int totalQuestions = results.length;
    final double percentage = (score / totalQuestions) * 100;

    // Determine the color based on percentage
    Color scoreColor;
    if (percentage >= 80) {
      scoreColor = Colors.green;
    } else if (percentage >= 50) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/q2.jpeg', // Update with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Header
                Card(
                  color: Colors.grey[800],
                  elevation: 6,
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Score'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            ': $score '.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            'out of'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            ' $totalQuestions'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Results List
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final String userAnswer = result['userAnswer'] ?? 'No Answer Given';
                      final String correctAnswer = result['correctAnswer']!;
                      final String question = result['question']!;
                      final bool isAnswerCorrect = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

                      return Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Flexible(
                            child: Text(
                              question,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Your Answer:'.tr(),
                                      style: TextStyle(
                                        color: userAnswer == 'No Answer Given'
                                            ? Colors.red
                                            : (isAnswerCorrect ? Colors.green : Colors.red),
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      userAnswer.tr(),
                                      style: TextStyle(
                                        color: userAnswer == 'No Answer Given'
                                            ? Colors.red
                                            : (isAnswerCorrect ? Colors.green : Colors.red),
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Correct Answer:'.tr(),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      " $correctAnswer".tr(),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (userAnswer == 'No Answer Given')
                                Text(
                                  'Result: No Answer Given'.tr(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                )
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
