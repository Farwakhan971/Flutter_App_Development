import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:udhaar_app_withfirebase_andsqlflite/add_customer_screen.dart';
import 'package:udhaar_app_withfirebase_andsqlflite/app_color.dart';
import 'package:udhaar_app_withfirebase_andsqlflite/customer_list_screen.dart';
import 'dart:io';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid? await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDt_yBqNLn5Pf-YAF7zZ39PdN7GHAhYVYw",
        appId: "1:931503149684:android:8fd5963ba0e992ee8cf721",
        messagingSenderId: "931503149684",
        projectId: "fir-apps-3ff1b"),
  )
  : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final MaterialColor customcolorswatch =  ColorUtils.createMaterialColor(ColorUtils.customcolor);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       primarySwatch: customcolorswatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: customerlistscreen(),
    );
  }
}

