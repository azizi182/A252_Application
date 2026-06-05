import 'dart:convert';
import 'dart:developer';

import 'package:assignment2/models/home_model.dart';
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
    });

    try {
      url = "http://slum78.myddns.me/homestay2u/api/homestays";

      if (keyword.isNotEmpty) {
        url =
            "http://slum78.myddns.me/homestay2u/api/homestays?search=$keyword&limit=20";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        log('Load Data Response: $data');

        final loadedData = (data['data'] as List)
            .map((e) => HomeModel.fromJson(e))
            .toList();

        setState(() {
          homestays = loadedData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

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
                ? const Center(child: CircularProgressIndicator())
                : homestays.isEmpty
                ? const Center(
                    child: Text(
                      "No homestays found",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await loadHomestay(keyword: _searchController.text);
                    },
                    child: ListView.builder(
                      itemCount: homestays.length,
                      itemBuilder: (context, index) {
                        return homestayCard(homestays[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget homestayCard(HomeModel homestay) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

    child: Padding(
      padding: const EdgeInsets.all(15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            homestay.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text("📍 ${homestay.district}, ${homestay.state}"),

          const SizedBox(height: 8),

          Text(
            "💰 RM ${homestay.priceMin}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            homestay.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
