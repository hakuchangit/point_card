import 'package:flutter/material.dart';
import 'screen/new_point_card_screen.dart';
import 'hive_universal_store.dart';
import 'hive_box.dart';
import 'package:path_provider/path_provider.dart';
import 'model/point_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'widget/point_card_visual.dart';
import 'model/point_card_reward.dart';
import 'screen/point_card_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hiveのロック削除（安全策）
  try {
    await HiveUniversal.cleanupHiveLockFiles();
  } catch (e, st) {
    debugPrint("cleanupHiveLockFiles error: $e\n$st");
  }
  // Hive初期化
  try {
    await HiveUniversal.init(); // ← pathは渡さない
  } catch (e, st) {
    debugPrint("Hive init error: $e\n$st");
  }

  runApp(const MyApp());
}

// 🔹 MyApp を StatefulWidget に修正
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 20)),
      ),
      home: const MainCardPage(title: 'Flutter Demo Home Page'),
    );
  }
}

// 🔹 PointCard 一覧画面
class MainCardPage extends StatefulWidget {
  const MainCardPage({super.key, required this.title});

  final String title;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  int _counter = 0;
  List<Map<String, dynamic>> _allPointCards = [];

  @override
  void initState() {
    super.initState();
    _loadPointCards();
  }

  // void _loadPointCards() async {
  //   final cardBox = await HiveBoxes.pointCards();
  //   final allCards = await cardBox.list();
  //   print("PointCardの件数: ${allCards.length}");
  //   setState(() {
  //     _counter = allCards.length;
  //     _allPointCards = allCards;
  //   });
  // }

  void _newPointCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPointCardScreen()),
    ).then((_) {
      _loadPointCards(); // 戻ってきたら件数を更新
    });
  }

  void _loadPointCards() async {
    final cardBox = await HiveBoxes.pointCards(); // BoxCollection<PointCard>
    final rewardBox =
        await HiveBoxes.rewardItems(); // BoxCollection<PointCardReward>

    // すべてのカードを取得
    final cards = await cardBox.list();
    // すべてのリワードを取得
    final allRewards = await rewardBox.list();

    // 各カードに紐づくリワードを検索してまとめる
    final enrichedCards = cards.map((card) {
      final rewardsForCard = allRewards
          .where((r) => r.pointCardId == card.id)
          .toList();

      return {
        "card": card,
        "rewards": rewardsForCard,
        "rewardsText": rewardsForCard
            .map((r) => "${r.rewardPointNum}スタンプで${r.rewardName}")
            .join("\n"),
      };
    }).toList();
    setState(() {
      _counter = cards.length; // 件数はカードの数
      _allPointCards = enrichedCards; // ← こちらだけをセット
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Point Cards')),
      body: (_allPointCards == null || _allPointCards!.isEmpty)
          ? const Center(child: Text('カードがありません'))
          : ListView.builder(
              itemCount: _allPointCards!.length,
              itemBuilder: (context, index) {
                final card = _allPointCards![index]["card"] as PointCard;
                final rewards =
                    _allPointCards![index]["rewards"] as List<PointCardReward>;
                return Slidable(
                  key: ValueKey(card.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final box =
                              await HiveBoxes.pointCards(); // Box<PointCard>
                          await box.delete(card.id);
                          print("delete: ${card.id}");
                          _loadPointCards();
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: PointCardVisual(
                      title: card.title,
                      rewards: rewards,
                      rewardsText: card
                          .description, // 複数行OK（例: "10スタンプで外食\n20スタンプでお小遣い500円"）
                      // remainingStamps: item.nextRemain, // ← あれば渡す。無ければ省略で非表示
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StampCardScreen(
                              pointCard: card,
                              rewards: rewards,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newPointCard,
        tooltip: '追加',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
