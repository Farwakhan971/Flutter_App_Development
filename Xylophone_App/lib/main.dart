import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MaterialApp(
    home: XylophoneApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  int numberOfButtons = 7;
  List<Color> buttonColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  List<String> audioFiles = [
    "note1.wav",
    "note2.wav",
    "note3.wav",
    "note4.wav",
    "note5.wav",
    "note6.wav",
    "note7.wav",
  ];

  void playSound(String audioFile) {
    final player = AssetsAudioPlayer();
    player.open(
      Audio("assets/$audioFile"),
    );
  }

  Expanded buildButton(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColors[index],
            minimumSize: Size(double.infinity, 100),
          ),
          onPressed: () {
            playSound(audioFiles[index]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _showColorPickerDialog(index);
                },
                icon: Icon(Icons.color_lens),
              ),
              Text("Note ${index + 1}"),
              IconButton(
                onPressed: () {
                  _showAudioPickerDialog(index);
                },
                icon: Icon(Icons.audiotrack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setNumberOfButtons(int number) {
    setState(() {
      numberOfButtons = number;
    });
  }

  void _showColorPickerDialog(int index) {
    Color selectedColor = buttonColors[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a color for the button"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  buttonColors[index] = selectedColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAudioPickerDialog(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );

    if (result != null) {
      PlatformFile file = result.files.single;
      if (file.path != null) {
        setState(() {
          audioFiles[index] = file.path!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Xylophone App"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/background_image.jpg", // Replace with your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              children: [
                DropdownButton<int>(
                  value: numberOfButtons,
                  items: List<DropdownMenuItem<int>>.generate(
                    7,
                        (int value) {
                      return DropdownMenuItem<int>(
                        value: value + 1,
                        child: Text((value + 1).toString()),
                      );
                    },
                  ),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setNumberOfButtons(newValue);
                    }
                  },
                ),
                for (var i = 0; i < numberOfButtons; i++) buildButton(i),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
