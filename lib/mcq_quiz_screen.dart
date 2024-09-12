import 'package:flutter/material.dart';
import 'package:flutter_projects/mcq_quiz_results_screen.dart';
import 'dart:async';
import 'mcq_questions.dart';

class MCQQuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String category; // Added category parameter

  const MCQQuizScreen({super.key, required this.questions, required this.category});

  @override
  _MCQQuizScreenState createState() => _MCQQuizScreenState();
}

class _MCQQuizScreenState extends State<MCQQuizScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String?> _selectedAnswers = {}; // Store selected answers
  late List<String?> _currentOptions;
  late String _currentQuestion;
  Timer? _timer;
  int _remainingTime = 300; // 5 minutes timer

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setCurrentQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_remainingTime == 0) {
        _timer?.cancel();
        _submitQuiz();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void _setCurrentQuestion() {
    if (widget.questions.isEmpty) return;
    final question = widget.questions[_currentQuestionIndex];
    _currentQuestion = question.question;
    _currentOptions = _generateOptions(question);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'No questions available',
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
        ),
      );
    }

    final question = widget.questions[_currentQuestionIndex];
    final options = _currentOptions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Timer and Quiz Info Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[800],
              elevation: 4,
              margin: const EdgeInsets.only(top: 30.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Circular Progress Bar for Timer
                        Container(
                          width: 50,
                          height: 50,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: _remainingTime / 300,
                                backgroundColor: Colors.grey[700],
                                color: Colors.orange,
                              ),
                              Center(
                                child: Text(
                                  '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.orange, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.category,
                            style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${widget.questions.length}',
                          style: TextStyle(color: Colors.orange, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Centered Content area with scrollable questions and answers
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question text Card
                  Card(
                    color: Colors.grey[800],
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          _currentQuestion,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Options in a single card
                  Card(
                    color: Colors.grey[800],
                    elevation: 4,
                    child: Column(
                      children: [
                        ...options.map((option) {
                          return ListTile(
                            title: Text(
                              option!,
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: Radio<String?>(
                              value: option,
                              groupValue: _selectedAnswers[_currentQuestionIndex],
                              onChanged: (value) {
                                setState(() {
                                  _selectedAnswers[_currentQuestionIndex] = value;
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                            onTap: () {
                              setState(() {
                                _selectedAnswers[_currentQuestionIndex] = option;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentQuestionIndex > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentQuestionIndex--;
                                _setCurrentQuestion();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: const Text('Previous', style: TextStyle(color: Colors.orange)),
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentQuestionIndex < widget.questions.length - 1
                              ? () {
                            setState(() {
                              _currentQuestionIndex++;
                              _setCurrentQuestion();
                            });
                          }
                              : () {
                            _submitQuiz();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                          ),
                          child: Text(
                            _currentQuestionIndex < widget.questions.length - 1
                                ? 'Next'
                                : 'Submit',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String?> _generateOptions(Question question) {
    final options = <String?>[question.correctAnswer];
    options.addAll(question.incorrectAnswers);
    return options..shuffle(); // Shuffle options for better quiz experience
  }

  void _submitQuiz() {
    int score = 0;
    final correctAnswers = <int, String>{};

    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      final selectedAnswer = _selectedAnswers[i];
      if (selectedAnswer == question.correctAnswer) {
        score++;
      }
      correctAnswers[i] = question.correctAnswer;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          totalQuestions: widget.questions.length,
          selectedAnswers: _selectedAnswers,
          correctAnswers: correctAnswers,
        ),
      ),
    );
  }


}
