class HomeModel {
  final int id;
  final String name;
  final String state;
  final String district;
  final String town;
  final String address;
  final String description;
  final List<String> activities;
  final List<String> amenities;
  final int priceMin;
  final String? contactName;
  final String? contactPhone;
  final String? website;
  final double latitude;
  final double longitude;
  final String source;
  final String createdAt;
  final String imageUrl;

  HomeModel({
    required this.id,
    required this.name,
    required this.state,
    required this.district,
    required this.town,
    required this.address,
    required this.description,
    required this.activities,
    required this.amenities,
    required this.priceMin,
    this.contactName,
    this.contactPhone,
    this.website,
    required this.latitude,
    required this.longitude,
    required this.source,
    required this.createdAt,
    required this.imageUrl,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      town: json['town'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      priceMin: json['price_min'] ?? 0,
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      website: json['website'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      source: json['source'] ?? '',
      createdAt: json['created_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'district': district,
      'town': town,
      'address': address,
      'description': description,
      'activities': activities,
      'amenities': amenities,
      'price_min': priceMin,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'source': source,
      'created_at': createdAt,
      'image_url': imageUrl,
    };
  }
}
