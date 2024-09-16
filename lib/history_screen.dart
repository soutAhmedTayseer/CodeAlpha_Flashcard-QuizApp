import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

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

    for (final key in keys.where((key) => key.startsWith('Quiz '))) {
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
        return AlertDialog(
          title: Text(quizLabel),
          content: results.isEmpty
              ? Text(tr('No results available.'))
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: results.map((result) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Q: ${result['question']!}\n'
                        '${tr('Your answer')}: ${result['userAnswer']!}\n'
                        '${tr('Correct answer')}: ${result['correctAnswer']!}\n'
                        '${tr('Result')}: ${result['result']!}\n',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr("Close")),
            ),
            if (!_isSelecting) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(quizLabel);
                },
                child: Text(tr("Delete Quiz")),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(String quizLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr("Confirm Deletion")),
          content: Text(tr("Are you sure you want to delete this quiz?")),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr("Cancel")),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteQuizzes({quizLabel});
              },
              child: Text(tr("Delete")),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelection(String quizLabel) {
    setState(() {
      if (_selectedQuizzes.contains(quizLabel)) {
        _selectedQuizzes.remove(quizLabel);
      } else {
        _selectedQuizzes.add(quizLabel);
      }
    });
  }

  void _showMultiDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr("Confirm Deletion")),
          content: Text(tr("Are you sure you want to delete the selected quizzes?")),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr("Cancel")),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteQuizzes(_selectedQuizzes);
              },
              child: Text(tr("Delete")),
            ),
          ],
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
          return dateA.compareTo(dateB);
        }),
    );

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
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: tr('Search'),
                    labelStyle: TextStyle(color: Colors.green),
                    prefixIcon: Icon(Icons.search, color: Colors.green),
                    filled: true,
                  ),
                ),
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
                    final results = sortedQuizzes[quizLabel] ?? [];
                    final correctAnswers = results.where((result) => result['result'] == 'correct').length;
                    final totalQuestions = results.length;
                    final percentage = (totalQuestions > 0)
                        ? ((correctAnswers / totalQuestions) * 100).toStringAsFixed(0)
                        : '0';

                    return GestureDetector(
                      onTap: () {
                        if (!_isSelecting) {
                          _showQuizResults(quizLabel);
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: _getCardColor(percentage),
                        child: Center(
                          child: Text(
                            quizLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr("Confirm Deletion")),
          content: Text(tr("Are you sure you want to delete all quizzes?")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAllQuizzes();
              },
              child: Text(tr("Delete All"), style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr("Cancel"), style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Color _getCardColor(String percentage) {
    final double percent = double.tryParse(percentage) ?? 0.0;
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.yellow;
    return Colors.red; // Default to red if percentage is below 50
  }
}
