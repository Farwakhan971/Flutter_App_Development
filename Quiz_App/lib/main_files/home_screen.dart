import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int multipleChoiceScore = 0;
  int trueFalseScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Quiz App')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Farwa khan'),
              accountEmail: Text('farwakhan061101@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 64.0,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+ 923156943889'),
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Multiple Choice Quiz'),
              trailing: Text('$multipleChoiceScore'),
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/multiple_choice_quiz');
                if (result != null) {
                  setState(() {
                    multipleChoiceScore =
                        result as int; // Explicitly cast to int
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('True and False Quiz'),
              trailing: Text('$trueFalseScore'),
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/true_false_quiz');
                if (result != null) {
                  setState(() {
                    trueFalseScore = result as int;
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/multiple_choice_quiz');
                if (result != null) {
                  setState(() {
                    multipleChoiceScore =
                        result as int; // Explicitly cast to int
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Multiple Choice Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/true_false_quiz');
                if (result != null) {
                  setState(() {
                    trueFalseScore = result as int; // Explicitly cast to int
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'True and False Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
