class ItemModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final String createdAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: int.tryParse(json["item_id"].toString()) ?? 0,
      name: (json["item_name"] ?? "").toString(),
      category: (json["item_category"] ?? "").toString(),
      description: (json["item_description"] ?? "").toString(),
      imageUrl: (json["item_imagepath"] ?? "").toString(),
      createdAt: (json["created_at"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_id": id,
      "item_name": name,
      "item_category": category,
      "item_description": description,
      "item_imagepath": imageUrl,
      "created_at": createdAt,
    };
  }
}
