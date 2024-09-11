import 'package:flutter/material.dart';
import 'package:flutter_projects/test_screen.dart'; // Adjust the path if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Map<String, String>> flashcards = [];
  List<Map<String, String>> filteredFlashcards = [];
  final Set<int> _selectedIndices = {}; // Track selected cards
  List<String> _questions = [];
  List<String> _answers = [];
  final Set<int> _usedIndices = {};
  final Map<int, Map<String, String>> _deletedFlashcard = {}; // Track deleted flashcards
  final TextEditingController _searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _initializeQuestionsAndAnswers();
    _loadFlashcards();
    _searchController.addListener(_filterFlashcards); // Listen to search input changes
  }

  void _initializeQuestionsAndAnswers() {
    _questions = [
      // Your questions here
    ];

    _answers = [
      // Your answers here
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
          content: Column(
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
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards.add({'question': question, 'answer': answer});
                    _saveFlashcards();
                    _filterFlashcards(); // Reapply filtering after adding a flashcard
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
                    _filterFlashcards(); // Reapply filtering after adding a flashcard
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
          content: Column(
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
          actions: [
            TextButton(
              onPressed: () {
                if (question.isNotEmpty && answer.isNotEmpty) {
                  setState(() {
                    flashcards[index] = {'question': question, 'answer': answer};
                    _saveFlashcards();
                    _filterFlashcards(); // Reapply filtering after editing a flashcard
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
                  _filterFlashcards(); // Reapply filtering after deleting flashcards
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

  void _onCardLongPress(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  // Filter the flashcards based on the search input
  void _filterFlashcards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFlashcards = flashcards.where((flashcard) {
        final question = flashcard['question']!.toLowerCase();
        final answer = flashcard['answer']!.toLowerCase();
        return question.contains(query) || answer.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          if (_selectedIndices.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedFlashcards,
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFlashcards.isEmpty ? flashcards.length : filteredFlashcards.length,
              itemBuilder: (context, index) {
                final currentFlashcards = filteredFlashcards.isEmpty ? flashcards : filteredFlashcards;
                final isSelected = _selectedIndices.contains(index);
                return Dismissible(
                  key: Key(currentFlashcards[index]['question']!),
                  onDismissed: (direction) {
                    _deletedFlashcard[index] = currentFlashcards[index];

                    setState(() {
                      currentFlashcards.removeAt(index);
                      _saveFlashcards();
                      _filterFlashcards(); // Reapply filtering after deleting a flashcard
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Flashcard deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              flashcards.insert(index, _deletedFlashcard[index]!);
                              _saveFlashcards();
                              _filterFlashcards(); // Reapply filtering after undoing delete
                            });
                            _deletedFlashcard.remove(index);
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.delete_forever, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(currentFlashcards[index]['question']!),
                      subtitle: Text(currentFlashcards[index]['answer']!),
                      onTap: () => _editFlashcard(index),
                      onLongPress: () => _onCardLongPress(index),
                      tileColor: isSelected ? Colors.blueGrey[300] : Colors.transparent,
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
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
                  icon: const Icon(Icons.add),
                  label: const Text('Add Flashcard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700], // Adjust color as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestScreen(flashcards: flashcards),
                      ),
                    );
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Start Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700], // Adjust color as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
        filteredFlashcards = flashcards; // Initialize filtered list
      });
    }
  }
}
