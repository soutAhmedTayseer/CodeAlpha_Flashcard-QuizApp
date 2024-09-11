import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  TestScreen({required this.flashcards});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, String>> _flashcards = [];
  List<Map<String, String>> _results = [];
  Map<int, String> _userAnswers = {}; // Store answers for each question
  TextEditingController _answerController = TextEditingController(); // Controller for text field
  int _quizNumber = 1;
  bool _isButtonPressed = false;
  late Timer _timer;
  int _timeRemaining = 1200; // 20 minutes for the quiz
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _flashcards = List.from(widget.flashcards);
    _flashcards.shuffle(); // Shuffle the questions randomly
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

    // Increment quiz number for next quiz
    await prefs.setInt('quizNumber', _quizNumber + 1);
    setState(() {
      _quizNumber++;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          _timer.cancel();
          _hasSubmitted = true;
          _submitAnswer(); // Automatically submit when time is up
          Future.delayed(Duration(seconds: 1), () {
            _navigateToResultScreen();
          });
        }
      });
    });
  }

  void _submitAnswer() {
    if (_hasSubmitted) return; // Prevents submission after quiz is completed

    // Store the current answer before submission
    _storeCurrentAnswer();

    // Add result for the current question
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

    _saveResults(); // Save results when quiz ends
    _navigateToResultScreen(); // Show results immediately after submission
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
          title: Text('Are you sure?'),
          content: Text('If you exit, your progress will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay on the page
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Exit the quiz
              child: Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
  }

  // Store the current answer for the question
  void _storeCurrentAnswer() {
    _userAnswers[_currentQuestionIndex] = _answerController.text.trim();
  }

  // Load the answer for the current question
  void _loadCurrentAnswer() {
    _answerController.text = _userAnswers[_currentQuestionIndex] ?? ''; // Set the answer if available
  }

  // Navigation: Move to previous question
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _storeCurrentAnswer(); // Store the current answer
      setState(() {
        _currentQuestionIndex--;
        _loadCurrentAnswer(); // Load the previous question's answer
      });
    }
  }

  // Navigation: Move to next question
  void _nextQuestion() {
    if (_currentQuestionIndex < _flashcards.length - 1) {
      _storeCurrentAnswer(); // Store the current answer
      setState(() {
        _currentQuestionIndex++;
        _loadCurrentAnswer(); // Load the next question's answer
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white, // Dark background color
        body: Center(child: Text('No flashcards available', style: TextStyle(color: Colors.orange))),
      );
    }

    final currentCard = _flashcards[_currentQuestionIndex];
    final question = currentCard['question']!;

    double progress = _timeRemaining / 1200; // Progress for the progress bar

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black45, // Dark background color
        body: Column(
          children: [
            // Timer and Quiz Info Card
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey[800], // Light grey card color
                elevation: 4,
                margin: const EdgeInsets.only(top: 30.0), // Added margin to move card lower
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Progress bar with time inside it
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70, // Adjust this value for a smaller circular progress bar
                            height: 70,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _timeRemaining < 60 ? Colors.red : Colors.orange,
                              ),
                              strokeWidth: 8.0, // Thinner stroke width
                            ),
                          ),
                          Text(
                            '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 16, // Smaller font size
                              color: Colors.orange, // Dark orange text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16), // Space between progress bar and text
                      // Quiz and question info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quiz $_quizNumber',
                              style: TextStyle(fontSize: 16, color: Colors.orange), // Dark orange text color
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Question ${_currentQuestionIndex + 1} of ${_flashcards.length}',
                              style: TextStyle(fontSize: 16, color: Colors.orange), // Dark orange text color
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Centered Content area with scrollable questions and answers
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Question text Card
                      Card(
                        color: Colors.grey[800], // Light grey card color
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // Smaller padding
                          child: Center(
                            child: Text(
                              question,
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.orange), // Dark orange text color
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Answer input field Card
                      Card(
                        color: Colors.grey[800], // Light grey card color
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0), // Smaller padding
                          child: TextField(
                            controller: _answerController,
                            decoration: InputDecoration(
                              labelText: 'Your Answer',
                              labelStyle: TextStyle(color: Colors.orange), // Dark orange label text color
                            ),
                            onChanged: (value) => _userAnswers[_currentQuestionIndex] = value, // Save in real-time
                            textAlign: TextAlign.center,
                            enabled: !_hasSubmitted, // Disable input after quiz submission
                            maxLines: null, // Allow multiple lines
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.white), // Dark orange input text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed Navigation Buttons
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
                              backgroundColor: Colors.grey[800], // Button color matches card color
                            ),
                            child: Text('Previous', style: TextStyle(color: Colors.orange)),
                          ),
                        ),
                        SizedBox(width: 10), // Add spacing between buttons
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentQuestionIndex < _flashcards.length - 1 ? _nextQuestion : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800], // Button color matches card color
                            ),
                            child: Text('Next', style: TextStyle(color: Colors.orange)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Submit button visible only on the final question
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
                          duration: Duration(milliseconds: 100),
                          width: double.infinity, // Full-width button
                          height: 50,
                          decoration: BoxDecoration(
                            color: _isButtonPressed ? Colors.grey[800] : Colors.grey[700], // Darker shade when pressed
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
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
      ),
    );
  }

  // Show a warning dialog when submitting while time is remaining
  void _showSubmitWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time Remaining'),
        content: Text('You still have time left. Are you sure you want to submit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitAnswer();
              _navigateToResultScreen();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final List<Map<String, String>> results;

  ResultScreen({required this.score, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background color
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.grey[800], // Dark app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange), // Dark orange text color
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    color: Colors.grey[800], // Light grey card color
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(result['question']!, style: TextStyle(color: Colors.orange)), // Dark orange text color
                      subtitle: Text(
                        'Your Answer: ${result['userAnswer']}\nCorrect Answer: ${result['correctAnswer']}\nResult: ${result['result']}',
                        style: TextStyle(fontSize: 14, color: Colors.orange), // Dark orange text color
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
