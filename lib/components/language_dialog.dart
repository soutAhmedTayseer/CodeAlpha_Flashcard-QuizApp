import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RestartDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const RestartDialog({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr('Language Change')),
      content: Text(tr('To apply the language changes, please restart the app.')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(tr('OK')),
        ),
      ],
    );
  }
}
