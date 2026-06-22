class ReportModel {
  final int id;
  final String title;
  final String type;
  final String location;
  final String date;
  final String status;

  final int itemId;
  final String itemName;
  final String itemCategory;
  final String itemDescription;
  final String itemImagePath;

  final int userId;
  final String userName;
  final String userEmail;
  final String userPhone;

  final int? receiverId;
  final String receiverName;
  final String receiverEmail;
  final String receiverPhone;

  ReportModel({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.status,

    required this.itemId,
    required this.itemName,
    required this.itemCategory,
    required this.itemDescription,
    required this.itemImagePath,

    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,

    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverPhone,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: int.tryParse(json["report_id"].toString()) ?? 0,
      title: (json["report_title"] ?? "").toString(),
      type: (json["report_type"] ?? "").toString(),
      location: (json["report_location"] ?? "").toString(),
      date: (json["report_date"] ?? "").toString(),
      status: (json["report_status"] ?? "").toString(),

      itemId: int.parse(json['item_id'].toString()),
      itemName: json['item_name'] ?? '',
      itemCategory: json['item_category'] ?? '',
      itemDescription: json['item_description'] ?? '',
      itemImagePath: json['item_imagepath'] ?? '',

      userId: int.parse(json['user_id'].toString()),
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      userPhone: json['user_phone'] ?? '',

      receiverId: json['receiver_id'] == null
          ? null
          : int.tryParse(json['receiver_id'].toString()),
      receiverName: json['receiver_name'] ?? '',
      receiverEmail: json['receiver_email'] ?? '',
      receiverPhone: json['receiver_phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "report_id": id,
      "report_title": title,
      "report_type": type,
      "report_location": location,
      "report_date": date,
      "report_status": status,

      "item_id": itemId,
      "item_name": itemName,
      "item_category": itemCategory,
      "item_description": itemDescription,
      "item_imagepath": itemImagePath,

      "user_id": userId,
      "user_name": userName,
      "user_email": userEmail,
      "user_phone": userPhone,

      "receiver_id": receiverId,
      "receiver_name": receiverName,
      "receiver_email": receiverEmail,
      "receiver_phone": receiverPhone,
    };
  }
}
