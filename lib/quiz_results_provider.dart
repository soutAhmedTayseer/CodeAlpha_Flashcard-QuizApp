class QuizResult {
  final String date;
  final int score;

  QuizResult({required this.date, required this.score});
}

class QuizResultsProvider {
  final List<QuizResult> _results = [];

  void addResult(QuizResult result) {
    _results.add(result);
  }

  List<QuizResult> getResults() {
    return _results;
  }
}
