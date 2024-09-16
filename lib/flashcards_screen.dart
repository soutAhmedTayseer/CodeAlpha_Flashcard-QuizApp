import 'package:flutter/material.dart';
import 'package:flutter_projects/flashcard_quiz_screen.dart'; // Adjust the path if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

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
      'What is the capital of France?'.tr(),
      'What is the largest planet in our solar system?'.tr(),
      'Who wrote "To Kill a Mockingbird"?'.tr(),
      'What is the chemical symbol for gold?'.tr(),
      'What is the speed of light?'.tr(),
      'Who painted the Mona Lisa?'.tr(),
      'What is the hardest natural substance on Earth?'.tr(),
      'What is the smallest unit of life?'.tr(),
      'What planet is known as the Red Planet?'.tr(),
      'What is the main ingredient in guacamole?'.tr(),
      'Which ocean is the largest?'.tr(),
      'What is the chemical symbol for water?'.tr(),
      'Who discovered penicillin?'.tr(),
      'What is the largest mammal?'.tr(),
      'In which year did the Titanic sink?'.tr(),
      'What is the freezing point of water in Celsius?'.tr(),
      'Who wrote the play "Romeo and Juliet"?'.tr(),
      'What is the capital of Japan?'.tr(),
      'What is the boiling point of water in Fahrenheit?'.tr(),
      'What is the largest desert in the world?'.tr(),
      'What is the longest river in the world?'.tr(),
      'What is the most spoken language in the world?'.tr(),
      'Who is known as the father of modern physics?'.tr(),
      'What is the capital of Australia?'.tr(),
      'What is the symbol for potassium on the periodic table?'.tr(),
      'What is the square root of 144?'.tr(),
      'What is the primary gas found in Earth’s atmosphere?'.tr(),
      'Who invented the telephone?'.tr(),
      'What is the largest country by land area?'.tr(),
      'What is the speed of sound in air?'.tr(),
      'What is the tallest mountain in the world?'.tr(),
      'Who wrote "The Odyssey"?'.tr(),
      'What is the primary color of the sun?'.tr(),
      'What is the main language spoken in Brazil?'.tr(),
      'What planet is known for its rings?'.tr(),
      'Who was the first man to walk on the moon?'.tr(),
      'What is the chemical formula for salt?'.tr(),
      'What is the most abundant element in the Earth’s crust?'.tr(),
      'Which planet is closest to the Sun?'.tr(),
      'What is the largest island in the world?'.tr(),
      'What is the currency of Japan?'.tr(),
      'What is the chemical symbol for iron?'.tr()
    ];

    _answers = [
      'Paris'.tr(),
      'Jupiter'.tr(),
      'Harper Lee'.tr(),
      'Au'.tr(),
      '299,792 km/s'.tr(),
      'Leonardo da Vinci'.tr(),
      'Diamond'.tr(),
      'Cell'.tr(),
      'Mars'.tr(),
      'Avocado'.tr(),
      'Pacific Ocean'.tr(),
      'H2O'.tr(),
      'Alexander Fleming'.tr(),
      'Blue Whale'.tr(),
      '1912'.tr(),
      '0°C'.tr(),
      'William Shakespeare'.tr(),
      'Tokyo'.tr(),
      '212°F'.tr(),
      'Sahara Desert'.tr(),
      'Nile River'.tr(),
      'Mandarin'.tr(),
      'Albert Einstein'.tr(),
      'Canberra'.tr(),
      'K'.tr(),
      '12'.tr(),
      'Nitrogen'.tr(),
      'Alexander Graham Bell'.tr(),
      'Russia'.tr(),
      '343 m/s'.tr(),
      'Mount Everest'.tr(),
      'Homer'.tr(),
      'Yellow'.tr(),
      'Portuguese'.tr(),
      'Saturn'.tr(),
      'Neil Armstrong'.tr(),
      'NaCl'.tr(),
      'Oxygen'.tr(),
      'Mercury'.tr(),
      'Greenland'.tr(),
      'Yen'.tr(),
      'Fe'.tr()
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
          title: Text('Add Flashcard'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Question'.tr()),
                  onChanged: (value) => question = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Answer'.tr()),
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
                    SnackBar(content: Text('Please provide both question and answer.'.tr())),
                  );
                }
              },
              child: Text('Add'.tr(), style: const TextStyle(color: Colors.green)),
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
                    SnackBar(content: Text('No more unique questions available'.tr())),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Random Generate'.tr(), style: const TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
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
          title: Text('Edit Flashcard'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Question'.tr()),
                  onChanged: (value) => question = value,
                  controller: TextEditingController(text: question),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Answer'.tr()),
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
              child: Text('Save'.tr(), style: const TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
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
          title: Text('Start Quiz'.tr()),
          content: Text('Are you sure you want to start the quiz?'.tr()),
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
              child: Text('Start Quiz'.tr(), style: const TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.red)),
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
          title: Text("Confirm Deletion".tr()),
          content: Text("Are you sure you want to delete all flashcards?".tr()),
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
                  SnackBar(content: Text('All flashcards deleted'.tr())),
                );
              },
              child: Text('Delete All'.tr(), style: const TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.grey)),
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
                    labelText: 'Search'.tr(),
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
                            content: Text('Flashcard deleted'.tr()),
                            action: SnackBarAction(
                              label: 'Undo'.tr(),
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
                      label: Text('Add Flashcard'.tr()),
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
                      label: Text('Start Quiz'.tr()),
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
