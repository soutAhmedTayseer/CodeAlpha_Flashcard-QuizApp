import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/components/start_quiz_dialog_widget.dart';
import '../components/background_widget.dart';
import '../mcq_questions.dart';
import 'package:http/http.dart' as http;


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: Stack(
        children: [
          const BackgroundImage(imagePath: 'assets/images/background home3.jpeg'),
          FutureBuilder<List<Question>>(
            future: _questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('failed to load questions'.tr()));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('no questions available'.tr()));
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
                              "${"answer".tr()}: ${question.correctAnswer}",
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
                      onPressed: () => showStartQuizDialog(context, questions, widget.categoryTitle),
                      icon: const Icon(Icons.quiz),
                      label: Text('start quiz'.tr()),
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
