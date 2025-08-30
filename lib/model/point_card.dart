// ポイントカードのクラス
import 'package:flutter/foundation.dart';

@immutable
class PointCard {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt; // ← create_date をアプリ側では camelCase
  final int pointNum; // ← point_num を camelCase
  final String rewardTitle;

  const PointCard({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.pointNum,
    required this.rewardTitle,
  }) : assert(pointNum > 0, 'pointNum must be > 0');
  PointCard copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    int? pointNum,
    String? rewardTitle,
  }) {
    return PointCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      pointNum: pointNum ?? this.pointNum,
      rewardTitle: rewardTitle ?? this.rewardTitle,
    );
  }

  @override
  String toString() {
    return 'PointCard(id: $id, title: $title, description: $description, '
        'createdAt: $createdAt, pointNum: $pointNum, rewardTitle: $rewardTitle)';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'pointNum': pointNum,
    'rewardTitle': rewardTitle,
  };
  factory PointCard.fromJson(Map<String, dynamic> json) {
    try {
      return PointCard(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        pointNum: (json['pointNum'] as num).toInt(),
        rewardTitle: json['rewardTitle'] as String,
      );
    } catch (e, st) {
      PointCard(
        id: '',
        title: '',
        description: '',
        createdAt: DateTime.now(),
        pointNum: 0,
        rewardTitle: '',
      );
      rethrow;
    }
  }
}
