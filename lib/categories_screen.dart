import 'package:flutter/material.dart';
import 'package:flutter_projects/mcq_questions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mcq_quiz_screen.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'General Knowledge', 'id': 9, 'image': 'assets/images/general knowledge.jpeg'},
    {'title': 'Books', 'id': 10, 'image': 'assets/images/books.jpeg'},
    {'title': 'Film', 'id': 11, 'image': 'assets/images/film.jpeg'},
    {'title': 'Music', 'id': 12, 'image': 'assets/images/music.jpeg'},
    {'title': 'Science', 'id': 17, 'image': 'assets/images/science.jpeg'},
    {'title': 'Geography', 'id': 22, 'image': 'assets/images/geography.jpeg'},
    {'title': 'History', 'id': 23, 'image': 'assets/images/history.jpeg'},
    {'title': 'Politics', 'id': 24, 'image': 'assets/images/politics.jpeg'},
    {'title': 'Sports', 'id': 21, 'image': 'assets/images/sports.jpeg'},
    {'title': 'Animals', 'id': 27, 'image': 'assets/images/animals'},
  ];

  String searchQuery = ''; // To hold the search query

  @override
  Widget build(BuildContext context) {
    // Filter categories based on search query
    final filteredCategories = categories
        .where((category) =>
        category['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update the search query
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
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 16, // Spacing between columns
                  mainAxisSpacing: 16, // Spacing between rows
                  childAspectRatio: 1, // To make them equal width and height
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
                            textAlign: TextAlign.center, // Center-aligns the text
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2), // Creates shadow in bottom-right direction
                                  blurRadius: 3.0,      // Adds blur to the shadow
                                  color: Colors.black54, // Shadow color
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
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load questions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final questions = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Answer: ${question.correctAnswer}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MCQQuizScreen(
                          questions: questions,
                          category: widget.categoryTitle, // Pass category here
                        ),
                      ),
                    );
                  },
                  child: const Text('Start Quiz'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
