import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TrueFalseQuestion {
  final String question;
  final bool correctAnswer;

  TrueFalseQuestion({required this.question, required this.correctAnswer});
}

final List<TrueFalseQuestion> trueFalseQuestions = [
  TrueFalseQuestion(
    question: 'Flutter is a mobile app development framework.',
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    question: 'There are three main types of widgets in flutter.',
    correctAnswer: false,
  ),
  TrueFalseQuestion(
    question:
        'Dart programming language is used to build mobile applications in flutter.',
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    question: 'Expanded widget is used in flutter to give color to the text.',
    correctAnswer: false,
  ),
  TrueFalseQuestion(
    question: 'Statlesswidget means that static data is shown on the screen.',
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    question:
        'Statefulwidget is used to show dynamic content on the screen of the app.',
    correctAnswer: true,
  ),
  // Add more true/false questions
];

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizAnswersScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Show Answers',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizAnswersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answers'),
      ),
      body: ListView.builder(
        itemCount: trueFalseQuestions.length,
        itemBuilder: (context, index) {
          final question = trueFalseQuestions[index];
          return ListTile(
            title: Text('Question ${index + 1}: ${question.question}'),
            subtitle: Text(
                'Correct Answer: ${question.correctAnswer ? 'True' : 'False'}'),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TrueFalseQuizScreen(),
  ));
}

class TrueFalseQuizScreen extends StatefulWidget {
  const TrueFalseQuizScreen({Key? key}) : super(key: key);

  @override
  State<TrueFalseQuizScreen> createState() => _TrueFalseQuizScreenState();
}

class _TrueFalseQuizScreenState extends State<TrueFalseQuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  bool quizFinished = false;
  List<bool?> isAnswered = List.filled(trueFalseQuestions.length, null);
  int quizDuration = 1 * 60;
  int remainingTime = 1 * 60;
  late Timer quizTimer;

  @override
  void initState() {
    super.initState();
    startQuizTimer();
  }

  void startQuizTimer() {
    const oneSecond = Duration(seconds: 1);
    quizTimer = Timer.periodic(oneSecond, (Timer timer) {
      if (remainingTime <= 0) {
        finishQuiz();
        timer.cancel();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void finishQuiz() {
    quizTimer.cancel();
    setState(() {
      quizFinished = true;
    });
  }

  void pickAnswer(bool isTrue) {
    if (quizFinished || isAnswered[questionIndex] != null) return;

    final question = trueFalseQuestions[questionIndex];
    isAnswered[questionIndex] = isTrue == question.correctAnswer;
    if (isAnswered[questionIndex]!) {
      score++;
    }
    showFeedbackBottomSheet(isAnswered[questionIndex] == true);
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < trueFalseQuestions.length - 1) {
      questionIndex++;
    } else {
      finishQuiz();
    }
    setState(() {});
  }

  void showFeedbackBottomSheet(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Text(
            isCorrect ? 'Correct!' : 'Wrong.',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    quizTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = trueFalseQuestions[questionIndex];
    bool isLastQuestion = questionIndex == trueFalseQuestions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('True & False Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (questionIndex + 1) / trueFalseQuestions.length,
              ),
              SizedBox(height: 35),
              if (!quizFinished)
                Text(
                  'Time Remaining: ${remainingTime ~/ 60} minutes ${remainingTime % 60} seconds',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              SizedBox(
                width: 50,
                height: 20,
              ),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 12.0,
                percent: 1 - (remainingTime / quizDuration),
                center: Text(
                  "${((remainingTime / quizDuration) * 100).toInt()}%",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 21,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed:
                            quizFinished || isAnswered[questionIndex] != null
                                ? null
                                : () {
                                    pickAnswer(true);
                                    goToNextQuestion();
                                  },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Change the background color
                          onPrimary: Colors.white, // Change the text color
                          padding: EdgeInsets.all(23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Round the button edges
                          ),
                        ),
                        child: Text(
                          'True',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed:
                            quizFinished || isAnswered[questionIndex] != null
                                ? null
                                : () {
                                    pickAnswer(false);
                                    goToNextQuestion();
                                  },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Change the background color
                          onPrimary: Colors.white, // Change the text color
                          padding: EdgeInsets.all(23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Round the button edges
                          ),
                        ),
                        child: Text(
                          'False',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (quizFinished)
                RectangularButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(score: score),
                      ),
                    );
                  },
                  label: 'Finish',
                  buttonColor: Colors.red, // Change the background color
                  textColor: Colors.white, // Change the text color
                  borderRadius: 8, // Round the button edges
                ),
              if (!quizFinished && isLastQuestion)
                RectangularButton(
                  onPressed: () {
                    finishQuiz();
                  },
                  label: 'Finish Quiz Early',
                  buttonColor: Colors.orange, // Change the background color
                  textColor: Colors.white, // Change the text color
                  borderRadius: 8, // Round the button edges
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RectangularButton extends StatelessWidget {
  final Function() onPressed;
  final String label;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;

  RectangularButton({
    required this.onPressed,
    required this.label,
    required this.buttonColor,
    required this.textColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: textColor,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(label),
    );
  }
}
