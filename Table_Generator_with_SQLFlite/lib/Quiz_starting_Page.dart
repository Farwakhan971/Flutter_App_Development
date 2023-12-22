import 'package:flutter/material.dart';

import 'Multiple_choice_Question_Page.dart';
import 'True_False_Quiz_Page.dart';

class QuizGenerationPage extends StatelessWidget {
  final String questionType;
  final int tableNumber;
  final int numberOfQuestions;
  QuizGenerationPage({
    required this.questionType,
    required this.tableNumber,
    required this.numberOfQuestions,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$questionType Quiz'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              color: Colors.indigo,
              size: 60.0,
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text(
                'Are you ready to start the quiz?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                if (questionType == 'True & False') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrueFalseQuizPage(
                        tableNumber: tableNumber,
                        numberOfQuestions: numberOfQuestions,
                      ),
                    ),
                  );
                } else if (questionType == 'Multiple Choice') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultipleChoiceQuizPage(
                        tableNumber: tableNumber,
                        numberOfQuestions: numberOfQuestions,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo, // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set button border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              child: Text(
                'Start Quiz',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
