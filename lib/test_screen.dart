import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  TestScreen({required this.flashcards});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, String>> _flashcards = [];
  List<bool?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _flashcards = widget.flashcards;
  }

  void _submitAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        _score++;
      }
      if (_currentQuestionIndex < _flashcards.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Navigate to results screen or show a result dialog
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Completed'),
          content: Text('Your score is $_score/${_flashcards.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Test')),
        body: Center(child: Text('No flashcards available')),
      );
    }

    final currentCard = _flashcards[_currentQuestionIndex];
    final question = currentCard['question']!;
    final answer = currentCard['answer']!;

    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              question,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          ElevatedButton(
            onPressed: () => _submitAnswer(true), // Assume answer is correct
            child: Text('Correct Answer'),
          ),
          ElevatedButton(
            onPressed: () => _submitAnswer(false), // Assume answer is incorrect
            child: Text('Wrong Answer'),
          ),
        ],
      ),
    );
  }
}
