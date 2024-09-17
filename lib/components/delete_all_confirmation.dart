import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DeleteAllConfirmation extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAllConfirmation({
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Deletion'.tr()),
      content: Text('Are you sure you want to delete all flashcards?'.tr()),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: Text('Delete All'.tr(), style: const TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
