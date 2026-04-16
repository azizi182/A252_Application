import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();

  double number1 = 0.0;
  double number2 = 0.0;
  double balance = 0.0;

  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 900 ? 48.0 : 20.0;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),

      appBar: AppBar(
        title: Text('My Wallet Home', style: TextStyle(fontSize: 26)),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image/logowallet.png", width: 150),

              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Balance: RM ", style: TextStyle(fontSize: 30)),

                  Text(
                    balance.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 30,
                      color: balance >= 0
                          ? Color.fromARGB(255, 33, 47, 243)
                          : Color.fromARGB(255, 243, 33, 33),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Divider(height: 30, thickness: 2, color: Colors.grey),

              SizedBox(height: 15),

              //textfield for balance
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Deposit amount',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 33, 47, 243)),
                ),
                controller: num1,
              ),

              SizedBox(height: 20),

              //textfield for daily expenses
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Daily expenses',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 243, 33, 33)),
                ),
                controller: num2,
              ),

              SizedBox(height: 20),

              //button transaction
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        number1 = double.tryParse(num1.text) ?? 0.0;
                        number2 = double.tryParse(num2.text) ?? 0.0;
                        balance += number1; // add deposit
                        balance -= number2; // subtract expenses

                        num1.clear();
                        num2.clear();
                      });
                      playTransaction();

                      if (balance < 0) {
                        playNegativeBalance();
                      }
                    },
                    child: Text("Calculate", style: TextStyle(fontSize: 20)),
                  ),

                  SizedBox(width: 20),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        num1.clear();
                        num2.clear();
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 243, 33, 33),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              if (balance < 0)
                Text(
                  "Negative Balance!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 243, 33, 33),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void playTransaction() {
    player1.play(AssetSource('audio/coin.wav'));
  }

  void playNegativeBalance() {
    player2.play(
      AssetSource('audio/reject.wav'),
      position: Duration(milliseconds: 300),
    );
  }
}
