import 'package:flutter/material.dart';

class NumberFormField extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const NumberFormField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<NumberFormField> createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= 1 && parsed <= 1000) {
      widget.onChanged(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '1〜1000',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ポイント数を入力してください';
        }
        final parsed = int.tryParse(value);
        if (parsed == null || parsed < 1 || parsed > 1000) {
          return '1〜1000の範囲で入力してください';
        }
        return null;
      },
      onChanged: _handleChanged,
    );
  }
}
