class UserStatusModel {
  final bool exists;
  final bool isActivated;

  UserStatusModel({
    required this.exists,
    required this.isActivated,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      exists: json['exists'] ?? false,
      isActivated: json['isActivated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exists': exists,
      'isActivated': isActivated,
    };
  }
}
