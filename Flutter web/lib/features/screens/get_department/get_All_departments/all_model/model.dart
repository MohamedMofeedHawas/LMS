class GetAllDepartmentModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int headId;
  final String headName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DepartmentYearModel> years;

  GetAllDepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.headId,
    required this.headName,
    required this.createdAt,
    required this.updatedAt,
    required this.years,
  });

  factory GetAllDepartmentModel.fromJson(Map<String, dynamic> json) {
    return GetAllDepartmentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      headId: json['headId'],
      headName: json['headName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      years: (json['years'] as List<dynamic>)
          .map((e) => DepartmentYearModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'headId': headId,
      'headName': headName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'years': years.map((e) => e.toJson()).toList(),
    };
  }
}
class DepartmentYearModel {
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

  DepartmentYearModel({
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

  factory DepartmentYearModel.fromJson(Map<String, dynamic> json) {
    return DepartmentYearModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalCourses: json['totalCourses'],
      totalHours: json['totalHours'],
      departmentName: json['departmentName'],
      createdBy: json['createdBy'] ?? '',
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
