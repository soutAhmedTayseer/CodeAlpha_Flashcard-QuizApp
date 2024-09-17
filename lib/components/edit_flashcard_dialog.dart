import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EditFlashcardDialog extends StatefulWidget {
  final String initialQuestion;
  final String initialAnswer;
  final void Function(String question, String answer) onSave;

  const EditFlashcardDialog({
    required this.initialQuestion,
    required this.initialAnswer,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  _EditFlashcardDialogState createState() => _EditFlashcardDialogState();
}

class _EditFlashcardDialogState extends State<EditFlashcardDialog> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.initialQuestion);
    _answerController = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Flashcard'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'.tr()),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'.tr()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final question = _questionController.text;
            final answer = _answerController.text;
            if (question.isNotEmpty && answer.isNotEmpty) {
              widget.onSave(question, answer);
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'.tr(), style: const TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
