import 'package:flutter/material.dart';
import '../components/background_widget.dart';
import '../components/flashcard_quiz_result_item_list.dart';
import '../components/flashcard_quiz_score_header.dart';

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
    final int totalQuestions = results.length;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/q2.jpeg'), // Use BackgroundImage
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ScoreHeader(score: score, totalQuestions: totalQuestions), // Use ScoreHeader
                const SizedBox(height: 20),
                // Result List
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final String userAnswer = result['userAnswer'] ?? 'No Answer Given';
                      final String correctAnswer = result['correctAnswer']!;
                      final String question = result['question']!;
                      final bool isAnswerCorrect = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

                      return ResultListItem(
                        question: question,
                        userAnswer: userAnswer,
                        correctAnswer: correctAnswer,
                        isCorrect: isAnswerCorrect,
                      ); // Use ResultListItem
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
