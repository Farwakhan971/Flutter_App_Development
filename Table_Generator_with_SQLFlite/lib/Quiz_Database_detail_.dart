import 'package:bmi_calculator_2022_updated/Quiz_starting_Page.dart';
import 'package:flutter/material.dart';

import 'Database_Helper_ Class.dart';
import 'Generated_table_class.dart';
import 'Reusable_Container_button.dart';
import 'constantFile.dart';

class QuizDatabaseTablesPage extends StatefulWidget {
  @override
  _DatabaseTablesPageState createState() => _DatabaseTablesPageState();
}

class _DatabaseTablesPageState extends State<QuizDatabaseTablesPage> {
  List<GeneratedTable> allTables = [];

  @override
  void initState() {
    super.initState();
    fetchTables();
  }

  Future<void> fetchTables() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    allTables = await dbHelper.getAllTables();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Tables'),
      ),
      body: ListView.builder(
        itemCount: allTables.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              int selectedTableNumber = allTables[index].tableNumber;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tablequizdetails(
                      selectedTableNumber: selectedTableNumber),
                ),
              );
            },
            child: Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Table ${allTables[index].tableNumber}'),
                  ),
                  Divider(),
                  Table(
                    children: [
                      for (var i = allTables[index].lowerLimit;
                          i <= allTables[index].upperLimit;
                          i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${allTables[index].tableNumber} * $i = ${allTables[index].tableNumber * i}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Tablequizdetails extends StatefulWidget {
  final int selectedTableNumber;

  Tablequizdetails({required this.selectedTableNumber});

  @override
  _TableQuizdetailsState createState() => _TableQuizdetailsState();
}

class _TableQuizdetailsState extends State<Tablequizdetails> {
  int questno = 10;
  String _selectedQuestionType = 'True & False';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReuseableContainer(
              colorr: kactiveColor,
              cardWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Number of Questions",
                    style: kLabelStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        questno.toString(),
                        style: kNumberStyle,
                      ),
                    ],
                  ),
                  Slider(
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.lightBlue,
                    value: questno.toDouble(),
                    onChanged: (double newValue) {
                      setState(() {
                        questno = newValue.round();
                      });
                    },
                    min: 1,
                    max: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedQuestionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedQuestionType = value ?? 'True & False';
                    });
                  },
                  items:
                      ['True & False', 'Multiple Choice'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 30.0),
              ],
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizGenerationPage(
                      questionType: _selectedQuestionType,
                      numberOfQuestions: questno.toInt(),
                      tableNumber: widget.selectedTableNumber,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: Size(150, 50),
              ),
              child: const Text(
                'Generate Quiz',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
