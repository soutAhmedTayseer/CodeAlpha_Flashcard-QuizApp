import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QuizResultsDialog extends StatelessWidget {
  final String quizLabel;
  final List<Map<String, String>> results;
  final VoidCallback onDelete;

  const QuizResultsDialog({
    required this.quizLabel,
    required this.results,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(quizLabel),
      content: results.isEmpty
          ? Text(tr('No results available.'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: results.map((result) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Q: ${result['question']!}\n'
                    '${tr('Your answer')}: ${result['userAnswer']!}\n'
                    '${tr('Correct answer')}: ${result['correctAnswer']!}\n',
                style: const TextStyle(fontSize: 16.0),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr("Close"), style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          child: Text(tr("Delete Quiz"), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
