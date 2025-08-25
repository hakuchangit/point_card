import 'package:flutter/material.dart';
import '../widget/number_form_field.dart';

/// 1行分のモデル
class RewardItem {
  int? point;
  String reward_title;
  RewardItem({this.point, this.reward_title = ''});

  RewardItem copy() => RewardItem(point: point, reward_title: reward_title);
}

class RewardListEditor extends StatefulWidget {
  /// 既存の行（編集開始時の状態）
  final List<RewardItem> initialItems;

  /// 値が変わるたびに現在のリストを返します
  final ValueChanged<List<RewardItem>>? onChanged;

  /// 何も無い時のヒント
  final String emptyHint;

  const RewardListEditor({
    super.key,
    this.initialItems = const [],
    this.onChanged,
    this.emptyHint = '＋ボタンでご褒美を追加',
  });

  @override
  State<RewardListEditor> createState() => _RewardListEditorState();
}

class _RewardListEditorState extends State<RewardListEditor> {
  late List<RewardItem> _items;

  @override
  void initState() {
    super.initState();
    // 防御的コピー
    _items = widget.initialItems.map((e) => e.copy()).toList();
  }

  void _notify() => widget.onChanged?.call(List.unmodifiable(_items));

  void _addRow() {
    setState(() {
      _items.add(RewardItem());
    });
    _notify();
  }

  void _removeRow(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // ← 全体を Expanded で制約に入れる
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 見出し
          const Row(
            children: [
              Expanded(child: Text('ポイント数', style: TextStyle(fontSize: 16))),
              SizedBox(width: 12),
              Expanded(child: Text('ご褒美', style: TextStyle(fontSize: 16))),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            // リスト部分（スクロールさせる）
            //Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      widget.emptyHint,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: NumberFormField(
                              initialValue: item.point ?? 0,
                              onChanged: (v) {
                                item.point = v;
                                _notify();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: item.reward_title,
                              decoration: const InputDecoration(
                                hintText: '例: アイス',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 8,
                                ),
                              ),
                              onChanged: (v) {
                                item.reward_title = v;
                                _notify();
                              },
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? '必須' : null,
                            ),
                          ),
                          IconButton(
                            tooltip: '削除',
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeRow(index),
                          ),
                        ],
                      );
                    },
                  ),
            //),
          ),

          const SizedBox(height: 12),

          // 追加ボタンはリストの外（固定表示）
          Align(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add),
              label: const Text('ご褒美を追加'),
            ),
          ),
        ],
      ),
    );
  }
}
