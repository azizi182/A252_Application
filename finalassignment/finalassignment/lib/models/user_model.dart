class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json["user_id"].toString()) ?? 0,
      name: (json["user_name"] ?? "").toString(),
      email: (json["user_email"] ?? "").toString(),
      phone: (json["user_phone"] ?? "").toString(),
      password: (json["user_password"] ?? "").toString(),
      createdAt: (json["created_at"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": id,
      "user_name": name,
      "user_email": email,
      "user_phone": phone,
      "user_password": password,
      "created_at": createdAt,
    };
  }
}
