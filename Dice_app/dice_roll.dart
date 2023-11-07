import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceApp(),
    ),
  );
}

class DiceApp extends StatefulWidget {
  const DiceApp({Key? key}) : super(key: key);

  @override
  State<DiceApp> createState() => _DiceAppState();
}

class _DiceAppState extends State<DiceApp> {
  var random = new Random();
  var diceface1 = 1;
  var diceface2 = 2;
  var diceface3 = 3;
  var diceface4 = 4;
  var scaleFactor = 0.8;
  int playerScore1 = 0;
  int playerScore2 = 0;
  int playerScore3 = 0;
  int playerScore4 = 0;
  int currentPlayer = 1;
  bool gameStopped = false;
  String winner = '';
  bool restartButtonHovered = false;

  void _rollDice(int player) {
    if (currentPlayer == player) {
      if (!gameStopped) {
        int roll = random.nextInt(6) + 1;
        setState(() {
          switch (player) {
            case 1:
              diceface1 = roll;
              playerScore1 += roll;
              if (roll != 6) {
                currentPlayer = 2;
              }
              if (playerScore1 >= 50) {
                gameStopped = true;
                winner = 'Player 1';
              }
              break;
            case 2:
              diceface2 = roll;
              playerScore2 += roll;
              if (roll != 6) {
                currentPlayer = 3;
              }
              if (playerScore2 >= 50) {
                gameStopped = true;
                winner = 'Player 2';
              }
              break;
            case 3:
              diceface3 = roll;
              playerScore3 += roll;
              if (roll != 6) {
                currentPlayer = 4;
              }
              if (playerScore3 >= 50) {
                gameStopped = true;
                winner = 'Player 3';
              }
              break;
            case 4:
              diceface4 = roll;
              playerScore4 += roll;
              if (roll != 6) {
                currentPlayer = 1;
              }
              if (playerScore4 >= 50) {
                gameStopped = true;
                winner = 'Player 4';
              }
              break;
          }
        });
      }
    } else {
      // Show an alert indicating it's not the player's turn
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('It is Player $currentPlayer\'s turn!'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  void _restartGame() {
    setState(() {
      playerScore1 = 0;
      playerScore2 = 0;
      playerScore3 = 0;
      playerScore4 = 0;
      gameStopped = false;
      winner = '';
      currentPlayer = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dice App"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.white54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white54,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerColumn('Player 1', playerScore1, diceface1,
                          () {
                        _rollDice(1);
                      }),
                      _buildPlayerColumn('Player 2', playerScore2, diceface2,
                          () {
                        _rollDice(2);
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerColumn('Player 3', playerScore3, diceface3,
                          () {
                        _rollDice(3);
                      }),
                      _buildPlayerColumn('Player 4', playerScore4, diceface4,
                          () {
                        _rollDice(4);
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    width: 30,
                  ),
                  if (gameStopped)
                    Column(
                      children: [
                        AnimatedOpacity(
                          duration: Duration(seconds: 2),
                          opacity: 1.0,
                          child: Text(
                            'Game Over. Winner: $winner with a score of ${winner == 'Player 1' ? playerScore1 : winner == 'Player 2' ? playerScore2 : winner == 'Player 3' ? playerScore3 : playerScore4}',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              restartButtonHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              restartButtonHovered = false;
                            });
                          },
                          child: ElevatedButton(
                            onPressed: _restartGame,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                restartButtonHovered
                                    ? Colors.deepPurple
                                    : Colors.purple,
                              ),
                            ),
                            child: Text('Restart Game'),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerColumn(
      String player, int score, int dice, Function() onPressed) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'Score: $score',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 24.0),
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Transform.scale(
              scale: scaleFactor,
              child: Image.asset('images/dice$dice.png'),
            ),
          ),
        ),
      ],
    );
  }
}
