import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/point_card.dart';
import '../model/point_card_stamp.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'update_point_card_screen.dart';
import '../hive_box.dart';

class StampCardScreen extends StatefulWidget {
  final PointCard pointCard;

  const StampCardScreen({Key? key, required this.pointCard}) : super(key: key);

  @override
  State<StampCardScreen> createState() => _StampCardScreenState();
}

class _StampCardScreenState extends State<StampCardScreen> {
  late Box<PointCardStamp> stampBox;
  List<PointCardStamp> stamps = [];
  final ImagePicker _picker = ImagePicker();
  PointCard? _pointCard;

  @override
  void initState() {
    super.initState();
    _pointCard = widget.pointCard;
    _loadStamps();
  }

  void _loadStamps() async {
    final pc = _pointCard;
    if (pc == null) return;

    stampBox = await Hive.openBox<PointCardStamp>('point_card_stamps');

    // 既存のスタンプを読み込み
    final existingStamps = stampBox.values
        .where((stamp) => stamp.pointCardId == pc.id)
        .toList();

    // スタンプ番号順にソート
    existingStamps.sort((a, b) => a.stampNumber.compareTo(b.stampNumber));

    // 足りないスタンプを作成
    final List<PointCardStamp> allStamps = [];
    for (int i = 1; i <= pc.pointNum; i++) {
      final existing = existingStamps.firstWhere(
        (stamp) => stamp.stampNumber == i,
        orElse: () => PointCardStamp(
          id: '${pc.id}_stamp_$i',
          pointCardId: pc.id,
          stampNumber: i,
          isStamped: false,
        ),
      );
      allStamps.add(existing);
    }

    setState(() {
      stamps = allStamps;
    });
  }

  Future<void> _reloadCard() async {
    final pc = _pointCard;
    if (pc == null) return;

    final cardBox = await HiveBoxes.pointCards();
    final updated = await cardBox.get(pc.id);
    if (!mounted) return;
    if (updated == null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _pointCard = updated;
    });
    _loadStamps();
  }

  void _toggleStamp(PointCardStamp stamp) async {
    if (stamp.isStamped) {
      // スタンプを削除
      final updatedStamp = stamp.copyWith(isStamped: false, stampUrl: null);
      await stampBox.put(stamp.id, updatedStamp);
    } else {
      // 画像選択ダイアログを表示
      _showImageSelectionDialog(stamp);
    }
    _loadStamps();
  }

  void _showImageSelectionDialog(PointCardStamp stamp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('スタンプ画像を選択'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('絵文字スタンプ'),
                onTap: () {
                  Navigator.pop(context);
                  _showEmojiSelection(stamp);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('写真を撮る'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(stamp, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('ギャラリーから選択'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(stamp, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmojiSelection(PointCardStamp stamp) {
    final emojis = ['⭐', '🎉', '🎯', '🌟', '👍', '💯', '🎊', '🔥', '✨', '🏆'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('絵文字を選択'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _setEmojiStamp(stamp, emojis[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        emojis[index],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // 絵文字スタンプを設定
  Future<void> _setEmojiStamp(PointCardStamp stamp, String emoji) async {
    print('絵文字設定開始: $emoji');

    final updatedStamp = stamp.copyWith(
      isStamped: true,
      stampUrl: 'emoji:$emoji',
      stampedAt: DateTime.now(), // スタンプした時刻も記録
    );

    print('更新されたスタンプ: ${updatedStamp.toString()}');

    // Hiveに保存
    await stampBox.put(stamp.id, updatedStamp);
    print('Hive保存完了');

    // データを再読み込み
    _loadStamps();
  }

  void _pickImage(PointCardStamp stamp, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final updatedStamp = stamp.copyWith(
          isStamped: true,
          stampUrl: image.path,
        );
        await stampBox.put(stamp.id, updatedStamp);
        _loadStamps();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('画像の選択でエラーが発生しました: $e')));
    }
  }

  Widget _buildStampImage(PointCardStamp stamp) {
    if (!stamp.isStamped || stamp.stampUrl == null) {
      return const SizedBox.shrink();
    }

    if (stamp.stampUrl!.startsWith('emoji:')) {
      // 絵文字の場合
      final emoji = stamp.stampUrl!.substring(6);
      return Text(emoji, style: const TextStyle(fontSize: 24));
    } else {
      // 画像ファイルの場合
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          File(stamp.stampUrl!),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red, size: 24);
          },
        ),
      );
    }
  }

  int get currentStampCount {
    return stamps.where((stamp) => stamp.isStamped).length;
  }

  @override
  Widget build(BuildContext context) {
    final pc = _pointCard;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        title: const Text('カード'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (pc == null) return;
              // 編集画面への遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePointCardScreen(pointCard: pc),
                ),
              ).then((_) => _reloadCard());
            },
          ),
        ],
      ),
      body: pc == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // カードタイトル
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '〜${pc.title}〜',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pc.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // リワード一覧表示
                        Text(
                          pc.rewardTitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // スタンプグリッド
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: stamps.length,
                    itemBuilder: (context, index) {
                      final stamp = stamps[index];
                      return GestureDetector(
                        onTap: () => _toggleStamp(stamp),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: stamp.isStamped
                                ? const Color(0xFF42A5F5)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: stamp.isStamped
                                  ? const Color(0xFF1E88E5)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: stamp.isStamped
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF42A5F5,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            children: [
                              // 背景の数字
                              Center(
                                child: Text(
                                  '${stamp.stampNumber}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: stamp.isStamped
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              // スタンプ画像
                              if (stamp.isStamped)
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: _buildStampImage(stamp),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // 操作説明
                  Text(
                    '👆 数字をタップしてスタンプを押そう！',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),

                  const SizedBox(height: 24),

                  // 進捗表示
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '現在のスタンプ: $currentStampCount/${pc.pointNum}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: currentStampCount / pc.pointNum,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF42A5F5),
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 16),
                      ], // 獲得可能なリワード表示
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
