class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.correctAnswerIndex,
    required this.question,
    required this.options,
  });
}

class MultipleChoiceQuestion extends Question {
  final List<String> options;
  final int correctAnswerIndex;

  const MultipleChoiceQuestion({
    required String question,
    required this.options,
    required this.correctAnswerIndex,
  }) : super(
          correctAnswerIndex: correctAnswerIndex,
          question: question,
          options: options,
        );
}

class TrueFalseQuestion extends Question {
  const TrueFalseQuestion({
    required String question,
    required bool correctAnswer,
  }) : super(
          correctAnswerIndex: correctAnswer ? 0 : 1,
          question: question,
          options: const ['True', 'False'],
        );
}
