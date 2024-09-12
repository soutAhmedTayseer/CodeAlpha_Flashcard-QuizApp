import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {'title': 'General Knowledge', 'id': 9, 'image': 'assets/images/1.jpg'},
    {'title': 'Books', 'id': 10, 'image': 'assets/images/1.jpg'},
    {'title': 'Film', 'id': 11, 'image': 'assets/images/1.jpg'},
    {'title': 'Music', 'id': 12, 'image': 'assets/images/1.jpg'},
    {'title': 'Science', 'id': 17, 'image': 'assets/images/1.jpg'},
    {'title': 'Geography', 'id': 22, 'image': 'assets/images/1.jpg'},
    {'title': 'History', 'id': 23, 'image': 'assets/images/1.jpg'},
    {'title': 'Politics', 'id': 24, 'image': 'assets/images/1.jpg'},
    {'title': 'Sports', 'id': 21, 'image': 'assets/images/1.jpg'},
    {'title': 'Animals', 'id': 27, 'image': 'assets/images/1.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
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
                // Implement search functionality here
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 16, // Spacing between columns
                  mainAxisSpacing: 16, // Spacing between rows
                  childAspectRatio: 1, // To make them equal width and height
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionsScreen(
                            categoryTitle: categories[index]['title']!,
                            categoryId: categories[index]['id']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(categories[index]['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            categories[index]['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

  const QuestionsScreen({required this.categoryTitle, required this.categoryId, super.key});

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
                    // Handle Start Quiz action here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quiz Started')),
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

class Question {
  final String question;
  final String correctAnswer;

  Question({required this.question, required this.correctAnswer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      correctAnswer: json['correct_answer'],
    );
  }
}
