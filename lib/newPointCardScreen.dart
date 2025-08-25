import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widget/number_form_field.dart';
import '../widget/reward_list_editor.dart';
import '../model/point_card.dart';

class NewPointCardScreen extends StatefulWidget {
  const NewPointCardScreen({super.key});

  @override
  State<NewPointCardScreen> createState() => _NewPointCardScreenState();
}

class _NewPointCardScreenState extends State<NewPointCardScreen> {
  int _selectedNumber = 1;
  String _title = '';
  List<RewardItem> _rewards = [];

  // errorダイアログ
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("入力エラー"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新規作成")),
      body: Center(
        child: Column(
          children: [
            Text('タイトル', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              onFieldSubmitted: (value) {
                _title = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text('ポイント数', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            NumberFormField(
              initialValue: _selectedNumber,
              onChanged: (value) {
                setState(() {
                  _selectedNumber = value;
                });
              },
            ),
            Text('ご褒美設定', style: Theme.of(context).textTheme.bodyLarge),
            RewardListEditor(
              initialItems: _rewards,
              onChanged: (list) {
                _rewards = list;
                // setState は画面表示を変えたい時だけでOK
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_title.trim().isEmpty) {
            _showError("タイトルを入力してください。");
            return;
          }
          if (_selectedNumber <= 0) {
            _showError("ポイント数は 1 以上を入力してください。");
            return;
          }
          // ポイントカードを保存

          PointCard pointCard = PointCard(
            title: _title,
            pointNum: _selectedNumber,
            description: "割愛",
            createdAt: DateTime.now(),
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          print(pointCard.toString());

          Navigator.pop(context);
          // ポイントカードを保存
        },
        child: Text('保存'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
