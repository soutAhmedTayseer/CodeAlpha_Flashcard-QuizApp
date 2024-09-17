import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AnswerInput extends StatelessWidget {
  final TextEditingController answerController;
  final bool hasSubmitted;
  final ValueChanged<String> onChanged;

  const AnswerInput({
    required this.answerController,
    required this.hasSubmitted,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: answerController,
          decoration: InputDecoration(
            labelText: 'Your Answer'.tr(),
            labelStyle: const TextStyle(color: Colors.white),
          ),
          onChanged: onChanged,
          textAlign: TextAlign.center,
          enabled: !hasSubmitted,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
