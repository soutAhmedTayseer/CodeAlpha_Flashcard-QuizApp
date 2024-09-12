import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Map<int, String?> selectedAnswers; // Map to store selected answers
  final Map<int, String> correctAnswers;

  // Constructor for ResultScreen
  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.correctAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Your Score: $score out of $totalQuestions',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: totalQuestions,
                itemBuilder: (context, index) {
                  final question = index + 1;
                  final selectedAnswer = selectedAnswers[index];
                  final correctAnswer = correctAnswers[index];
                  final isCorrect = selectedAnswer == correctAnswer;

                  return Card(
                    color: Colors.grey[800],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Question $question',
                        style: TextStyle(
                          color: selectedAnswer == null
                              ? Colors.red
                              : (isCorrect ? Colors.green : Colors.red),
                        ),
                      ),
                      subtitle: Text(
                        'Your Answer: ${selectedAnswer ?? 'No selected answer'}\n'
                            'Correct Answer: $correctAnswer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
