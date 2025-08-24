import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewPointCardScreen extends StatefulWidget {
  const NewPointCardScreen({super.key});

  @override
  State<NewPointCardScreen> createState() => _NewPointCardScreenState();
}

class _NewPointCardScreenState extends State<NewPointCardScreen> {
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            Text('ポイント数', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
