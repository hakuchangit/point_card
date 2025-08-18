// ポイントカードのリワードのクラス
import 'package:flutter/foundation.dart';

@immutable
class PointCardReward {
  final String id; // 主キー
  final String pointCardId; // 外部キー
  final String rewardName;
  final String rewardDescription;
  final int rewardPointNum;

  const PointCardReward({
    required this.id,
    required this.pointCardId,
    required this.rewardName,
    required this.rewardDescription,
    required this.rewardPointNum,
  });

  PointCardReward copyWith({
    String? id,
    String? pointCardId,
    String? rewardName,
    String? rewardDescription,
    int? rewardPointNum,
  }) {
    return PointCardReward(
      id: id ?? this.id,
      pointCardId: pointCardId ?? this.pointCardId,
      rewardName: rewardName ?? this.rewardName,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      rewardPointNum: rewardPointNum ?? this.rewardPointNum,
    );
  }
}
