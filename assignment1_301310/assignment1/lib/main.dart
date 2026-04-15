import 'package:assignment1/splash_screen.dart';
import 'package:flutter/material.dart';

//student budget apps
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wallet',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 33, 47, 243),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 33, 47, 243),
        ),
        brightness: Brightness.light,
      ),
      home: SplashScreen(),
    );
  }
}
