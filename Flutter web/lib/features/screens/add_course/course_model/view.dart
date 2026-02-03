class CreateCourseModel {
  final int id;
  final String title;
  final String description;
  final int departmentId;
  final String departmentName;
  final int yearId;
  final String yearName;
  final int creditHours;
  final int enrolledStudentsCount;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.departmentId,
    required this.departmentName,
    required this.yearId,
    required this.yearName,
    required this.creditHours,
    required this.enrolledStudentsCount,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateCourseModel.fromJson(Map<String, dynamic> json) {
    return CreateCourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      yearId: json['yearId'],
      yearName: json['yearName'],
      creditHours: json['creditHours'],
      enrolledStudentsCount: json['enrolledStudentsCount'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'yearId': yearId,
      'yearName': yearName,
      'creditHours': creditHours,
      'enrolledStudentsCount': enrolledStudentsCount,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
