import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(tr('Cancel')),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(tr('Confirm'), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
