import 'package:flutter/material.dart';
import 'package:midterm_mad/settings.dart';

import 'tasbeeh_counter.dart';

void main() {
  runApp(const MyApp());
}

class Tasbeeh {
  final String name;
  final int countLimit;
  int currentCount;
  int cumulativeCount; // New variable for cumulative count

  Tasbeeh(this.name, this.countLimit, this.currentCount) : cumulativeCount = 0;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasbeeh Counter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Tasbeeh Counter'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tasbeeh> tasbeehList = [];

  _MyHomePageState() {
    tasbeehList.add(Tasbeeh('SubhanAllah', 33, 0));
    tasbeehList.add(Tasbeeh('Alhamdulillah', 33, 0));
    tasbeehList.add(Tasbeeh('Allahuakbar', 33, 0));
    tasbeehList.add(Tasbeeh('La ilaha illallah', 33, 0));
    tasbeehList.add(Tasbeeh('Astaghfir-Allah', 33, 0));
    tasbeehList.add(Tasbeeh('Bismillah', 33, 0));
    tasbeehList
        .add(Tasbeeh('Allahuma Salli Ala Muhammadin Wa Aale Muhammad', 33, 0));
    tasbeehList.add(Tasbeeh('Ya Waliyyul Hasanaat', 33, 0));
    tasbeehList.add(
        Tasbeeh('Subhaan Allah Wa Bi Hamdihi Subhan Allah il-Azeem', 33, 0));
    tasbeehList.add(Tasbeeh('Laa Hawla Wa Laa Quwwata illa Billaah', 33, 0));
    tasbeehList.add(Tasbeeh('Ayate Karima', 33, 0));
  }

  Widget createTasbeehContainer(Tasbeeh tasbeeh) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TasbeehCounter(
                tasbeeh: tasbeeh,
                onSetCompleted:
                    (int setsCompleted, int totalCount, int currentRoundCount) {
                  setState(() {
                    tasbeeh.currentCount = currentRoundCount;
                    tasbeeh.cumulativeCount = totalCount;
                  });
                },
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            title: Text(tasbeeh.name, style: TextStyle(fontSize: 18)),
            contentPadding:
                EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 6),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Count: ${tasbeeh.currentCount}/${tasbeeh.countLimit} ',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  'Total Count: ${tasbeeh.cumulativeCount}',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTasbeehDialog(BuildContext context) {
    TextEditingController tasbeehNameController = TextEditingController();
    TextEditingController countLimitController = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? nameErrorText;
    String? countErrorText;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title:
              Text('Add a New Tasbeeh', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: tasbeehNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Tasbeeh Name',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    errorText: nameErrorText,
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid name';
                    }
                    if (int.tryParse(value) != null) {
                      return 'Name cannot be a number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: countLimitController,
                  decoration: InputDecoration(
                    labelText: 'Enter Tasbeeh Count',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    errorText: countErrorText,
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Enter a valid count';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String tasbeehName = tasbeehNameController.text;
                  int countLimit = int.tryParse(countLimitController.text)!;

                  Tasbeeh tasbeeh = Tasbeeh(tasbeehName, countLimit, 0);
                  setState(() {
                    tasbeehList.add(tasbeeh);
                  });
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    nameErrorText = null;
                    countErrorText = null;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55), // Adjust the height as needed
        child: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              for (Tasbeeh tasbeeh in tasbeehList)
                createTasbeehContainer(tasbeeh),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _showAddTasbeehDialog(context);
        },
        tooltip: 'Add New Tasbeeh',
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(28.0), // Set the shape to make it round
        ),
      ),
    );
  }
}
