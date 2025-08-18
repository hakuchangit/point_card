// ポイントカードのクラス
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
  }) : assert(pointNum > 1, 'pointNum must be > 1');
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
}
