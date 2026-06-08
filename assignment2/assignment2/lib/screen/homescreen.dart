import 'dart:convert';
import 'dart:developer';

import 'package:assignment2/models/home_model.dart';
import 'package:assignment2/screen/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isLoading = true;
  List<HomeModel> homestays = [];
  List<String> saveSearchHistory = [];
  String statusMessage = "";

  final TextEditingController _searchController = TextEditingController();

  String? selectedState;
  String? selectedDistrict;

  List<String> states = [
    "Kedah",
    "Perlis",
    "Penang",
    "Perak",
    "Selangor",
    "Johor",
    "Kelantan",
    "Terengganu",
    "Pahang",
    "Negeri Sembilan",
    "Melaka",
    "Sabah",
    "Sarawak",
  ];

  Map<String, List<String>> districts = {
    "Kedah": ["Alor Setar", "Kubang Pasu", "Langkawi"],
    "Perlis": ["Kangar", "Arau"],
    "Penang": ["Timur Laut", "Barat Daya"],
    "Perak": ["Kinta", "Manjung"],
    "Selangor": ["Petaling", "Klang"],
    "Johor": ["Johor Bahru", "Muar"],
    "Kelantan": ["Kota Bharu", "Rantau Panjang"],
    "Terengganu": ["Kuala Terengganu", "Kemaman"],
    "Pahang": ["Kuantan", "Cameron Highlands"],
    "Negeri Sembilan": ["Seremban", "Port Dickson"],
    "Melaka": ["Melaka Tengah", "Alor Gajah"],
    "Sabah": ["Kota Kinabalu", "Sandakan"],
    "Sarawak": ["Kuching", "Miri"],
  };

  @override
  void initState() {
    super.initState();
    loadHomestay();
    loadSearchHistory();
  }

  Future<void> saveSearch(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    List<String> history = prefs.getStringList('search_history') ?? [];

    history.remove(keyword);

    history.insert(0, keyword);

    if (history.length > 3) {
      history = history.sublist(0, 3);
    }

    await prefs.setStringList('search_history', history);

    setState(() {
      saveSearchHistory = history;
    });
  }

  Future<void> loadHomestay({
    String keyword = "",
    String? state,
    String? district,
  }) async {
    String url = "";

    setState(() {
      isLoading = true;
      statusMessage = "Loading homestays...";
    });

    try {
      url = "http://slum78.myddns.me/homestay2u/api/homestays";

      List<String> params = [];

      if (keyword.isNotEmpty) {
        params.add("search=$keyword");
      }

      if (state != null && state.isNotEmpty) {
        params.add("state=$state");
      }

      if (district != null && district.isNotEmpty) {
        params.add("district=$district");
      }

      if (params.isNotEmpty) {
        url += "?${params.join("&")}";
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

  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      saveSearchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search homestay...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 105, 142, 75),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 105, 142, 75),
                    ),
                    onPressed: () {
                      loadHomestay(
                        keyword: _searchController.text,
                        state: selectedState,
                        district: selectedDistrict,
                      );
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Search History
          if (saveSearchHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Searches",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children: saveSearchHistory.map((item) {
                      return ActionChip(
                        avatar: const Icon(Icons.history, size: 18),
                        label: Text(item),
                        onPressed: () {
                          _searchController.text = item;

                          loadHomestay(
                            keyword: item,
                            state: selectedState,
                            district: selectedDistrict,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          //dropdown
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromRGBO(238, 255, 241, 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedState,
                  decoration: InputDecoration(
                    labelText: "State",

                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Color.fromARGB(255, 105, 142, 75),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: states.map((state) {
                    return DropdownMenuItem(value: state, child: Text(state));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                      selectedDistrict = null;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // District Dropdown
                DropdownButtonFormField<String>(
                  value: selectedDistrict,

                  decoration: InputDecoration(
                    labelText: "District",

                    prefixIcon: Icon(
                      Icons.map,
                      color: Color.fromARGB(255, 105, 142, 75),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: selectedState == null
                      ? []
                      : districts[selectedState]!
                            .map(
                              (district) => DropdownMenuItem(
                                value: district,
                                child: Text(district),
                              ),
                            )
                            .toList(),
                  onChanged: selectedState == null
                      ? null
                      : (value) {
                          setState(() {
                            selectedDistrict = value;
                          });
                        },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    //clear button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            selectedState = null;
                            selectedDistrict = null;
                          });

                          loadHomestay();
                        },

                        icon: const Icon(Icons.refresh),
                        label: const Text("Clear"),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // search button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          saveSearch(_searchController.text);

                          loadHomestay(
                            keyword: _searchController.text,
                            state: selectedState,
                            district: selectedDistrict,
                          );
                        },
                        icon: const Icon(Icons.search),
                        label: const Text("Search"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 105, 142, 75),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),

          // Homestay List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${homestays.length} Homestays Found",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  if (selectedState != null || selectedDistrict != null)
                    Chip(label: Text("Filtered")),
                ],
              ),
            ),
          ),

          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
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
                      await loadHomestay(
                        keyword: _searchController.text,
                        state: selectedState,
                        district: selectedDistrict,
                      );
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
