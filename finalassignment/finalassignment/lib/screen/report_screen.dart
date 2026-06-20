import 'dart:convert';
import 'dart:io';

import 'package:finalassignment/models/user_model.dart';
import 'package:finalassignment/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatefulWidget {
  final UserModel? user;

  const ReportScreen({super.key, this.user});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController reportTitleController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedReportType = 'Lost';
  String selectedCategory = 'Wallet';
  File? image;

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

  bool isLoading = false;

  @override
  void dispose() {
    reportTitleController.dispose();
    itemNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 252, 252),
      appBar: AppBar(
        title: const Text(
          'Add Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 150, 236, 1),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              GestureDetector(
                onTap: pickimagedialog,
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: image == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Color.fromRGBO(92, 150, 236, 1),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to upload image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: reportTitleController,
                decoration: InputDecoration(
                  labelText: 'Report Title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Decription',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: selectedReportType,
                    items: reportTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReportType = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
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
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  showsubmitReport();
                },
                child: const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showsubmitReport() {
    if (reportTitleController.text.isEmpty ||
        itemNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Report'),
          content: const Text('Are you sure you want to submit this report?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.pop(context);
                submitReport();
              },
            ),
          ],
        );
      },
    );
  }

  void submitReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      String base64Image = base64Encode(image!.readAsBytesSync());

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/submit_report.php'),
        body: {
          'user_id': widget.user?.id.toString(),
          'report_title': reportTitleController.text,
          'report_type': selectedReportType,
          'report_location': locationController.text,
          'report_date': dateController.text,
          'report_status': 'Unclaimed',

          'item_name': itemNameController.text,
          'item_category': selectedCategory,
          'item_description': descriptionController.text,

          'item_image': jsonEncode(base64Image),
        },
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Failed to submit report'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submit failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });
  }

  void pickimagedialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Image'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    image = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
