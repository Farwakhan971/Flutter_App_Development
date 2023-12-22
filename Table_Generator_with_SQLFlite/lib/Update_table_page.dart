import 'package:flutter/material.dart';

import 'Database_Helper_ Class.dart';
import 'Generated_table_class.dart';

class UpdateTablePage extends StatefulWidget {
  final GeneratedTable table;

  UpdateTablePage({required this.table});

  @override
  _UpdateTablePageState createState() => _UpdateTablePageState();
}

class _UpdateTablePageState extends State<UpdateTablePage> {
  late int newUpperLimit;
  late int newLowerLimit;

  String? validateLimits() {
    if (newUpperLimit <= newLowerLimit) {
      return 'Upper limit should be greater than lower limit';
    }
    return null; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'New Upper Limit',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.indigo,
              onChanged: (value) {
                newUpperLimit = int.parse(value);
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Lower Limit',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.indigo,
              onChanged: (value) {
                newLowerLimit = int.parse(value);
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate limits
                String? validationError = validateLimits();
                if (validationError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(validationError),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                widget.table.upperLimit = newUpperLimit;
                widget.table.lowerLimit = newLowerLimit;
                widget.table.generatedTableEntries =
                    widget.table.generateEntries();
                DatabaseHelper dbHelper = DatabaseHelper();
                await dbHelper.updateTable(widget.table);
                Navigator.pop(context, widget.table);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: Size(150, 50),
              ),
              child: Text('UPDATE TABLE',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
