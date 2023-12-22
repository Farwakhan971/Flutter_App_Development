import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'True_False_Questions.dart';
import 'True_False_Quiz_Result.dart';

class TrueFalseQuizPage extends StatefulWidget {
  final int tableNumber;
  final int numberOfQuestions;

  TrueFalseQuizPage({
    required this.tableNumber,
    required this.numberOfQuestions,
  });

  @override
  _TrueFalseQuizPageState createState() => _TrueFalseQuizPageState();
}

class _TrueFalseQuizPageState extends State<TrueFalseQuizPage> {
  late List<Map<String, dynamic>> trueFalseQuestions;
  bool? userAnswer;
  int currentQuestionIndex = 0;
  bool areButtonsDisabled = false;
  List<bool?> previousAnswers = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    trueFalseQuestions =
        QuizQuestions.trueFalseQuestions[widget.tableNumber] ?? [];
    trueFalseQuestions.shuffle();
    trueFalseQuestions =
        trueFalseQuestions.take(widget.numberOfQuestions).toList();
  }

  void checkAnswer(bool answer) {
    setState(() {
      userAnswer = answer;
      areButtonsDisabled = true;
      if (userAnswer != null &&
          userAnswer != trueFalseQuestions[currentQuestionIndex]['isTrue']) {
        Map<String, dynamic> currentQuestion =
            trueFalseQuestions[currentQuestionIndex];
        int numericCorrectAnswer = currentQuestion['numericAnswer'];
      }
    });
  }

  void showResultPage(int userScore) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalQuestions: trueFalseQuestions.length,
          correctAnswers: userScore,
          tableNumber: widget.tableNumber,
          numberOfQuestions: widget.numberOfQuestions,
          previousAnswers: previousAnswers,
        ),
      ),
    );
  }

  void goToNextQuestion() {
    setState(() {
      if (userAnswer != null) {
        previousAnswers.add(userAnswer);

        userAnswer = null;
        areButtonsDisabled = false;
        if (currentQuestionIndex < trueFalseQuestions.length - 1) {
          currentQuestionIndex++;
        } else {
          int correctAnswers = 0;

          for (int i = 0; i < trueFalseQuestions.length; i++) {
            if (previousAnswers[i] == trueFalseQuestions[i]['isTrue']) {
              correctAnswers++;
            }
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                totalQuestions: trueFalseQuestions.length,
                correctAnswers: correctAnswers,
                tableNumber: widget.tableNumber,
                numberOfQuestions: widget.numberOfQuestions,
                previousAnswers: previousAnswers,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please answer the current question.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.indigo,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var question = trueFalseQuestions[currentQuestionIndex];
    int totalQuestions = trueFalseQuestions.length;
    bool isTimerFinished = false;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('True & False Quiz'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(27.0),
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / totalQuestions,
                  color: Colors.indigo,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Countdown(
              seconds: totalQuestions * 60,
              build: (BuildContext context, double time) {
                if (time <= 0 && !isTimerFinished) {
                  // Timer is up
                  isTimerFinished = true;

                  Future.delayed(Duration.zero, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Time is up!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    areButtonsDisabled = true;

                    // Calculate the score based on answered questions
                    int userScore = previousAnswers
                        .where((answer) => answer == true)
                        .length;

                    // Pass the user score to the result page
                    showResultPage(userScore);
                  });
                }

                int minutes = time ~/ 60;
                int seconds = time.toInt() % 60;
                if (time <= 0) {
                  if (!isTimerFinished) {
                    isTimerFinished = true;
                    goToNextQuestion();
                  }
                }
                return Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                );
              },
              interval: Duration(seconds: 1),
              onFinished: () {
                // Check if the timer is already finished to avoid calling showResultPage multiple times
                if (!isTimerFinished) {
                  // Set isTimerFinished to true before calculating the score and showing the result page
                  isTimerFinished = true;

                  // Calculate the score based on answered questions
                  int userScore =
                      previousAnswers.where((answer) => answer == true).length;

                  // Pass the user score to the result page
                  showResultPage(userScore);
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: areButtonsDisabled
                                ? null
                                : () {
                                    checkAnswer(true);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: Size(400.0, 50.0),
                            ),
                            child: Text(
                              'True',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: areButtonsDisabled
                                ? null
                                : () {
                                    checkAnswer(false);
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              minimumSize: Size(400.0, 50.0),
                            ),
                            child: Text(
                              'False',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      if (userAnswer != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (userAnswer == question['isTrue'])
                              Icon(Icons.check,
                                  color: Colors.green, size: 30.0),
                            if (userAnswer != question['isTrue'])
                              Icon(Icons.close, color: Colors.red, size: 30.0),
                          ],
                        ),
                      SizedBox(height: 20.0),
                      if (userAnswer != null &&
                          userAnswer != question['isTrue'])
                        Text(
                          '${question['question'].split('=')[0].trim()} = ${question['numericAnswer']} is correct',
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                goToNextQuestion();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(150.0, 50.0),
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
