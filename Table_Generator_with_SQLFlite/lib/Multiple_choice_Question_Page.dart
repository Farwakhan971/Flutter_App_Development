import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'Multiple_choice_Question_result_Page.dart';
import 'Multiple_choice_Questions.dart';

class MultipleChoiceQuizPage extends StatefulWidget {
  final int tableNumber;
  final int numberOfQuestions;
  MultipleChoiceQuizPage({
    required this.tableNumber,
    required this.numberOfQuestions,
  });

  @override
  _MultipleChoiceQuizPageState createState() => _MultipleChoiceQuizPageState();
}

class _MultipleChoiceQuizPageState extends State<MultipleChoiceQuizPage> {
  late List<Map<String, dynamic>> multipleChoiceQuestions;
  int selectedOptionIndex = -1;
  int currentQuestionIndex = 0;
  bool isTimerFinished = false;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    multipleChoiceQuestions =
        QuizQuestions_1.MultipleChoiceQuestions[widget.tableNumber] ?? [];
    multipleChoiceQuestions.shuffle();
    multipleChoiceQuestions =
        multipleChoiceQuestions.take(widget.numberOfQuestions).toList();
  }

  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
      print('Selected Option Index after tap: $selectedOptionIndex');
    });
  }

  void goToNextQuestion() {
    // Save the selectedOptionIndex before updating it
    int previousSelectedOptionIndex = selectedOptionIndex;

    setState(() {
      if (currentQuestionIndex < multipleChoiceQuestions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex =
            -1; // Reset selectedOptionIndex for the next question
      } else {
        // Call calculateCorrectAnswers with the current selected option
        int correctAnswers = calculateCorrectAnswers();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultipleChoiceResultPage(
              totalQuestions: multipleChoiceQuestions.length,
              correctAnswers: correctAnswers,
            ),
          ),
        );
      }
    });
  }

  int calculateCorrectAnswers() {
    // Initialize correctAnswers to 0
    int correctAnswers = 0;

    // Initialize userSelectedOption to -1 indicating no selection
    int userSelectedOption = -1;

    // Iterate through all multiple choice questions
    for (int i = 0; i < multipleChoiceQuestions.length; i++) {
      // Get the correct option value for the current question
      int? correctOptionValue = int.tryParse(multipleChoiceQuestions[i]
              ['options'][multipleChoiceQuestions[i]['correctOptionIndex']]) ??
          null;

      // Check if the user has selected an option for the current question
      int? selectedOptionValue = userSelectedOption == -1
          ? null
          : int.tryParse(
                  multipleChoiceQuestions[i]['options'][userSelectedOption]) ??
              null;

      // Check if the selected option for the current question is correct
      if (selectedOptionValue == null) {
        // No option selected, so the question is not considered
        print('No option selected for Question ${i + 1}.');
        continue;
      }

      if (selectedOptionValue == correctOptionValue) {
        // Increment correctAnswers
        correctAnswers++;
        print('Question ${i + 1} is correct.');
      } else {
        print('Question ${i + 1} is incorrect.');
      }
    }

    // Print the total correct answers
    print('Total Correct Answers: $correctAnswers');

    return correctAnswers;
  }

  @override
  Widget build(BuildContext context) {
    var question = multipleChoiceQuestions[currentQuestionIndex];
    int totalQuestions = multipleChoiceQuestions.length;
    bool isTimerFinished = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Choice Quiz'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(27.0),
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / totalQuestions,
                  color: Colors.indigo,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Countdown(
              seconds: totalQuestions * 60,
              build: (BuildContext context, double time) {
                int minutes = time ~/ 60;
                int seconds = time.toInt() % 60;

                if (time <= 0 && !isTimerFinished) {
                  isTimerFinished = true;
                  goToNextQuestion();
                }

                return Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                );
              },
              interval: const Duration(seconds: 1),
              onFinished: () {
                if (!isTimerFinished) {
                  isTimerFinished = true;
                  goToNextQuestion();
                }
              },
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['question'],
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            children: List.generate(
                              question['options'].length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Card(
                                  elevation: 3.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      selectOption(index);
                                      print(
                                          'Selected Option Index after tap: $selectedOptionIndex');
                                    },
                                    child: ListTile(
                                      tileColor: selectedOptionIndex == index
                                          ? Colors.indigo.withOpacity(0.1)
                                          : Colors.white,
                                      title: Text(
                                        '${question['options'][index]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedOptionIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    goToNextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    minimumSize: const Size(150.0, 50.0),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
