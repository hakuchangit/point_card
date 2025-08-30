import 'package:hive/hive.dart';

part 'point_card_stamp.g.dart';

@HiveType(typeId: 0)
class PointCardStamp extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pointCardId;

  @HiveField(2)
  final int stampNumber;

  @HiveField(3)
  final bool isStamped;

  @HiveField(4)
  final String? stampUrl;

  @HiveField(5)
  final DateTime? stampedAt;

  PointCardStamp({
    required this.id,
    required this.pointCardId,
    required this.stampNumber,
    this.isStamped = false,
    this.stampUrl,
    this.stampedAt,
  });

  // JSONからインスタンスを作成
  factory PointCardStamp.fromJson(Map<String, dynamic> json) {
    return PointCardStamp(
      id: json['id'] as String,
      pointCardId: json['pointCardId'] as String,
      stampNumber: json['stampNumber'] as int,
      isStamped: json['isStamped'] as bool? ?? false,
      stampUrl: json['stampUrl'] as String?,
      stampedAt: json['stampedAt'] != null
          ? DateTime.parse(json['stampedAt'] as String)
          : null,
    );
  }

  // インスタンスをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pointCardId': pointCardId,
      'stampNumber': stampNumber,
      'isStamped': isStamped,
      'stampUrl': stampUrl,
      'stampedAt': stampedAt?.toIso8601String(),
    };
  }

  PointCardStamp copyWith({
    String? id,
    String? pointCardId,
    int? stampNumber,
    bool? isStamped,
    String? stampUrl,
    DateTime? stampedAt,
  }) {
    return PointCardStamp(
      id: id ?? this.id,
      pointCardId: pointCardId ?? this.pointCardId,
      stampNumber: stampNumber ?? this.stampNumber,
      isStamped: isStamped ?? this.isStamped,
      stampUrl: stampUrl ?? this.stampUrl,
      stampedAt: stampedAt ?? this.stampedAt,
    );
  }

  @override
  String toString() {
    return 'PointCardStamp(id: $id, pointCardId: $pointCardId, stampNumber: $stampNumber, isStamped: $isStamped, stampUrl: $stampUrl, stampedAt: $stampedAt)';
  }
}
