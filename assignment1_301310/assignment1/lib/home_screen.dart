import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 900 ? 48.0 : 20.0;
    double balance;

    TextEditingController num1 = TextEditingController();
    TextEditingController num2 = TextEditingController();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),

      appBar: AppBar(
        title: Text('My Wallet Home', style: TextStyle(fontSize: 26)),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Balance: ", style: TextStyle(fontSize: 30)),
                  SizedBox(width: 20),
                  Text(
                    "\$1000",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                        balance = double.parse(num1.text);
                      });
                      // Handle transaction button press
                    },
                    child: Text("Transaction", style: TextStyle(fontSize: 20)),
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
            ],
          ),
        ),
      ),
    );
  }
}
