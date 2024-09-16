import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart'; // Import localization
import 'flashcard_quiz_result_screen.dart';

class TestScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  const TestScreen({super.key, required this.flashcards});

  @override
  // ignore: library_private_types_in_public_api
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, String>> _flashcards = [];
  final List<Map<String, String>> _results = [];
  final Map<int, String> _userAnswers = {};
  final TextEditingController _answerController = TextEditingController();
  int _quizNumber = 1;
  late Timer _timer;
  int _timeRemaining = 600;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _flashcards = List.from(widget.flashcards);
    _flashcards.shuffle();
    _loadQuizNumber();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _answerController.dispose();
    super.dispose();
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

    await prefs.setInt('quizNumber', _quizNumber + 1);
    setState(() {
      _quizNumber++;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          _timer.cancel();
          _hasSubmitted = true;
          _submitAnswer();
          Future.delayed(const Duration(seconds: 1), () {
            _navigateToResultScreen();
          });
        }
      });
    });
  }

  void _submitAnswer() {
    if (_hasSubmitted) return;

    _storeCurrentAnswer();

    setState(() {
      for (int i = 0; i < _flashcards.length; i++) {
        final correctAnswer = _flashcards[i]['answer']!;
        final userAnswerToSave = _userAnswers[i] ?? 'No Answer Given';
        final isCorrect = userAnswerToSave.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

        if (isCorrect) {
          _score++;
        }

        _results.add({
          'question': _flashcards[i]['question']!,
          'userAnswer': userAnswerToSave,
          'correctAnswer': correctAnswer,
          'result': isCorrect ? 'Correct' : 'Incorrect',
        });
      }
    });

    _saveResults();
    _navigateToResultScreen();
  }

  void _navigateToResultScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FlashcardQuizResultScreen(score: _score, results: _results);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const offsetBegin = Offset(1.0, 0.0);
          const offsetEnd = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: offsetBegin, end: offsetEnd);
          var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }


  void _storeCurrentAnswer() {
    _userAnswers[_currentQuestionIndex] = _answerController.text.trim();
  }

  void _loadCurrentAnswer() {
    _answerController.text = _userAnswers[_currentQuestionIndex] ?? '';
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _storeCurrentAnswer();
      setState(() {
        _currentQuestionIndex--;
        _loadCurrentAnswer();
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _flashcards.length - 1) {
      _storeCurrentAnswer();
      setState(() {
        _currentQuestionIndex++;
        _loadCurrentAnswer();
      });
    } else {
      _showSubmitConfirmation(); // Show confirmation dialog before final submit
    }
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Quiz').tr(),
          content: const Text('Are you sure you want to submit the quiz?').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)).tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitAnswer();
                _navigateToResultScreen();
              },
              child: const Text('Submit', style: TextStyle(color: Colors.green)).tr(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    if (_flashcards.isEmpty) {
      return Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/q2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            // Centered content
            Center(
              child: const Text(
                'No flashcards available',
                style: TextStyle( fontSize: 20),
              ).tr(),
            ),
          ],
        ),
      );
    }


    final currentCard = _flashcards[_currentQuestionIndex];
    final question = currentCard['question']!;

    double progress = _timeRemaining / 600;

    Color timerColor;
    if (_timeRemaining < 60) {
      timerColor = Colors.red;
    } else if (_timeRemaining < 180) {
      timerColor = Colors.yellow;
    } else {
      timerColor = Colors.green;
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/q2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // Timer and Quiz Info Card
              Padding(
                padding:  const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[800],
                  elevation: 4,
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                                strokeWidth: 8.0,
                              ),
                            ),
                            Text(
                              '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Quiz',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ).tr(),
                                  const SizedBox(width: 10),
                                  Text('$_quizNumber'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'Question',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ).tr(),
                                  Text(
                                    ' ${_currentQuestionIndex + 1} ',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ).tr(),
                                  const Text(
                                    'of',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ).tr(),
                                  Text(
                                    ' ${_flashcards.length} ',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ).tr(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Centered Content area
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding:  const EdgeInsets.all(16.0),
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
                                question,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Answer text field
                        Card(
                          color: Colors.grey[800],
                          elevation: 4,
                          child: Padding(
                            padding:  const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: _answerController,
                              decoration:   InputDecoration(
                                labelText: 'Your Answer'.tr(),
                                labelStyle: const TextStyle(color: Colors.white),
                              ),
                              onChanged: (value) => _userAnswers[_currentQuestionIndex] = value,
                              textAlign: TextAlign.center,
                              enabled: !_hasSubmitted,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.white),
                            ),
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
                                onPressed: _previousQuestion,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.grey[800], // White text color
                                ),
                                child: const Text('Previous').tr(),
                              ),
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _currentQuestionIndex < _flashcards.length - 1 ? _nextQuestion : _showSubmitConfirmation,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: _currentQuestionIndex < _flashcards.length - 1
                                  ? Colors.grey[800] // Grey background for "Next" button
                                  : Colors.green, // White text color
                              ),
                              child: Text(
                                _currentQuestionIndex < _flashcards.length - 1
                                    ? 'Next'
                                    : 'Submit',
                              ).tr(),
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
    );
  }
}
