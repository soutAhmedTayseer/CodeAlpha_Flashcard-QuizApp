import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AnswerDisplay extends StatelessWidget {
  final String label;
  final String answer;
  final bool isCorrect;

  const AnswerDisplay({
    required this.label,
    required this.answer,
    required this.isCorrect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:'.tr(),
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
          ),
        ),
        Text(
          ' $answer',
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
