import 'package:flutter/material.dart';
import 'package:quiz_app_tutorial/main_files//home_screen.dart';
import 'package:quiz_app_tutorial/main_files//multiple_choice_quiz_screen.dart';
import 'package:quiz_app_tutorial/main_files//true_false_quiz_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData.light(), // Set the light theme
      darkTheme: ThemeData.dark(), // Set the dark theme
      themeMode: ThemeMode.dark, // Use dark theme
      initialRoute: '/',
      routes: {
        '/multiple_choice_quiz': (context) => MultipleChoiceQuizScreen(),
        '/true_false_quiz': (context) => TrueFalseQuizScreen(),
      },
      home: HomeScreen(),
    );
  }
}
