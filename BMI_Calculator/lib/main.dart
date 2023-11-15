import 'package:flutter/material.dart';

import 'input_page.dart';

void main() => runApp(const BMICalculator());

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1F184C),
        scaffoldBackgroundColor: Colors.black54,
      ),
      debugShowCheckedModeBanner: false,
      home: InputPage(),
    );
  }
}
