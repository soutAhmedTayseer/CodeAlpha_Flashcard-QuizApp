import 'package:flutter/material.dart';
import 'package:flutter_projects/mcq_questions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'mcq_quiz_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'general knowledge'.tr(), 'id': 9, 'image': 'assets/images/general knowledge.jpeg'},
    {'title': 'books'.tr(), 'id': 10, 'image': 'assets/images/books.jpeg'},
    {'title': 'film'.tr(), 'id': 11, 'image': 'assets/images/film.jpeg'},
    {'title': 'music'.tr(), 'id': 12, 'image': 'assets/images/music.jpeg'},
    {'title': 'science'.tr(), 'id': 17, 'image': 'assets/images/science.jpeg'},
    {'title': 'geography'.tr(), 'id': 22, 'image': 'assets/images/geography.jpeg'},
    {'title': 'history'.tr(), 'id': 23, 'image': 'assets/images/history.jpeg'},
    {'title': 'politics'.tr(), 'id': 24, 'image': 'assets/images/politics.jpeg'},
    {'title': 'sports'.tr(), 'id': 21, 'image': 'assets/images/sports.jpeg'},
    {'title': 'animals'.tr(), 'id': 27, 'image': 'assets/images/animals.jpeg'},
  ];

  String searchQuery = ''; // To hold the search query

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories
        .where((category) =>
        category['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
                    labelText: 'search'.tr(), // Localized string
                    labelStyle: const TextStyle(color: Colors.green),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: filteredCategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final category = filteredCategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsScreen(
                                categoryTitle: category['title'],
                                categoryId: category['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(category['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                category['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuestionsScreen extends StatefulWidget {
  final String categoryTitle;
  final int categoryId;

  const QuestionsScreen({
    required this.categoryTitle,
    required this.categoryId,
    super.key,
  });

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Future<List<Question>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = fetchQuestions(widget.categoryId);
  }

  Future<List<Question>> fetchQuestions(int categoryId) async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api.php?amount=10&category=$categoryId'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['results'];
      return data.map((questionData) => Question.fromJson(questionData)).toList();
    } else {
      throw Exception('failed to load questions'.tr()); // Localized error message
    }
  }

  void _showStartQuizDialog(List<Question> questions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('start quiz'.tr()), // Localized string
          content: Text('confirm start quiz'.tr()), // Localized string
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MCQQuizScreen(
                      questions: questions,
                      category: widget.categoryTitle,
                    ),
                  ),
                );
              },
              child: Text(
                'start quiz'.tr(),
                style: const TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background home3.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<Question>>(
            future: _questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load questions'.tr())); // Localized error
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('no questions available'.tr())); // Localized string
              }

              final questions = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return Container(
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
                              question.question,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${"answer".tr()}: ${question.correctAnswer}", // Localized string
                              style: const TextStyle(color: Colors.white),
                            ),
                            tileColor: Colors.transparent,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _showStartQuizDialog(questions),
                      icon: const Icon(Icons.quiz),
                      label: Text('start quiz'.tr()), // Localized button label
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
