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
      // If all questions have been used, reset _usedIndices
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
              child: const Text('Add'),
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
              child: const Text('Add Random'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedFlashcards() {
    if (_selectedIndices.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Flashcards'),
          content: const Text('Are you sure you want to delete the selected flashcards?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  final indicesToRemove = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
                  for (var index in indicesToRemove) {
                    flashcards.removeAt(index);
                  }
                  _saveFlashcards();
                  _updateFilteredFlashcards();
                  _selectedIndices.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllFlashcards() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Flashcards'),
          content: const Text('Are you sure you want to delete all flashcards?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  flashcards.clear();
                  _saveFlashcards();
                  _updateFilteredFlashcards();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete All'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello There !'),
        actions: [
          if (_selectedIndices.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedFlashcards,
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _deleteAllFlashcards,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
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
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(_filteredFlashcards[index]['question']!),
                      subtitle: Text(_filteredFlashcards[index]['answer']!),
                      onTap: () => _editFlashcard(index),
                      onLongPress: () => _onCardLongPress(index),
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
                ElevatedButton(
                  onPressed: _addFlashcard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Flashcard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestScreen(flashcards: flashcards),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Start Quiz'),
                ),
              ],
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

  void _onCardLongPress(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }
}
