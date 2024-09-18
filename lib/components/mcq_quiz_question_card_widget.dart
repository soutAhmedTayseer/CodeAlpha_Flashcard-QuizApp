import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'mcq_quiz_answer_display_widget.dart';

class McqQuizQuestionCardWidgetQuestionCard extends StatelessWidget {
  final int questionIndex;
  final String questionText;
  final String? selectedAnswer;
  final String correctAnswer;

  const McqQuizQuestionCardWidgetQuestionCard({
    required this.questionIndex,
    required this.questionText,
    required this.selectedAnswer,
    required this.correctAnswer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == correctAnswer;

    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          'Question ${questionIndex + 1}: $questionText',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnswerDisplay(
              label: 'Your Answer',
              answer: selectedAnswer ?? 'No selected answer'.tr(),
              isCorrect: isCorrect,
            ),
            const SizedBox(height: 4),
            AnswerDisplay(
              label: 'Correct Answer',
              answer: correctAnswer,
              isCorrect: true,
            ),
          ],
        ),
      ),
    );
  }
}
