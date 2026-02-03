import 'package:equatable/equatable.dart';

class SquadronModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SquadronModel({
    required this.id,
    required this.name,
    required this.description,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'studentCount': studentCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  SquadronModel copyWith({
    int? id,
    String? name,
    String? description,
    int? studentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SquadronModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      studentCount: studentCount ?? this.studentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  factory SquadronModel.fromJson(Map<String, dynamic> json) {
    try {
      return SquadronModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        studentCount: json['studentCount'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      print('Error parsing SquadronModel: $e');
      return SquadronModel(
        id: 0,
        name: 'Unknown Squadron',
        description: '',
        studentCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    studentCount,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'SquadronModel(id: $id, name: $name)';
  }
}