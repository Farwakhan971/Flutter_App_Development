import 'package:flutter/material.dart';

import 'Database_Helper_ Class.dart';
import 'True_False_Quiz_Page.dart';

class ResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int tableNumber;
  final int numberOfQuestions;
  final List<bool?> previousAnswers;

  ResultPage({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.tableNumber,
    required this.numberOfQuestions,
    required this.previousAnswers,
  });
  String timestamp = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    double percentage = (correctAnswers / totalQuestions) * 100;
    String message = '';
    IconData icon = Icons.sentiment_very_satisfied;

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
        title: Text('Quiz Result'),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
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
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Total Questions: $totalQuestions',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrueFalseQuizPage(
                      tableNumber: tableNumber,
                      numberOfQuestions: numberOfQuestions,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(150.0, 50.0),
              ),
              child: Text(
                'Restart Quiz',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                int userScore =
                    previousAnswers.where((answer) => answer == true).length;

                // Save quiz record in the database
                await DatabaseHelper().insertQuizRecord(
                  tableNumber,
                  numberOfQuestions,
                  userScore,
                );

                // Retrieve quiz records from the database
                List<Map<String, dynamic>> quizRecords =
                    await DatabaseHelper().getQuizRecords();

                // Debugging statements
                print('Quiz Records: $quizRecords');

                // Navigate to a new page to display quiz records
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizRecordsPage(quizRecords: quizRecords),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(150.0, 50.0),
              ),
              child: Text(
                'Quiz Record',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizRecordsPage extends StatefulWidget {
  List<Map<String, dynamic>> quizRecords;

  QuizRecordsPage({required this.quizRecords});

  @override
  State<QuizRecordsPage> createState() => _QuizRecordsPageState();
}

class _QuizRecordsPageState extends State<QuizRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Records'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: widget.quizRecords.length,
        itemBuilder: (context, index) {
          final int quizNumber = index + 1;
          final Map<String, dynamic> record = widget.quizRecords[index];

          return Card(
            elevation: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quiz Number: $quizNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.indigo,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final int quizId = record['id'];
                      await DatabaseHelper.deleteQuizRecord(quizId);
                      setState(() {
                        final updatedQuizRecords =
                            List<Map<String, dynamic>>.from(widget.quizRecords);
                        updatedQuizRecords.removeAt(index);
                        widget.quizRecords = updatedQuizRecords;
                      });
                    },
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Table Number: ${record['tableNumber']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Questions: ${record['numberOfQuestions']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Correct Answers: ${record['correctAnswers']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
