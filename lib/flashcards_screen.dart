import 'package:flutter/material.dart';
import 'package:flutter_projects/test_screen.dart'; // Adjust the path if needed
import 'package:shared_preferences/shared_preferences.dart';

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Map<String, String>> flashcards = [];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedCards = prefs.getStringList('flashcards');
    if (savedCards != null) {
      setState(() {
        flashcards = savedCards.map((card) {
          final parts = card.split('|');
          return {'question': parts[0], 'answer': parts[1]};
        }).toList();
      });
    }
  }

  Future<void> _saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedCards = flashcards.map((card) {
      return '${card['question']}|${card['answer']}';
    }).toList();
    prefs.setStringList('flashcards', savedCards);
  }

  void _addFlashcard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String question = '';
        String answer = '';
        return AlertDialog(
          title: Text('Add Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Question'),
                onChanged: (value) => question = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Answer'),
                onChanged: (value) => answer = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards.add({'question': question, 'answer': answer});
                    _saveFlashcards();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editFlashcard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String question = flashcards[index]['question']!;
        String answer = flashcards[index]['answer']!;
        return AlertDialog(
          title: Text('Edit Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Question'),
                onChanged: (value) => question = value,
                controller: TextEditingController(text: question),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Answer'),
                onChanged: (value) => answer = value,
                controller: TextEditingController(text: answer),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards[index] = {'question': question, 'answer': answer};
                    _saveFlashcards();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcards')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(flashcards[index]['question']!),
                  subtitle: Text(flashcards[index]['answer']!),
                  onTap: () => _editFlashcard(index),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addFlashcard,
            child: Text('Add Flashcard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestScreen(flashcards: flashcards)),
              );
            },
            child: Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}
