import 'package:flutter/material.dart';
import 'newPointCardScreen.dart';
import 'hive_universal_store.dart';
import 'hive_box.dart';
import 'package:path_provider/path_provider.dart';
import 'model/point_card.dart';

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

  void _loadPointCards() async {
    final cardBox = await HiveBoxes.pointCards();
    final allCards = await cardBox.list();
    print("PointCardの件数: ${allCards.length}");
    setState(() {
      _counter = allCards.length;
      _allPointCards = allCards;
    });
  }

  void _newPointCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPointCardScreen()),
    ).then((_) {
      _loadPointCards(); // 戻ってきたら件数を更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          child: ListView.builder(
              itemCount: _allLists?.length ?? 0,
              itemBuilder: (context, index) {
                final item = _allLists![index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newPointCard,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
