import 'package:bmi_calculator_2022_updated/Quiz_Database_detail_.dart';
import 'package:flutter/material.dart';

class MultipleChoiceResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  MultipleChoiceResultPage({
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (correctAnswers / totalQuestions) * 100;
    String message = '';
    IconData icon = Icons.sentiment_very_satisfied; // Default icon

    if (percentage == 100) {
      message = 'Congratulations! Perfect Score!';
    } else if (percentage >= 75) {
      message = 'Great Job! You nailed it!';
    } else if (percentage >= 50) {
      message = 'Good Effort! Keep it up!';
      icon = Icons.sentiment_satisfied;
    } else {
      message = 'You can do better. Keep Learning!';
      icon = Icons.sentiment_dissatisfied;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.indigo,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Total Questions: $totalQuestions',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Correct Answers: $correctAnswers',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizDatabaseTablesPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: const Size(150.0, 50.0),
              ),
              child: const Text(
                'Restart Quiz',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
