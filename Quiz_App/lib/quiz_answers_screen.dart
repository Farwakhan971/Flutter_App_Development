import 'package:flutter/material.dart';
import 'package:quiz_app_tutorial/questions.dart';

class QuizAnswersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answers'),
      ),
      body: ListView.builder(
        itemCount: multipleChoiceQuestions.length,
        itemBuilder: (context, index) {
          final question = multipleChoiceQuestions[index];
          return ListTile(
            title: Text('Q${index + 1}: ${question.question}'),
            subtitle: Text(
                'Answer: ${question.options[question.correctAnswerIndex]}'),
          );
        },
      ),
    );
  }
}
