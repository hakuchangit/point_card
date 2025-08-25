import 'hive_universal_store.dart';
import '../model/point_card.dart';
import '../model/point_card_reward.dart';
import '../model/point_card_stamp.dart';

//各モデル専用の BoxCollection を開くヘルパー

class HiveBoxes {
  // collection point_cardsを返す
  // Hive の「保存箱（Box）」を開いて使えるようにしている
  static Future<BoxCollection<PointCard>> pointCards() {
    return BoxCollection.open<PointCard>(
      namespace: "stamp_card_v1",
      collection: "point_cards",
      codec: JsonCodecT<PointCard>(
        fromJson: PointCard.fromJson,
        toJson: (c) => c.toJson(),
      ),
    );
  }

  static Future<BoxCollection<PointCardReward>> rewardItems() {
    return BoxCollection.open<PointCardReward>(
      namespace: "stamp_card_v1",
      collection: "reward_items",
      codec: JsonCodecT<PointCardReward>(
        fromJson: PointCardReward.fromJson,
        toJson: (r) => r.toJson(),
      ),
    );
  }

  static Future<BoxCollection<PointCardStamp>> stamps() {
    return BoxCollection.open<PointCardStamp>(
      namespace: "stamp_card_v1",
      collection: "stamps",
      codec: JsonCodecT<PointCardStamp>(
        fromJson: PointCardStamp.fromJson,
        toJson: (s) => s.toJson(),
      ),
    );
  }
}
