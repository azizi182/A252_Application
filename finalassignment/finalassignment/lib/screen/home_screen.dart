import 'dart:convert';

import 'package:finalassignment/models/report_model.dart';
import 'package:finalassignment/models/user_model.dart';
import 'package:finalassignment/screen/detail_screen.dart';
import 'package:finalassignment/screen/report_screen.dart';
import 'package:finalassignment/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final UserModel? user;
  HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';
  String selectedReportType = 'All';
  bool isLoading = true;
  String statusMessage = "";

  List<ReportModel> reports = [];

  final List<String> categories = [
    'All',
    'Wallet',
    'Matric Card',
    'Keys',
    'Electronics',
    'Books',
    'Bag',
    'Others',
  ];

  final List<String> reportTypes = ['All', 'Lost', 'Found'];

  Color getTypeColor(String type) {
    if (type == 'Lost') {
      return Color.fromRGBO(244, 67, 54, 1);
    } else {
      return Color.fromARGB(255, 89, 183, 94);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Wallet':
        return Icons.account_balance_wallet;
      case 'Matric Card':
        return Icons.badge;
      case 'Keys':
        return Icons.vpn_key;
      case 'Electronics':
        return Icons.devices;
      case 'Books':
        return Icons.menu_book;
      case 'Bag':
        return Icons.backpack;
      default:
        return Icons.inventory_2;
    }
  }

  Future<void> loadReport({
    String keyword = "",
    String? categories,
    String? reportTypes,
  }) async {
    setState(() {
      isLoading = true;
      statusMessage = "Loading Report";
    });

    try {
      String url = "${ApiService.baseUrl}/api/get_report.php";
      List<String> params = [];

      if (keyword.isNotEmpty) {
        params.add("search=$keyword");
      }

      if (categories != null && categories.isNotEmpty && categories != 'All') {
        params.add("category=$categories");
      }

      if (reportTypes != null &&
          reportTypes.isNotEmpty &&
          reportTypes != 'All') {
        params.add("report_type=$reportTypes");
      }

      if (params.isNotEmpty) {
        url += "?${params.join("&")}";
      }

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dataReport = jsonDecode(response.body);
        if (dataReport['success'] == true) {
          final List reportList = dataReport['reports'];

          setState(() {
            isLoading = false;
            statusMessage = "";
            reports = reportList
                .map<ReportModel>((item) => ReportModel.fromJson(item))
                .toList();

            if (reports.isEmpty) {
              statusMessage = "No report found";
            }
          });
        } else {
          setState(() {
            isLoading = false;
            reports = [];
            statusMessage = dataReport['message'] ?? "Failed to load reports";
          });
        }
      } else {
        setState(() {
          isLoading = false;
          reports = [];
          statusMessage = "Failed to load reports (not 200)";
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
        reports = [];
        statusMessage = "Failed to load reports (error)";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 252, 252),

      appBar: AppBar(
        title: const Text(
          'LostLink',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 150, 236, 1),
      ),

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 81, 215, 235),
                    Color.fromARGB(255, 23, 48, 172),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${widget.user!.name}',

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    'Find or report lost items around campus.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search item name or keyword',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 81, 215, 235),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // category
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedCategory,

                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  // report type
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedReportType,
                      items: reportTypes.map((reportType) {
                        return DropdownMenuItem<String>(
                          value: reportType,
                          child: Text(reportType),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReportType = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 12),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 235, 81, 81),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        selectedCategory = 'All';
                        selectedReportType = 'All';
                      });

                      loadReport();
                    },
                    child: Text('Clear'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 81, 215, 235),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      loadReport(
                        keyword: searchController.text,
                        categories: selectedCategory,
                        reportTypes: selectedReportType,
                      );
                    },
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 1),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    statusMessage,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                itemCount: reports.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final report = reports[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(report: report),
                        ),
                      );
                    },

                    child: Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),

                              child: Image.network(
                                '${ApiService.baseUrl}/api/${report.itemImagePath}',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      getCategoryIcon(report.itemCategory),
                                      size: 40,
                                      color: const Color.fromRGBO(
                                        92,
                                        150,
                                        236,
                                        1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title
                                  Text(
                                    report.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    report.itemName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  // type
                                  Text(
                                    '${report.type} • ${report.itemCategory}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: getTypeColor(report.type),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  Text(
                                    report.location,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    report.status,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 90),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(user: widget.user),
            ),
          );

          if (result == true) {
            loadReport();
          }
        },
        backgroundColor: const Color.fromARGB(255, 23, 48, 172),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
