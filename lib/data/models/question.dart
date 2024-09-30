class Question {
  final String title;
  final String description;
  final String context;
  final String tips;
  final int priority;
  final int difficulty;
  final String curState;

  Question({
    required this.title,
    required this.description,
    required this.context,
    required this.tips,
    required this.priority,
    required this.difficulty,
    required this.curState,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'context': context,
      'tips': tips,
      'priority': priority,
      'difficulty': difficulty,
      'curState': curState,
    };
  }
}
