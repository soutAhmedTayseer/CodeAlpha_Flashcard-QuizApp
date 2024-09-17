import 'package:flutter/material.dart';

class FlashcardTile extends StatelessWidget {
  final Map<String, String> flashcard;
  final bool isSelected;
  final VoidCallback onTap;
  final DismissDirectionCallback onDismissed;

  const FlashcardTile({
    required this.flashcard,
    required this.isSelected,
    required this.onTap,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(flashcard['question']!),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(color: Colors.red),
      child: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            flashcard['question']!,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            flashcard['answer']!,
            style: const TextStyle(color: Colors.white),
          ),
          onTap: onTap,
          tileColor: isSelected ? Colors.blueGrey[300] : Colors.transparent,
        ),
      ),
    );
  }
}
