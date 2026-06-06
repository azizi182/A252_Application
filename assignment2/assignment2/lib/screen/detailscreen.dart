import 'package:assignment2/models/home_model.dart';
import 'package:flutter/material.dart';

class Detailscreen extends StatefulWidget {
  final HomeModel homestay;
  const Detailscreen({super.key, required this.homestay});

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 250, 246),
      appBar: AppBar(
        title: Text(
          widget.homestay.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.homestay.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  Text(
                    widget.homestay.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 10),

                  // ADDRESS
                  Text(
                    "📍 ${widget.homestay.address}",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  // PRICE
                  Text(
                    "From RM ${widget.homestay.priceMin}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.homestay.description,
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 20),

                  // AMENITIES
                  const Text(
                    "Amenities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Wrap(
                    spacing: 8,
                    children: widget.homestay.amenities.map((item) {
                      return Chip(label: Text(item));
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // ACTIVITIES
                  const Text(
                    "Activities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Wrap(
                    spacing: 8,
                    children: widget.homestay.activities.map((item) {
                      return Chip(label: Text(item));
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // CONTACT
                  const Text(
                    "Contact",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text("👤 ${widget.homestay.contactName}"),
                  Text("📞 ${widget.homestay.contactPhone ?? "Not available"}"),

                  const SizedBox(height: 20),

                  // WEBSITE
                  Text(
                    widget.homestay.website ?? "No website available",
                    style: const TextStyle(color: Colors.blue),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
