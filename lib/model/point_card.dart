// ポイントカードのクラス
class PointCard {
  final String id;
  final String title;
  final String description;
  final DateTime create_date;
  final int point_num;

  PointCard({
    required this.id,
    required this.title,
    required this.description,
    required this.create_date,
    required this.point_num,
  });
}
