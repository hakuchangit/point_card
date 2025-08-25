// ポイントカードのクラス
import 'package:flutter/foundation.dart';
import '../widget/reward_list_editor.dart';

@immutable
class PointCard {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt; // ← create_date をアプリ側では camelCase
  final int pointNum; // ← point_num を camelCase

  const PointCard({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.pointNum,
  }) : assert(pointNum > 0, 'pointNum must be > 0');
  PointCard copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    int? pointNum,
  }) {
    return PointCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      pointNum: pointNum ?? this.pointNum,
    );
  }

  @override
  String toString() {
    return 'PointCard(id: $id, title: $title, description: $description, '
        'createdAt: $createdAt, pointNum: $pointNum)';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'pointNum': pointNum,
  };
  factory PointCard.fromJson(Map<String, dynamic> json) {
    try {
      return PointCard(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        pointNum: (json['pointNum'] as num).toInt(),
      );
    } catch (e, st) {
      PointCard(
        id: '',
        title: '',
        description: '',
        createdAt: DateTime.now(),
        pointNum: 0,
      );
      rethrow;
    }
  }
}
