import 'package:flutter/material.dart';

import 'Database_Helper_ Class.dart';
import 'Database_table_page.dart';
import 'Generated_table_class.dart';

class ResultPage extends StatefulWidget {
  final int tableNumber;
  final List<int> tableGenerated;
  final int lowerLimit;
  final int upperlimit;

  ResultPage({
    required this.tableNumber,
    required this.tableGenerated,
    required this.lowerLimit,
    required this.upperlimit,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<int> tableGenerated;

  @override
  void initState() {
    super.initState();
    tableGenerated = widget.tableGenerated;
  }

  Future<void> saveTableToDatabase() async {
    print('Saving table to database...');

    DatabaseHelper dbHelper = DatabaseHelper();
    bool isTableExists = await dbHelper.isTableExists(widget.tableNumber);

    if (isTableExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Table Already Exists'),
            content: Text(
                'Table ${widget.tableNumber} is already present in the database.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      GeneratedTable newTable = GeneratedTable(
        tableNumber: widget.tableNumber,
        upperLimit: widget.upperlimit,
        lowerLimit: widget.lowerLimit,
        generatedTableEntries: widget.tableGenerated,
      );

      await dbHelper.insertTable(newTable);
      print('Table saved to database.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DatabaseTablesPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TABLE GENERATOR'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Text(
                'Table ${widget.tableNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.indigo,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Table(
                children: [
                  for (var index = 0; index < tableGenerated.length; index++)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.tableNumber} x ${widget.lowerLimit + index} = ${widget.tableNumber * (widget.lowerLimit + index)}',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                saveTableToDatabase();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20.0, right: 70, left: 70),
                padding: const EdgeInsets.only(bottom: 10.0),
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.indigo[700],
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: const Center(
                  child: Text(
                    "Save to Database",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DatabaseTablesPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20.0, right: 70, left: 70),
                padding: const EdgeInsets.only(bottom: 10.0),
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.indigo[700],
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: const Center(
                  child: Text(
                    "View Tables",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
