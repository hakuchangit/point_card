import 'package:flutter/material.dart';
import '../widget/number_form_field.dart';
import '../model/point_card.dart';
import '../hive_box.dart';

class UpdatePointCardScreen extends StatefulWidget {
  final PointCard pointCard;

  const UpdatePointCardScreen({super.key, required this.pointCard});

  @override
  State<UpdatePointCardScreen> createState() => _UpdatePointCardScreenState();
}

class _UpdatePointCardScreenState extends State<UpdatePointCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _rewardCtrl;
  late int _pointNum;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.pointCard.title);
    _rewardCtrl = TextEditingController(text: widget.pointCard.rewardTitle);
    _pointNum = widget.pointCard.pointNum;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _rewardCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePointCard() async {
    final updatedCard = PointCard(
      id: widget.pointCard.id, // 既存IDを維持
      title: _titleCtrl.text.trim(),
      pointNum: _pointNum,
      description: widget.pointCard.description, // 既存を維持
      rewardTitle: _rewardCtrl.text.trim(),
      createdAt: widget.pointCard.createdAt,
    );
    final cardBox = await HiveBoxes.pointCards();
    await cardBox.put(updatedCard.id, updatedCard);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deletePointCard() async {
    final cardBox = await HiveBoxes.pointCards(); // BoxCollection<PointCard>
    await cardBox.delete(widget.pointCard.id); // ← これでOK

    if (!mounted) return; // dispose 済みなら何もしない
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('編集')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // タイトル
              Text('タイトル', style: t.bodyLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'タイトルを入力してください' : null,
              ),
              const SizedBox(height: 24),

              // ポイント数
              Text('ポイント数', style: t.bodyLarge),
              const SizedBox(height: 8),
              NumberFormField(
                initialValue: _pointNum,
                onChanged: (v) => setState(() => _pointNum = v),
              ),
              const SizedBox(height: 24),

              // ご褒美設定（タイトル1行のみ）
              Text('ご褒美設定', style: t.bodyLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _rewardCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'ご褒美を入力してください' : null,
              ),

              const SizedBox(height: 32),

              // 削除ボタン
              Center(
                child: OutlinedButton.icon(
                  onPressed: _deletePointCard,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('このカードを削除する'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD9362B),
                    side: const BorderSide(color: Color(0xFFD9362B), width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 保存
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _savePointCard,
        icon: const Icon(Icons.save),
        label: const Text('保存'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
