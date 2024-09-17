import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddFlashcard;
  final VoidCallback onStartQuiz;

  const ActionButtons({
    required this.onAddFlashcard,
    required this.onStartQuiz,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: onAddFlashcard,
          icon: const Icon(Icons.add_card),
          label: Text('Add Flashcard'.tr()),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
          ),
        ),
        ElevatedButton.icon(
          onPressed: onStartQuiz,
          icon: const Icon(Icons.quiz),
          label: Text('Start Quiz'.tr()),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }
}
