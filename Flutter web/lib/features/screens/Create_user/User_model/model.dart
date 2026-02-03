class CreateUserModel {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final String nationalId;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? city;
  final String? profileImageUrl;
  final String accountStatus;
  final bool emailConfirmed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final AcademicInfo? academicInfo;

  CreateUserModel({
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
    required this.emailConfirmed,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.academicInfo,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
      nationalId: json['nationalId'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      city: json['city'],
      profileImageUrl: json['profileImageUrl'],
      accountStatus: json['accountStatus'] ?? '',
      emailConfirmed: json['emailConfirmed'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      academicInfo: json['academicInfo'] != null
          ? AcademicInfo.fromJson(json['academicInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'role': role,
    'nationalId': nationalId,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'city': city,
    'profileImageUrl': profileImageUrl,
    'accountStatus': accountStatus,
    'emailConfirmed': emailConfirmed,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'lastLoginAt': lastLoginAt?.toIso8601String(),
    'academicInfo': academicInfo?.toJson(),
  };
}


class AcademicInfo {
  final Department? department;
  final Year? year;
  final int? admissionYear;
  final Squadron? squadron;

  AcademicInfo({
    this.department,
    this.year,
    this.admissionYear,
    this.squadron,
  });

  factory AcademicInfo.fromJson(Map<String, dynamic> json) {
    return AcademicInfo(
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      year: json['year'] != null ? Year.fromJson(json['year']) : null,
      admissionYear: json['admissionYear'],
      squadron: json['squadron'] != null
          ? Squadron.fromJson(json['squadron'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'department': department?.toJson(),
    'year': year?.toJson(),
    'admissionYear': admissionYear,
    'squadron': squadron?.toJson(),
  };
}

class Department {
  final int? id;
  final String? name;

  Department({this.id, this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class Year {
  final int? id;
  final String? name;

  Year({this.id, this.name});

  factory Year.fromJson(Map<String, dynamic> json) {
    return Year(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class Squadron {
  final int? id;
  final String? name;

  Squadron({this.id, this.name});

  factory Squadron.fromJson(Map<String, dynamic> json) {
    return Squadron(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
