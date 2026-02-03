class UserLiteModel {
  final int id;
  final String fullName;
  final String role;
  final String? imageUrl;

  UserLiteModel({
    required this.id,
    required this.fullName,
    required this.role,
    this.imageUrl,
  });

  factory UserLiteModel.fromJson(Map<String, dynamic> json) {
    return UserLiteModel(
      id: json['id'],
      fullName: json['fullName'],
      role: json['role'],
      imageUrl: json['profileImageUrl'],
    );
  }
}