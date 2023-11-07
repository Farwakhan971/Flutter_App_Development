import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVibrationEnabled = true;
  int? selectedColorIndex; // Selected theme color index
  List<Color> themeColors = [
    Colors.teal, // Theme 1
    Colors.blue, // Theme 2
    Colors.purple, // Theme 3
    Colors.orange, // Theme 4
  ];

  @override
  void initState() {
    super.initState();
    // Load the vibration state and selected theme color index from SharedPreferences
    loadVibrationState();
    loadThemeColor();
  }

  void loadVibrationState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    });
  }

  void saveVibrationState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('vibrationEnabled', value);
  }

  void loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedColorIndex = prefs.getInt('selectedColorIndex');
    });
  }

  void saveThemeColor(int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedColorIndex', newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Tasbeeh Counter', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            // Vibration switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Enable Vibration',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Switch(
                    activeColor: Colors.teal, // Set the switch color to teal
                    value: isVibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isVibrationEnabled = value;
                      });
                      saveVibrationState(
                          value); // Save the setting to SharedPreferences
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Theme color selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Select Theme Color',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: DropdownButton<int?>(
                    value: selectedColorIndex,
                    items: List<DropdownMenuItem<int?>>.generate(
                      themeColors.length,
                      (int index) => DropdownMenuItem<int?>(
                        value: index,
                        child: Text('Theme ${index + 1}'),
                      ),
                    ),
                    onChanged: (int? newIndex) {
                      if (newIndex != null) {
                        setState(() {
                          selectedColorIndex = newIndex;
                          saveThemeColor(newIndex);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
