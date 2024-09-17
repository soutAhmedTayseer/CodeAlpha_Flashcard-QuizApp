import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AddFlashcardDialog extends StatefulWidget {
  final void Function(String question, String answer) onAdd;
  final VoidCallback onGenerateRandom;

  const AddFlashcardDialog({
    required this.onAdd,
    required this.onGenerateRandom,
    Key? key,
  }) : super(key: key);

  @override
  _AddFlashcardDialogState createState() => _AddFlashcardDialogState();
}

class _AddFlashcardDialogState extends State<AddFlashcardDialog> {
  String question = '';
  String answer = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Flashcard'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Question'.tr()),
              onChanged: (value) => question = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Answer'.tr()),
              onChanged: (value) => answer = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (question.isNotEmpty && answer.isNotEmpty) {
              widget.onAdd(question, answer);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please provide both question and answer.'.tr())),
              );
            }
          },
          child: Text('Add'.tr(), style: const TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () {
            widget.onGenerateRandom();
            Navigator.of(context).pop();
          },
          child: Text('Random Generate'.tr(), style: const TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
