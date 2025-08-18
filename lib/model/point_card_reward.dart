// ポイントカードのリワードのクラス
class PointCardReward {
  final String id; // 主キー
  final String point_card_id; // 外部キー
  final String reward_name;
  final String reward_description;
  final int reward_point_num;

  PointCardReward({
    required this.id,
    required this.point_card_id,
    required this.reward_name,
    required this.reward_description,
    required this.reward_point_num,
  });
}
