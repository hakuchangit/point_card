// ポイントカードのスタンプのクラス
import 'package:flutter/foundation.dart';

@immutable
class PointCardStamp {
  final String id; // 主キー
  final String pointCardId; // 外部キー
  final int stampNumber; // 1,2,3... の連番
  final bool isStamped; // 押印済みか
  final String? stampUrl; // 画像URLなど（任意）　・・null許容

  const PointCardStamp({
    required this.id,
    required this.pointCardId,
    required this.stampNumber,
    required this.isStamped,
    this.stampUrl,
  }) : assert(stampNumber >= 1, 'stampNumber must be >= 1');

  static const _unset = Object();
  PointCardStamp copyWith({
    String? id,
    String? pointCardId,
    int? stampNumber,
    bool? isStamped,
    Object? stampUrl = _unset,
    // ここは null 代入も許したいなら別途フラグ方式に
  }) {
    return PointCardStamp(
      id: id ?? this.id,
      pointCardId: pointCardId ?? this.pointCardId,
      stampNumber: stampNumber ?? this.stampNumber,
      isStamped: isStamped ?? this.isStamped,
      stampUrl: identical(stampUrl, _unset)
          ? this.stampUrl
          : stampUrl as String?,
    );
  }
}
