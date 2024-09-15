import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  const TestScreen({super.key, required this.flashcards});

  @override
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
  bool _isButtonPressed = false;
  late Timer _timer;
  int _timeRemaining = 1200;
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
          return ResultScreen(score: _score, results: _results);
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

  Future<bool> _onWillPop() async {
    if (!_hasSubmitted && _timeRemaining > 0) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('If you exit, your progress will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcards available')),
      );
    }

    final currentCard = _flashcards[_currentQuestionIndex];
    final question = currentCard['question']!;

    double progress = _timeRemaining / 1200;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _timeRemaining < 60 ? Colors.red : Colors.orange,
                                  ),
                                  strokeWidth: 8.0,
                                ),
                              ),
                              Text(
                                '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
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
                                Text(
                                  'Quiz $_quizNumber',
                                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Question ${_currentQuestionIndex + 1} of ${_flashcards.length}',
                                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            color: Colors.grey[800],
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  question,
                                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.orange),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            color: Colors.grey[800],
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: _answerController,
                                decoration: const InputDecoration(
                                  labelText: 'Your Answer',
                                  labelStyle: TextStyle(color: Colors.orange),
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
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                                child: const Text('Previous', style: TextStyle(color: Colors.orange)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _currentQuestionIndex < _flashcards.length - 1 ? _nextQuestion : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                                child: const Text('Next', style: TextStyle(color: Colors.orange)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_currentQuestionIndex == _flashcards.length - 1)
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isButtonPressed = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _isButtonPressed = false;
                              });
                              if (!_hasSubmitted) {
                                if (_timeRemaining <= 0) {
                                  _submitAnswer();
                                  _navigateToResultScreen();
                                } else {
                                  _showSubmitWarning();
                                }
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isButtonPressed ? Colors.grey[800] : Colors.grey[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Submit Answer',
                                style: TextStyle(fontSize: 15, color: Colors.orange),
                              ),
                            ),
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

  void _showSubmitWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Remaining'),
        content: const Text('You still have time left. Are you sure you want to submit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitAnswer();
              _navigateToResultScreen();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final List<Map<String, String>> results;

  const ResultScreen({super.key, required this.score, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/q2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Your Score: $score',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final isCorrect = result['result'] == 'Correct';
                      final answerColor = isCorrect ? Colors.green : Colors.red;

                      return Card(
                        color: Colors.grey[800],
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            result['question']!,
                            style: const TextStyle(color: Colors.orange),
                          ),
                          subtitle: Text(
                            'Your Answer: ${result['userAnswer']}\nCorrect Answer: ${result['correctAnswer']}\nResult: ${result['result']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: answerColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
