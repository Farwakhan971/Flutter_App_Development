import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quiz_app_tutorial/custom_asset/answer_card.dart';
import 'package:quiz_app_tutorial/custom_asset/next_button.dart';
import 'package:quiz_app_tutorial/main_files/result_screen.dart';
import 'package:quiz_app_tutorial/question.dart';
import 'package:quiz_app_tutorial/questions.dart';

class MultipleChoiceQuizScreen extends StatefulWidget {
  const MultipleChoiceQuizScreen({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceQuizScreen> createState() =>
      _MultipleChoiceQuizScreenState();
}

class _MultipleChoiceQuizScreenState extends State<MultipleChoiceQuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  bool quizFinished = false;
  int _duration = 60; // 1 minute in seconds
  late DateTime _endTime;
  late Timer? quizTimer; // Make it nullable

  List<MultipleChoiceQuestion> questions = multipleChoiceQuestions;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(seconds: _duration));
    startQuizTimer();
  }

  void startQuizTimer() {
    const oneSecond = Duration(seconds: 1);
    quizTimer = Timer.periodic(oneSecond, (timer) {
      final now = DateTime.now();
      if (now.isAfter(_endTime)) {
        finishQuiz();
        timer.cancel();
      }
    });
  }

  void finishQuiz() {
    quizTimer?.cancel();
    setState(() {
      quizFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: score),
        ),
      );
      return Container();
    }
    final question = questions[questionIndex];
    bool isLastQuestion = questionIndex == questions.length - 1;
    double percentage = (questionIndex + 1) / questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Choice Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LinearProgressIndicator(
                value: percentage,
              ),
              SizedBox(height: 35),
              Text(
                'Time Remaining: ${_formatTimeRemaining()}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 50,
                height: 20,
              ),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 12.0,
                percent: _getTimeRemainingPercentage(),
                center: Text(
                  "${((1 - _getTimeRemainingPercentage()) * 100).toInt()}%",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
              SizedBox(height: 20),
              Scrollbar(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: !quizFinished ? () => pickAnswer(index) : null,
                          child: AnswerCard(
                            currentIndex: index,
                            question: question.options[index],
                            isSelected: selectedAnswerIndex == index,
                            selectedAnswerIndex: selectedAnswerIndex,
                            correctAnswerIndex: question.correctAnswerIndex,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (isLastQuestion)
                RectangularButton(
                  onPressed: !quizFinished ? () => goToNextQuestion() : null,
                  label: 'Finish',
                )
              else
                RectangularButton(
                  onPressed: !quizFinished ? () => goToNextQuestion() : null,
                  label: 'Next',
                ),
            ],
          ),
        ),
      ),
    );
  }

  void pickAnswer(int value) {
    final question = questions[questionIndex];
    selectedAnswerIndex = value;
    if (selectedAnswerIndex == question.correctAnswerIndex) {
      score++;
    }
    setState(() {
      if (_endTime.isBefore(DateTime.now())) {
        finishQuiz();
      }
    });
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
      _endTime = DateTime.now().add(Duration(seconds: _duration));
    } else {
      finishQuiz();
    }
    setState(() {});
  }

  String _formatTimeRemaining() {
    final now = DateTime.now();
    final remainingDuration = _endTime.difference(now);
    final minutes = remainingDuration.inMinutes.remainder(60);
    final seconds = remainingDuration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  double _getTimeRemainingPercentage() {
    final now = DateTime.now();
    final remainingDuration = _endTime.difference(now);
    return remainingDuration.inSeconds / _duration;
  }

  @override
  void dispose() {
    quizTimer?.cancel();
    super.dispose();
  }
}
