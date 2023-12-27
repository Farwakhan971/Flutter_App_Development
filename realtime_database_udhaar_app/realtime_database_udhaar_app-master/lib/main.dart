import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Customer_list_Screen.dart';
import 'SignInScreen.dart';
import 'SignUpScreen.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBjAkNgN0exrtFxCs7xX4dTiguWr5HwO44',
        appId: '1:540835148923:android:fa34667ec93e319c92dede',
        messagingSenderId: '540835148923',
        projectId: 'realtime-database-dedef'
    ),
  )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const Color antiqueRuby = Color(0xFF841C6E);
  final Map<dynamic, dynamic> customerData;

   MyApp({super.key, required this.customerData}); // A

  static MaterialColor createMaterialColor(Color color) {
    List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int strength in strengths) {
      swatch[strength] = Color.fromRGBO(r, g, b, strength / 700);
    }

    return MaterialColor(color.value, swatch);
  }

  final MaterialColor antiqueRubySwatch = createMaterialColor(antiqueRuby);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Udhar Book',
      theme: ThemeData(
        primarySwatch: antiqueRubySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthenticationWrapper(),
      routes: {
        '/customerList': (context) => CustomerListScreen(),
        '/signIn': (context) => SignInScreen(),
        '/signUp': (context) => SignUpScreen(),
      },
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // User is signed in, load the list of customers
          return CustomerListScreen();
        } else {
          // User is not signed in, show the sign-in screen
          return SignInScreen(
            onSignIn: () {
              Navigator.pushReplacementNamed(context, '/customerList');
            },
          );
        }
      },
    );
  }
}





