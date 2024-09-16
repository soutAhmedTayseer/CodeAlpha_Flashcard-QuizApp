import 'package:flutter/material.dart';

class FlashcardQuizResultScreen extends StatelessWidget {
  final int score;
  final List<Map<String, String>> results;

  const FlashcardQuizResultScreen({
    Key? key,
    required this.score,
    required this.results,
  }) : super(key: key);

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
                      child: Text(
                        'Your Score: $score out of $totalQuestions',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                        textAlign: TextAlign.center,
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
                      final bool isAnswerCorrect = userAnswer == correctAnswer;

                      return Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            question,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Answer: $userAnswer',
                                style: TextStyle(
                                  color: userAnswer == 'No Answer Given'
                                      ? Colors.red
                                      : (isAnswerCorrect ? Colors.green : Colors.red),
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              Text(
                                'Correct Answer: $correctAnswer',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              if (userAnswer == 'No Answer Given')
                                Text(
                                  'Result: No Answer Given',
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
