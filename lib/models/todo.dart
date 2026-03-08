import 'package:flutter/material.dart';
class Todo {
  final String id;
  String title;
  String description;
  TodoStatus status;
  final String createdBy;
  String updatedBy;
  final DateTime createdAt;
  DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: TodoStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
        orElse: () => TodoStatus.pending,
      ),
      createdBy: json['created_by'] ?? 'Unknown',
      updatedBy: json['updated_by'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Todo copyWith({
    String? title,
    String? description,
    TodoStatus? status,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum TodoStatus {
  pending,
  in_progress,
  completed;

  String get displayName {
    switch (this) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.in_progress:
        return 'In Progress';
      case TodoStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TodoStatus.pending:
        return Colors.orange;
      case TodoStatus.in_progress:
        return Colors.blue;
      case TodoStatus.completed:
        return Colors.green;
    }
  }
}
