import 'package:finalassignment/models/report_model.dart';
import 'package:finalassignment/service/api_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final ReportModel? report;

  const DetailScreen({super.key, this.report});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Color primaryBlue = const Color.fromRGBO(92, 150, 236, 1);
  final Color darkBlue = const Color.fromARGB(255, 23, 48, 172);
  final Color backgroundColor = const Color.fromARGB(255, 236, 252, 252);

  Color getTypeColor(String type) {
    if (type == 'Lost') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  IconData getTypeIcon(String type) {
    if (type == 'Lost') {
      return Icons.search;
    } else {
      return Icons.check_circle;
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    return '${ApiService.baseUrl}/api/$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Report Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryBlue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text('No report data found')),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Report Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image section
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.white,
              child: report.itemImagePath.isNotEmpty
                  ? Image.network(
                      getImageUrl(report.itemImagePath),
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return imageErrorBox();
                      },
                    )
                  : imageErrorBox(),
            ),

            const SizedBox(height: 16),

            // Main title card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lost / Found badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getTypeIcon(report.type),
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          report.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    report.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    report.itemName,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Report Information
            sectionCard(
              title: 'Report Information',
              icon: Icons.assignment,
              children: [
                detailRow(
                  icon: Icons.report,
                  label: 'Report Type',
                  value: report.type,
                  valueColor: getTypeColor(report.type),
                ),
                detailRow(
                  icon: Icons.location_on,
                  label: 'Location',
                  value: report.location,
                ),
                detailRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: report.date,
                ),
                detailRow(
                  icon: Icons.info,
                  label: 'Status',
                  value: report.status,
                  valueColor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Item Information
            sectionCard(
              title: 'Item Information',
              icon: Icons.inventory_2,
              children: [
                detailRow(
                  icon: Icons.label,
                  label: 'Item Name',
                  value: report.itemName,
                ),
                detailRow(
                  icon: Icons.category,
                  label: 'Category',
                  value: report.itemCategory,
                ),
                const SizedBox(height: 8),
                descriptionBox(report.itemDescription),
              ],
            ),

            const SizedBox(height: 16),

            // User Information
            sectionCard(
              title: report.type == 'Lost'
                  ? 'Person Who Lost It'
                  : 'Person Who Found It',
              icon: Icons.person,
              children: [
                detailRow(
                  icon: Icons.person_outline,
                  label: 'Name',
                  value: report.userName,
                ),
                detailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: report.userEmail,
                ),
                detailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: report.userPhone,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact button
            Container(
              width: double.infinity,
              height: 52,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Contact ${report.userName} using email or phone shown above.',
                      ),
                      backgroundColor: primaryBlue,
                    ),
                  );
                },
                icon: const Icon(Icons.contact_phone, color: Colors.white),
                label: const Text(
                  'Contact Reporter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget imageErrorBox() {
    return Container(
      width: double.infinity,
      height: 260,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 60,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 8),
          const Text(
            'No image available',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          ...children,
        ],
      ),
    );
  }

  Widget detailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryBlue, size: 20),

          const SizedBox(width: 10),

          SizedBox(
            width: 95,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget descriptionBox(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 252, 252),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        description.isEmpty ? 'No description provided.' : description,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
