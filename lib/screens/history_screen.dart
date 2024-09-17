import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../components/background_widget.dart';
import '../components/confirmation_dialog.dart';
import '../components/quiz_card.dart';
import '../components/quiz_results_dialog.dart';
import '../components/searchbar_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, List<Map<String, String>>> _quizzes = {};
  Map<String, List<Map<String, String>>> _filteredQuizzes = {};
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedQuizzes = {};
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _loadResults();
    _searchController.addListener(_filterQuizzes);
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final quizzes = <String, List<Map<String, String>>>{};

    for (final key in keys) {
      if (key.startsWith('Quiz ')) {
        final results = prefs.getStringList(key);
        if (results != null) {
          quizzes[key] = results.map((result) {
            final parts = result.split('|');
            return {
              'question': parts[0],
              'userAnswer': parts[1],
              'correctAnswer': parts[2],
              'result': parts[3],
              'date': parts.length > 4 ? parts[4] : '',
            };
          }).toList();
        }
      }
    }

    setState(() {
      _quizzes = quizzes;
      _filteredQuizzes = quizzes;
    });
  }

  void _filterQuizzes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredQuizzes = Map.fromEntries(
        _quizzes.entries.where((entry) {
          final quizLabel = entry.key.toLowerCase();
          return quizLabel.contains(query);
        }),
      );
    });
  }

  void _deleteQuizzes(Set<String> quizLabels) async {
    final prefs = await SharedPreferences.getInstance();

    for (final quizLabel in quizLabels) {
      prefs.remove(quizLabel);
      _quizzes.remove(quizLabel);
    }

    _renumberQuizzes();

    setState(() {
      _filteredQuizzes = _quizzes;
      _selectedQuizzes.clear();
      _isSelecting = false;
    });
  }

  void _deleteAllQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys.where((key) => key.startsWith('Quiz '))) {
      prefs.remove(key);
    }

    setState(() {
      _quizzes.clear();
      _filteredQuizzes.clear();
    });
  }

  void _renumberQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final newQuizzes = <String, List<Map<String, String>>>{};
    int counter = 1;

    for (final key in keys.where((key) => key.startsWith('Quiz'))) {
      final results = prefs.getStringList(key);
      if (results != null) {
        final newKey = 'Quiz $counter';
        newQuizzes[newKey] = results.map((result) {
          final parts = result.split('|');
          return {
            'question': parts[0],
            'userAnswer': parts[1],
            'correctAnswer': parts[2],
            'result': parts[3],
            'date': parts.length > 4 ? parts[4] : '',
          };
        }).toList();
        counter++;
      }
    }

    await prefs.clear();
    for (final entry in newQuizzes.entries) {
      await prefs.setStringList(entry.key, entry.value.map((map) => map.values.join('|')).toList());
    }

    setState(() {
      _quizzes = newQuizzes;
      _filteredQuizzes = newQuizzes;
    });
  }

  void _showQuizResults(String quizLabel) {
    final results = _quizzes[quizLabel] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuizResultsDialog(
          quizLabel: quizLabel,
          results: results,
          onDelete: () => _showDeleteConfirmation(quizLabel),
        );
      },
    );
  }

  void _showDeleteConfirmation(String quizLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: tr("Confirm Deletion"),
          content: tr("Are you sure you want to delete this quiz?"),
          onConfirm: () {
            Navigator.of(context).pop();
            _deleteQuizzes({quizLabel});
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: tr("Confirm Deletion"),
          content: tr("Are you sure you want to delete all quizzes?"),
          onConfirm: () {
            Navigator.of(context).pop();
            _deleteAllQuizzes();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedQuizzes = Map.fromEntries(
      _filteredQuizzes.entries.toList()
        ..sort((a, b) {
          final dateA = DateTime.tryParse(a.value.first['date'] ?? '') ?? DateTime.now();
          final dateB = DateTime.tryParse(b.value.first['date'] ?? '') ?? DateTime.now();
          return dateB.compareTo(dateA); // Descending order
        }),
    );

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/background home3.jpeg'), // Use BackgroundImage

          Column(
            children: [
              CustomSearchBar(
                controller: _searchController, // Provide controller to CustomSearchBar
                onChanged: (value) {
                  _filterQuizzes(); // Call filter method on text change
                },
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sortedQuizzes.keys.length,
                  itemBuilder: (context, index) {
                    final quizLabel = sortedQuizzes.keys.toList()[index];

                    return QuizCard(
                      label: quizLabel,
                      onTap: () {
                        if (!_isSelecting) {
                          _showQuizResults(quizLabel);
                        }
                      },
                    );
                  },
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
}
