import 'dart:convert';

import 'package:finalassignment/models/report_model.dart';
import 'package:finalassignment/models/user_model.dart';
import 'package:finalassignment/service/api_service.dart';
import 'package:finalassignment/screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  UserModel? user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  String selectedReportType = 'All';
  final List<String> reportTypes = ['All', 'Lost', 'Found'];
  String statusMessage = "";

  List<ReportModel> reports = [];

  Color getTypeColor(String type) {
    if (type == 'Lost') {
      return const Color.fromRGBO(244, 67, 54, 1);
    } else {
      return const Color.fromARGB(255, 89, 183, 94);
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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user?.name ?? '';
    emailController.text = widget.user?.email ?? '';
    phoneController.text = widget.user?.phone ?? '';
    loadProfile();
    loadMyReport();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${ApiService.baseUrl}/api/get_profile.php?user_id=${widget.user?.id}',
        ),
      );

      if (response.statusCode == 200) {
        final resarray = jsonDecode(response.body);

        if (resarray['status'] == 'success') {
          UserModel user = UserModel.fromJson(resarray['data'][0]);

          setState(() {
            widget.user = user;
            nameController.text = user.name;
            emailController.text = user.email;
            phoneController.text = user.phone;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resarray['message'] ?? 'Failed to load profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Load profile error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMyReport() async {
    setState(() {
      isLoading = true;
      statusMessage = "Loading Report";
    });

    try {
      String url =
          '${ApiService.baseUrl}/api/get_my_report.php?user_id=${widget.user?.id}';

      if (selectedReportType != 'All') {
        url += '&report_type=$selectedReportType';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dataReport = jsonDecode(response.body);

        if (dataReport['status'] == 'success') {
          final List reportList = dataReport['reports'] ?? [];

          setState(() {
            reports = reportList
                .map((report) => ReportModel.fromJson(report))
                .toList();
            isLoading = false;

            statusMessage = reports.isEmpty ? "No Report Found" : "";
          });
        } else {
          setState(() {
            reports = [];
            statusMessage = dataReport['message'] ?? "Failed to load reports";
          });
        }
      } else {
        setState(() {
          reports = [];
          statusMessage = "Failed to load reports";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Load report error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateProfile() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/api/update_profile.php'),
      body: {
        'user_id': widget.user!.id.toString(),
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      },
    );

    if (response.statusCode == 200) {
      var resarray = jsonDecode(response.body);

      if (resarray['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resarray['message'] ?? 'Profile updated successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        await loadProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resarray['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> deleteMyReport(ReportModel report) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/api/delete_my_report.php'),
      body: {
        'report_id': report.id.toString(),
        'user_id': widget.user!.id.toString(),
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']), backgroundColor: Colors.green),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
      );
    }
  }

  void showDeleteDialog(ReportModel report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteMyReport(report);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 150, 236, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showEditDialog();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: phoneController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 32),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedReportType,

                    items: reportTypes.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReportType = value!;
                      });
                      loadMyReport();
                    },
                  ),
                ),
              ],
            ),

            //card for report
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
                        builder: (context) =>
                            DetailScreen(report: report, user: widget.user),
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
                          Column(
                            children: [
                              const Icon(Icons.arrow_forward_ios, size: 16),
                              const SizedBox(height: 18),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDeleteDialog(report);
                                },
                              ),
                            ],
                          ),
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
    );
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                confirmSave();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void confirmSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Save"),
        content: const Text("Are you sure you want to save the changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              updateProfile();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
