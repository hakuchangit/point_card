import 'package:flutter/material.dart';

class NewPointCardScreen extends StatelessWidget {
  const NewPointCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新規作成")),
      body: Center(child: Text("これは新しい画面です！")),
    );
  }
}
