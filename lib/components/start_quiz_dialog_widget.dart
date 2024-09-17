import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../mcq_quiz_screen.dart';
import '../mcq_questions.dart';

// Dialog Widget
class StartQuizDialog extends StatelessWidget {
  final VoidCallback onStart;
  final String title;
  final String content;

  const StartQuizDialog({
    required this.onStart,
    this.title = 'Start Quiz',
    this.content = 'Are you sure you want to start the quiz?',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title.tr()),
      content: Text(content.tr()),
      actions: [
        TextButton(
          onPressed: onStart,
          child: Text('Start Quiz'.tr(), style: const TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

// Function to Show Dialog
void showStartQuizDialog(
    BuildContext context, List<Question> questions, String categoryTitle) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StartQuizDialog(
        onStart: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MCQQuizScreen(
                questions: questions,
                category: categoryTitle,
              ),
            ),
          );
        },
      );
    },
  );
}
