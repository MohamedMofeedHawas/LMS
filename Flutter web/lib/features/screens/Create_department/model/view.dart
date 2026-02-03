import 'package:intl/intl.dart';

class Department {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int headId;
  final String headName;
  final String createdAt;
  final String updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.headId,
    required this.headName,
    required this.createdAt,
    required this.updatedAt,
  });

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    imageUrl: json['imageUrl'],
    headId: json['headId'] ?? 0,
    headName: json['headName'] ?? '',
    createdAt: formatDate(json['createdAt']),
    updatedAt: formatDate(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'headId': headId,
    'headName': headName,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
