class AcademicYearModel {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int totalCourses;
  final int totalHours;
  final String departmentName;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AcademicYearModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.totalCourses,
    required this.totalHours,
    required this.departmentName,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) {
    return AcademicYearModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalCourses: json['totalCourses'],
      totalHours: json['totalHours'],
      departmentName: json['departmentName'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalCourses': totalCourses,
      'totalHours': totalHours,
      'departmentName': departmentName,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
