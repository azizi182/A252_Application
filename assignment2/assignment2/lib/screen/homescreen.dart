import 'dart:convert';
import 'dart:developer';

import 'package:assignment2/models/home_model.dart';
import 'package:assignment2/screen/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isLoading = true;
  List<HomeModel> homestays = [];
  String statusMessage = "";

  late double screenWidth, screenHeight;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHomestay();
  }

  Future<void> loadHomestay({String keyword = ""}) async {
    String url = "";

    setState(() {
      isLoading = true;
      statusMessage = "Loading homestays...";
    });

    try {
      url = "http://slum78.myddns.me/homestay2u/api/homestays";

      if (keyword.isNotEmpty) {
        url =
            "http://slum78.myddns.me/homestay2u/api/homestays?search=$keyword&limit=20";
      }

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        log('Load Data Response: $data');

        final loadedData = (data['data'] as List)
            .map((e) => HomeModel.fromJson(e))
            .toList();

        setState(() {
          homestays = loadedData;
          isLoading = false;
          statusMessage = "";

          if (homestays.isEmpty) {
            statusMessage = "No homestays found";
          }
        });
      } else {
        setState(() {
          isLoading = false;
          homestays = [];
          statusMessage = "Failed to load homestays (urlproblem)";
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Load error: $e')));
      print('Load error: $e');

      setState(() {
        isLoading = false;
        homestays = [];
        statusMessage = "Failed to load homestays";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 105, 142, 75),
        foregroundColor: Color.fromARGB(255, 246, 246, 246),
        title: Text(
          "JomStay",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            // Search Bar
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search homestay, state, district...",
                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    loadHomestay(keyword: _searchController.text);
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (value) {
                loadHomestay(keyword: value);
              },
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : statusMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),

                          SizedBox(height: 12),

                          Text(
                            statusMessage,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await loadHomestay(keyword: _searchController.text);
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: homestays.length,
                      itemBuilder: (context, index) {
                        return homestayCard(homestays[index], context);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget homestayCard(HomeModel homestay, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detailscreen(homestay: homestay),
        ),
      );
    },
    child: Card(
      color: Color.fromARGB(255, 207, 230, 212),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              homestay.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 110,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homestay.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${homestay.town}, ${homestay.district}, ${homestay.state}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "From RM${homestay.priceMin}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 35, 75, 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
