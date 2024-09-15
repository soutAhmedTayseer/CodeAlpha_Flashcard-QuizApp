import 'package:flutter/material.dart';
import 'package:flutter_projects/test_screen.dart'; // Adjust the path if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Map<String, String>> flashcards = [];
  List<Map<String, String>> _filteredFlashcards = [];
  final Set<int> _selectedIndices = {}; // Track selected cards
  List<String> _questions = [];
  List<String> _answers = [];
  final Set<int> _usedIndices = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeQuestionsAndAnswers();
    _loadFlashcards();
  }

  void _initializeQuestionsAndAnswers() {
    _questions = [
      'What is the capital of France?',
      'What is the largest planet in our solar system?',
      'Who wrote "To Kill a Mockingbird"?',
      'What is the chemical symbol for gold?',
      'What is the speed of light?',
      'Who painted the Mona Lisa?',
      'What is the hardest natural substance on Earth?',
      'What is the smallest unit of life?',
      'What planet is known as the Red Planet?',
      'What is the main ingredient in guacamole?',
      'Which ocean is the largest?',
      'What is the chemical symbol for water?',
      'Who discovered penicillin?',
      'What is the largest mammal?',
      'In which year did the Titanic sink?',
      'What is the freezing point of water in Celsius?',
      'Who wrote the play "Romeo and Juliet"?',
      'What is the capital of Japan?',
      'What is the boiling point of water in Fahrenheit?',
      'What is the largest desert in the world?',
      'What is the longest river in the world?',
      'What is the most spoken language in the world?',
      'Who is known as the father of modern physics?',
      'What is the capital of Australia?',
      'What is the symbol for potassium on the periodic table?',
      'What is the square root of 144?',
      'What is the primary gas found in Earth’s atmosphere?',
      'Who invented the telephone?',
      'What is the largest country by land area?',
      'What is the speed of sound in air?',
      'What is the tallest mountain in the world?',
      'Who wrote "The Odyssey"?',
      'What is the primary color of the sun?',
      'What is the main language spoken in Brazil?',
      'What planet is known for its rings?',
      'Who was the first man to walk on the moon?',
      'What is the chemical formula for salt?',
      'What is the most abundant element in the Earth’s crust?',
      'Which planet is closest to the Sun?',
      'What is the largest island in the world?',
      'What is the currency of Japan?',
      'What is the chemical symbol for iron?'
    ];

    _answers = [
      'Paris',
      'Jupiter',
      'Harper Lee',
      'Au',
      '299,792 km/s',
      'Leonardo da Vinci',
      'Diamond',
      'Cell',
      'Mars',
      'Avocado',
      'Pacific Ocean',
      'H2O',
      'Alexander Fleming',
      'Blue Whale',
      '1912',
      '0°C',
      'William Shakespeare',
      'Tokyo',
      '212°F',
      'Sahara Desert',
      'Nile River',
      'Mandarin',
      'Albert Einstein',
      'Canberra',
      'K',
      '12',
      'Nitrogen',
      'Alexander Graham Bell',
      'Russia',
      '343 m/s',
      'Mount Everest',
      'Homer',
      'Yellow',
      'Portuguese',
      'Saturn',
      'Neil Armstrong',
      'NaCl',
      'Oxygen',
      'Mercury',
      'Greenland',
      'Yen',
      'Fe'
    ];
  }

  String _generateUniqueRandomQuestion() {
    if (_usedIndices.length >= _questions.length) {
      _usedIndices.clear();
    }

    int index;
    do {
      index = Random().nextInt(_questions.length);
    } while (_usedIndices.contains(index));

    _usedIndices.add(index);
    return _questions[index];
  }

  String _generateRandomAnswer(String question) {
    final index = _questions.indexOf(question);
    return index >= 0 ? _answers[index] : 'Unknown';
  }

  void _addFlashcard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String question = '';
        String answer = '';
        return AlertDialog(
          title: const Text('Add Flashcard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Question'),
                  onChanged: (value) => question = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Answer'),
                  onChanged: (value) => answer = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards.add({'question': question, 'answer': answer});
                    _saveFlashcards();
                    _updateFilteredFlashcards();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide both question and answer.')),
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                final randomQuestion = _generateUniqueRandomQuestion();
                final randomAnswer = _generateRandomAnswer(randomQuestion);
                if (randomQuestion != 'No more unique questions available') {
                  setState(() {
                    flashcards.add({'question': randomQuestion, 'answer': randomAnswer});
                    _saveFlashcards();
                    _updateFilteredFlashcards();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No more unique questions available')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Random Generate', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
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
          title: const Text('Edit Flashcard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Question'),
                  onChanged: (value) => question = value,
                  controller: TextEditingController(text: question),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Answer'),
                  onChanged: (value) => answer = value,
                  controller: TextEditingController(text: answer),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards[index] = {'question': question, 'answer': answer};
                    _saveFlashcards();
                    _updateFilteredFlashcards();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _startQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Quiz'),
          content: const Text('Are you sure you want to start the quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(flashcards: flashcards),
                  ),
                );
              },
              child: const Text('Start Quiz', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _updateFilteredFlashcards() {
    setState(() {
      _filteredFlashcards = flashcards.where((card) {
        return card['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            card['answer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete all flashcards?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  flashcards.clear();
                  _filteredFlashcards.clear();
                  _saveFlashcards();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All flashcards deleted')),
                );
              },
              child: const Text('Delete All', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background home3.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: 'Search',
                    labelStyle: const TextStyle(color: Colors.green),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    filled: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _updateFilteredFlashcards();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredFlashcards.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndices.contains(index);
                    return Dismissible(
                      key: Key(_filteredFlashcards[index]['question']!),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        final removedCard = _filteredFlashcards[index];
                        setState(() {
                          _filteredFlashcards.removeAt(index);
                          flashcards.remove(removedCard);
                          _saveFlashcards();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Flashcard deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(() {
                                  _filteredFlashcards.insert(index, removedCard);
                                  flashcards.add(removedCard);
                                  _saveFlashcards();
                                });
                              },
                            ),
                          ),
                        );
                      },
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
                            _filteredFlashcards[index]['question']!,
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            _filteredFlashcards[index]['answer']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () => _editFlashcard(index),
                          tileColor: isSelected ? Colors.blueGrey[300] : Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addFlashcard,
                      icon: const Icon(Icons.add_card),
                      label: const Text('Add Flashcard'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green, backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _startQuiz,
                      icon: const Icon(Icons.quiz),
                      label: const Text('Start Quiz'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green, backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            right: 12,
            child: FloatingActionButton(
              onPressed: _showDeleteAllConfirmation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedCards = flashcards.map((card) {
      return '${card['question']}|${card['answer']}';
    }).toList();
    prefs.setStringList('flashcards', savedCards);
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
        _updateFilteredFlashcards();
      });
    }
  }
}
