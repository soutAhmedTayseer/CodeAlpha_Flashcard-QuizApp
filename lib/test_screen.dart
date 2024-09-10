import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, String>> _results = [];
  String _userAnswer = '';
  int _quizNumber = 1;

  @override
  void initState() {
    super.initState();
    _flashcards = widget.flashcards;
    _loadQuizNumber();
  }

  Future<void> _loadQuizNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuizNumber = prefs.getInt('quizNumber') ?? 1;
    setState(() {
      _quizNumber = savedQuizNumber;
    });
  }

  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = _results.map((result) {
      return '${result['question']}|${result['userAnswer']}|${result['correctAnswer']}|${result['result']}';
    }).toList();

    final quizLabel = 'Quiz $_quizNumber';
    await prefs.setStringList(quizLabel, results);

    // Increment quiz number for next quiz
    await prefs.setInt('quizNumber', _quizNumber + 1);
    setState(() {
      _quizNumber++;
    });
  }

  void _submitAnswer() {
    final correctAnswer = _flashcards[_currentQuestionIndex]['answer']!;
    final isCorrect = _userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

    setState(() {
      if (isCorrect) {
        _score++;
      }
      _results.add({
        'question': _flashcards[_currentQuestionIndex]['question']!,
        'userAnswer': _userAnswer,
        'correctAnswer': correctAnswer,
        'result': isCorrect ? 'Correct' : 'Incorrect',
      });

      if (_currentQuestionIndex < _flashcards.length - 1) {
        _currentQuestionIndex++;
        _userAnswer = ''; // Clear the answer for the next question
      } else {
        _saveResults();
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

    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 24.0),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Your Answer'),
              onChanged: (value) => _userAnswer = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
