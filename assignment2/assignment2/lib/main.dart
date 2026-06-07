import 'package:assignment2/screen/homescreen.dart';
//import 'package:assignment2/screen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 105, 142, 75),
          foregroundColor: Color.fromRGBO(188, 234, 197, 1),
        ),
      ),
      home: const Homescreen(),
    );
  }
}
