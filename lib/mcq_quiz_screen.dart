import 'package:flutter/material.dart';
import 'package:flutter_projects/mcq_quiz_results_screen.dart';
import 'dart:async';
import 'mcq_questions.dart';

class MCQQuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String category;

  const MCQQuizScreen({super.key, required this.questions, required this.category});

  @override
  _MCQQuizScreenState createState() => _MCQQuizScreenState();
}

class _MCQQuizScreenState extends State<MCQQuizScreen> {
  late List<Question> _shuffledQuestions;
  int _currentQuestionIndex = 0;
  final Map<int, String?> _selectedAnswers = {};
  late List<String?> _currentOptions;
  late String _currentQuestion;
  late String _currentDifficulty;
  Timer? _timer;
  int _remainingTime = 300;

  @override
  void initState() {
    super.initState();
    _shuffledQuestions = List.from(widget.questions)..shuffle();
    _startTimer();
    _setCurrentQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
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
    if (_shuffledQuestions.isEmpty) return;
    final question = _shuffledQuestions[_currentQuestionIndex];
    _currentQuestion = question.question;
    _currentDifficulty = question.difficulty;
    _currentOptions = _generateOptions(question);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and padding for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    if (_shuffledQuestions.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'No questions available',
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
        ),
      );
    }

    final options = _currentOptions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            Column(
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
                      child: Row(
                        children: [
                          // Timer on the left
                          SizedBox(
                            width: isSmallScreen ? 50 : 60,
                            height: isSmallScreen ? 50 : 60,
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
                                    style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Category and Question Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: isSmallScreen ? 18 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Question ${_currentQuestionIndex + 1} of ${_shuffledQuestions.length}',
                                  style: const TextStyle(color: Colors.orange, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Difficulty Container - Positioned under the first card
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,  // Aligns the container to the right
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(_currentDifficulty),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Text(
                        _currentDifficulty.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Centered Content area with scrollable questions and answers
                Expanded(
                  child: Center(
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
                                    fontSize: isSmallScreen ? 18 : 20,
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
                                      style: const TextStyle(color: Colors.white),
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
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                                onPressed: _currentQuestionIndex < _shuffledQuestions.length - 1
                                    ? () {
                                  setState(() {
                                    _currentQuestionIndex++;
                                    _setCurrentQuestion();
                                  });
                                }
                                    : () {
                                  _showSubmitConfirmation();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                                child: Text(
                                  _currentQuestionIndex < _shuffledQuestions.length - 1
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
          ],
        ),
      ),
    );
  }

  List<String?> _generateOptions(Question question) {
    final options = <String?>[question.correctAnswer];
    options.addAll(question.incorrectAnswers);
    return options..shuffle();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.yellow[700]!;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _submitQuiz() {
    int score = 0;
    final correctAnswers = <int, String>{};

    for (int i = 0; i < _shuffledQuestions.length; i++) {
      final question = _shuffledQuestions[i];
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
          totalQuestions: _shuffledQuestions.length,
          questions: _shuffledQuestions.map((q) => q.question).toList(),
          selectedAnswers: _selectedAnswers,
          correctAnswers: correctAnswers,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await _showExitConfirmation()) ?? false;
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Quiz'),
          content: const Text('If you exit now, your answers will not be saved. Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Quiz'),
          content: const Text('Are you sure you want to submit the quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitQuiz();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}