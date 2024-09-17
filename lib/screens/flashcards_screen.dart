import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/flashcard_quiz_screen.dart'; // Adjust the path if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import '../components/action_buttons.dart';
import '../components/add_flashcard_dialog.dart';
import '../components/background_widget.dart';
import '../components/delete_all_confirmation.dart';
import '../components/edit_flashcard_dialog.dart';
import '../components/flashcard_tile.dart';
import '../components/searchbar_widget.dart';
import '../components/start_quiz_dialog_widget.dart';


class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Map<String, String>> flashcards = [];
  List<Map<String, String>> _filteredFlashcards = [];
  final Set<int> _selectedIndices = {};
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
        return AddFlashcardDialog(
          onAdd: (question, answer) {
            setState(() {
              flashcards.add({'question': question, 'answer': answer});
              _saveFlashcards();
              _updateFilteredFlashcards();
            });
          },
          onGenerateRandom: () {
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
          },
        );
      },
    );
  }

  void _editFlashcard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditFlashcardDialog(
          initialQuestion: flashcards[index]['question']!,
          initialAnswer: flashcards[index]['answer']!,
          onSave: (question, answer) {
            setState(() {
              flashcards[index] = {'question': question, 'answer': answer};
              _saveFlashcards();
              _updateFilteredFlashcards();
            });
          },
        );
      },
    );
  }

  void _startQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StartQuizDialog(
          onStart: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardQuizScreen(flashcards: flashcards),
              ),
            );
          },
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
        return DeleteAllConfirmation(
          onConfirm: () {
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/background home3.jpeg'), // Use BackgroundImage

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(
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
                    return FlashcardTile(
                      flashcard: _filteredFlashcards[index],
                      isSelected: isSelected,
                      onTap: () => _editFlashcard(index),
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
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ActionButtons(
                  onAddFlashcard: _addFlashcard,
                  onStartQuiz: _startQuiz,
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
