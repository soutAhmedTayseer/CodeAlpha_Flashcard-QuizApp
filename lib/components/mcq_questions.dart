class Question {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String difficulty; // Add difficulty field

  Question({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty, // Initialize the difficulty
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final incorrectAnswers = List<String>.from(json['incorrect_answers']);
    return Question(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: incorrectAnswers,
      difficulty: json['difficulty'], // Extract the difficulty from JSON
    );
  }
}
