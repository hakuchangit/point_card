// ポイントカードのスタンプのクラス
class PointCardStamp {
  final String id; // 主キー
  final String point_card_id; // 外部キー
  final int stamp_number;
  final bool is_stamped;
  final String stamp_url;

  PointCardStamp({
    required this.id,
    required this.point_card_id,
    required this.stamp_number,
    required this.is_stamped,
    required this.stamp_url,
  });
}
