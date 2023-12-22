import 'package:flutter/material.dart';

import 'Database_Helper_ Class.dart';
import 'Generated_table_class.dart';
import 'Update_table_page.dart';

class DatabaseTablesPage extends StatefulWidget {
  @override
  _DatabaseTablesPageState createState() => _DatabaseTablesPageState();
}

class _DatabaseTablesPageState extends State<DatabaseTablesPage> {
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
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
            child: Column(
              children: [
                ListTile(
                  title: Text('Table ${allTables[index].tableNumber}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedTable = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateTablePage(table: allTables[index]),
                            ),
                          );

                          if (updatedTable != null) {
                            setState(() {
                              allTables[index] = updatedTable;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Table'),
                                content: Text(
                                    'Are you sure you want to delete this table?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () async {
                                      // Delete the table and refresh the list
                                      DatabaseHelper dbHelper =
                                          DatabaseHelper();
                                      await dbHelper
                                          .deleteTable(allTables[index].id!);
                                      fetchTables();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
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
          );
        },
      ),
    );
  }
}
