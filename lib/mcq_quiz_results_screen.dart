import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<String> questions; // List of questions
  final Map<int, String?> selectedAnswers; // Map to store selected answers
  final Map<int, String> correctAnswers;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.questions, // List of questions
    required this.selectedAnswers,
    required this.correctAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _saveQuizResults();

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
                  final questionIndex = index;
                  final selectedAnswer = selectedAnswers[questionIndex];
                  final correctAnswer = correctAnswers[questionIndex];
                  final questionText = questions[questionIndex];
                  final isCorrect = selectedAnswer == correctAnswer;

                  return Card(
                    color: Colors.grey[800],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Question ${questionIndex + 1}: $questionText',
                        style: const TextStyle(
                          color: Colors.orange, // Set question color to orange
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Answer: ${selectedAnswer ?? 'No selected answer'}',
                            style: TextStyle(
                              color: selectedAnswer == correctAnswer
                                  ? Colors.green // Set your answer color to green if correct
                                  : selectedAnswer == null
                                  ? Colors.red
                                  : Colors.red, // Set your answer color to red if not correct
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Correct Answer: $correctAnswer',
                            style: const TextStyle(
                              color: Colors.green, // Set correct answer color to green
                            ),
                          ),
                        ],
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

  Future<void> _saveQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().toIso8601String();
    final quizKey = 'Quiz $timestamp';

    final results = <String>[];

    for (var i = 0; i < totalQuestions; i++) {
      final questionText = questions[i]; // Get the question text
      final userAnswer = selectedAnswers[i] ?? 'No answer';
      final correctAnswer = correctAnswers[i];
      final result = (userAnswer == correctAnswer) ? 'Correct' : 'Incorrect';

      results.add('$questionText|$userAnswer|$correctAnswer|$result');
    }

    await prefs.setStringList(quizKey, results);
  }
}
