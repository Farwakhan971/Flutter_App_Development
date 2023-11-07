import 'package:flutter/material.dart';
import 'package:midterm_mad/main.dart';
import 'package:midterm_mad/settings.dart';
import 'package:vibration/vibration.dart';

class TasbeehCounter extends StatefulWidget {
  final Tasbeeh tasbeeh;
  final void Function(int, int, int) onSetCompleted;

  TasbeehCounter({required this.tasbeeh, required this.onSetCompleted});

  @override
  _TasbeehCounterState createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends State<TasbeehCounter> {
  int _clicks = 0;
  int _setsCompleted = 0;
  int _totalCount = 0;
  int _currentRoundCount = 0;
  Duration cumulativeSetTime = Duration();
  double _progress = 0.0;

  void _incrementProgress() {
    setState(() {
      if (_clicks < widget.tasbeeh.countLimit) {
        _clicks++;
        _currentRoundCount = _clicks;
        // Calculate the percentage completed
        double percentage = (_clicks / widget.tasbeeh.countLimit);
        // Update progress
        _progress = percentage;
        // Update cumulative count
        cumulativeSetTime = Duration(
            seconds: (widget.tasbeeh.countLimit * _setsCompleted + _clicks));
      } else {
        _clicks = 0;
        _setsCompleted++;
        _currentRoundCount = 0;
      }
    });

    if (widget.onSetCompleted != null) {
      widget.onSetCompleted(
          _setsCompleted, cumulativeSetTime.inSeconds, _currentRoundCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text(widget.tasbeeh.name, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetCounter,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tasbeeh.name,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _incrementProgress();
                _vibrate();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      strokeWidth: 8,
                    ),
                  ),
                  Text(
                    '$_clicks',
                    style: TextStyle(fontSize: 50),
                  ),
                ],
              ),
            ),
            SizedBox(height: 38),
            Text(
              'Set completed: $_setsCompleted',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Cumulative: ${cumulativeSetTime.inSeconds} seconds',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _resetCounter() {
    setState(() {
      _clicks = 0;
      _setsCompleted = 0;
      _progress = 0.0;
      cumulativeSetTime = Duration();
    });
  }

  void _vibrate() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
  }
}
