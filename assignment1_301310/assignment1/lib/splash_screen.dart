import 'package:assignment1/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //parent is also run properly.
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      //to avoid error if the widget not display.(avoid crash)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/logowallet.png", width: 150),

            SizedBox(height: 20),

            Text("MyWallet UUM", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
