import 'package:bmi_calculator_2022_updated/Table_Generated_Page.dart';
import 'package:bmi_calculator_2022_updated/calculator_brain.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Quiz_Database_detail_.dart';
import 'Reusable_Container_Widget.dart';
import 'Reusable_Container_button.dart';
import 'constantFile.dart';

enum table {
  table_generator,
  table_quiz,
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  table? selectedoperation;
  int table_number = 10;
  int upper_limit = 10;
  int lower_limit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TABLE CALCULATOR'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ReuseableContainer(
                    onPress: () {
                      setState(() {
                        selectedoperation = table.table_generator;
                      });
                    },
                    colorr: selectedoperation == table.table_generator
                        ? kactiveColor
                        : kinactiveColor,
                    cardWidget: IconColumn(
                      icon: FontAwesomeIcons.table,
                      label: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Table Generator",
                            style: kLabelStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseableContainer(
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDatabaseTablesPage(),
                        ),
                      );
                    },
                    colorr: selectedoperation == table.table_quiz
                        ? kactiveColor
                        : kinactiveColor,
                    cardWidget: IconColumn(
                      icon: FontAwesomeIcons.fileCircleQuestion,
                      label: SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Quiz",
                            style: kLabelStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ReuseableContainer(
              colorr: kactiveColor,
              cardWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Table Number",
                    style: kLabelStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        table_number.toString(),
                        style: kNumberStyle,
                      ),
                    ],
                  ),
                  Slider(
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.lightBlue,
                    value: table_number.toDouble(),
                    onChanged: (double newValue) {
                      setState(() {
                        table_number = newValue.round();
                      });
                    },
                    min: 1,
                    max: 10,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ReuseableContainer(
                    colorr: kactiveColor,
                    cardWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Upper Limit",
                          style: kLabelStyle,
                        ),
                        Text(
                          upper_limit.toString(),
                          style: kNumberStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  upper_limit++;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  if (upper_limit > 1) {
                                    upper_limit--;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReuseableContainer(
                    colorr: kactiveColor,
                    cardWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Lower Limit",
                          style: kLabelStyle,
                        ),
                        Text(
                          lower_limit.toString(),
                          style: kNumberStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  lower_limit++;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  if (lower_limit > 1) {
                                    lower_limit--;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                CalculatorBrain calc = CalculatorBrain(
                    table_number: table_number,
                    upper_limit: upper_limit,
                    lower_limit: lower_limit);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      tableGenerated: calc.generateTable(),
                      tableNumber: table_number,
                      lowerLimit: lower_limit,
                      upperlimit: upper_limit,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                height: 70.0,
                color: Colors.indigo[700],
                child: const Center(
                  child: Text(
                    "Generate",
                    style: kbottemContainerStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(icon),
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      fillColor: Colors.indigo,
      constraints: const BoxConstraints.tightFor(width: 40.0, height: 40.0),
    );
  }
}



