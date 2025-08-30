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
  List<PointCard> _allPointCards = [];

  @override
  void initState() {
    super.initState();
    _loadPointCards();
  }

  void _newPointCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPointCardScreen()),
    ).then((_) {
      _loadPointCards(); // 戻ってきたら件数を更新
    });
  }

  void _loadPointCards() async {
    final cardBox = await HiveBoxes.pointCards(); // BoxCollection<PointCard>r

    // すべてのカードを取得
    final cards = await cardBox.list();
    setState(() {
      _allPointCards = cards;
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
                final card = _allPointCards![index];
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
                      rewardsText: card.rewardTitle,
                      onTap: () {
                        print("onTap: ${card.rewardTitle}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StampCardScreen(pointCard: card),
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
