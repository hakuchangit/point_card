// // ポイントカードのリワードのクラス
// 今回は複数設定せず、Maxで1つのリワードを設定する
// import 'package:flutter/foundation.dart';

// @immutable
// class PointCardReward {
//   final String id; // 主キー
//   final String pointCardId; // 外部キー
//   final String rewardName;
//   final String rewardDescription;
//   final int rewardPointNum;

//   const PointCardReward({
//     required this.id,
//     required this.pointCardId,
//     required this.rewardName,
//     required this.rewardDescription,
//     required this.rewardPointNum,
//   });

//   PointCardReward copyWith({
//     String? id,
//     String? pointCardId,
//     String? rewardName,
//     String? rewardDescription,
//     int? rewardPointNum,
//   }) {
//     return PointCardReward(
//       id: id ?? this.id,
//       pointCardId: pointCardId ?? this.pointCardId,
//       rewardName: rewardName ?? this.rewardName,
//       rewardDescription: rewardDescription ?? this.rewardDescription,
//       rewardPointNum: rewardPointNum ?? this.rewardPointNum,
//     );
//   }

//   @override
//   String toString() {
//     return 'PointCardReward(id: $id, pointCardId: $pointCardId, rewardName: $rewardName, rewardDescription: $rewardDescription, rewardPointNum: $rewardPointNum)';
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'pointCardId': pointCardId,
//     'rewardName': rewardName,
//     'rewardDescription': rewardDescription,
//     'rewardPointNum': rewardPointNum,
//   };
//   factory PointCardReward.fromJson(Map<String, dynamic> json) {
//     try {
//       return PointCardReward(
//         id: json['id'],
//         pointCardId: json['pointCardId'],
//         rewardName: json['rewardName'],
//         rewardDescription: json['rewardDescription'],
//         rewardPointNum: json['rewardPointNum'],
//       );
//     } catch (e, st) {
//       debugPrint("PointCard.fromJson error: $e\n$st");
//       return PointCardReward(
//         id: '',
//         pointCardId: '',
//         rewardName: '',
//         rewardDescription: '',
//         rewardPointNum: 0,
//       );
//     }
//   }
// }
