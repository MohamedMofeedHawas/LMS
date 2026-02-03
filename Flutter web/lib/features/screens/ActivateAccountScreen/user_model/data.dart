class ActivateUserModel {
  final String message;
  final String expiresIn;
  final ActivateUser user;

  ActivateUserModel({
    required this.message,
    required this.expiresIn,
    required this.user,
  });

  factory ActivateUserModel.fromJson(Map<String, dynamic> json) {
    return ActivateUserModel(
      message: json['message'],
      expiresIn: json['expiresIn'],
      user: ActivateUser.fromJson(json['user']),
    );
  }
}

class ActivateUser {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final String? nationalId;
  final String? accountStatus;
  final String? profileImageUrl;

  ActivateUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.nationalId,
    this.accountStatus,
    this.profileImageUrl,
  });

  factory ActivateUser.fromJson(Map<String, dynamic> json) {
    return ActivateUser(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
      nationalId: json['nationalId'],
      accountStatus: json['accountStatus'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
