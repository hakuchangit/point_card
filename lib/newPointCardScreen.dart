import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widget/number_form_field.dart';

class NewPointCardScreen extends StatefulWidget {
  const NewPointCardScreen({super.key});

  @override
  State<NewPointCardScreen> createState() => _NewPointCardScreenState();
}

class _NewPointCardScreenState extends State<NewPointCardScreen> {
  int _selectedNumber = 0;
  String _title = '';

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
          ],
        ),
      ),
    );
  }
}
