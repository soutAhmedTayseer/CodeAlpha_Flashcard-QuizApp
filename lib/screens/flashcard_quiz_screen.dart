import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/flashcard_quiz_result_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../components/background_widget.dart';
import '../components/flashcard_quiz_answer_input.dart';
import '../components/navigation_button.dart';
import '../components/question_card.dart';
import '../components/quiz_info_card.dart';

class FlashcardQuizScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  const FlashcardQuizScreen({super.key, required this.flashcards});

  @override
  _FlashcardQuizScreen createState() => _FlashcardQuizScreen();
}

class _FlashcardQuizScreen extends State<FlashcardQuizScreen> with TickerProviderStateMixin {
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
      _showSubmitConfirmation();
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
            Positioned.fill(
              child: Image.asset(
                'assets/images/q2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: const Text(
                'No flashcards available',
                style: TextStyle(fontSize: 20),
              ).tr(),
            ),
          ],
        ),
      );
    }

    final currentCard = _flashcards[_currentQuestionIndex];
    final question = currentCard['question']!;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/q2.jpeg'), // Use BackgroundImage

          Column(
            children: [
              QuizInfoTimerCard(
                timeRemaining: _timeRemaining,
                quizNumber: _quizNumber,
                currentQuestionIndex: _currentQuestionIndex,
                totalQuestions: _flashcards.length,
                isSmallScreen: isSmallScreen,
              ), // Use QuizInfoTimerCard
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QuestionCard(question: question, isSmallScreen: isSmallScreen), // Use QuestionCard
                        const SizedBox(height: 20),
                        AnswerInput(
                          answerController: _answerController,
                          hasSubmitted: _hasSubmitted,
                          onChanged: (value) => _userAnswers[_currentQuestionIndex] = value,
                        ), // Use AnswerInput
                      ],
                    ),
                  ),
                ),
              ),
              NavigationButtons(
                currentQuestionIndex: _currentQuestionIndex,
                totalQuestions: _flashcards.length,
                onPrevious: _previousQuestion,
                onNext: _nextQuestion,
                onSubmit: _showSubmitConfirmation,
              ), // Use NavigationButtons
            ],
          ),
        ],
      ),
    );
  }
}
