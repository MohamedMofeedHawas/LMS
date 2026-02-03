class StudentProfileModel {
  final String message;
  final bool success;
  final User user;

  StudentProfileModel({
    required this.message,
    required this.success,
    required this.user,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      StudentProfileModel(
        message: json['message'] ?? '',
        success: json['success'] ?? false,
        user: User.fromJson(json['user'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'user': user.toJson(),
  };
}

class User {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final String nationalId;
  final String? dateOfBirth;
  final String? gender;
  final String? city;
  final String? profileImageUrl;
  final String accountStatus;
  final String createdAt;
  final String lastLoginAt;
  final AcademicInfo academicInfo;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.nationalId,
    this.dateOfBirth,
    this.gender,
    this.city,
    this.profileImageUrl,
    required this.accountStatus,
    required this.createdAt,
    required this.lastLoginAt,
    required this.academicInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? 0,
    email: json['email'] ?? '',
    fullName: json['fullName'] ?? '',
    role: json['role'] ?? '',
    nationalId: json['nationalId'] ?? '',
    dateOfBirth: json['dateOfBirth'],
    gender: json['gender'],
    city: json['city'],
    profileImageUrl: json['profileImageUrl'],
    accountStatus: json['accountStatus'] ?? '',
    createdAt: json['createdAt'] ?? '',
    lastLoginAt: json['lastLoginAt'] ?? '',
    academicInfo:
    AcademicInfo.fromJson(json['academicInfo'] ?? <String, dynamic>{}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'role': role,
    'nationalId': nationalId,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'city': city,
    'profileImageUrl': profileImageUrl,
    'accountStatus': accountStatus,
    'createdAt': createdAt,
    'lastLoginAt': lastLoginAt,
    'academicInfo': academicInfo.toJson(),
  };
}

class AcademicInfo {
  final Department department;
  final Year year;
  final Squadron squadron;
  final int admissionYear;

  AcademicInfo({
    required this.department,
    required this.year,
    required this.squadron,
    required this.admissionYear,
  });

  factory AcademicInfo.fromJson(Map<String, dynamic> json) => AcademicInfo(
    department: Department.fromJson(json['department'] ?? {}),
    year: Year.fromJson(json['year'] ?? {}),
    squadron: Squadron.fromJson(json['squadron'] ?? {}),
    admissionYear: json['admissionYear'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'department': department.toJson(),
    'year': year.toJson(),
    'squadron': squadron.toJson(),
    'admissionYear': admissionYear,
  };
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class Year {
  final int id;
  final String name;

  Year({required this.id, required this.name});

  factory Year.fromJson(Map<String, dynamic> json) => Year(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class Squadron {
  final int id;
  final String name;

  Squadron({required this.id, required this.name});

  factory Squadron.fromJson(Map<String, dynamic> json) => Squadron(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
