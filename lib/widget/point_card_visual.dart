import 'package:flutter/material.dart';

class PointCardVisual extends StatelessWidget {
  final String title;
  final String rewardsText; // ご褒美ルールをテキストでまとめて渡す
  final int? remainingStamps; // 「次のご褒美まであとN」(任意)
  final VoidCallback? onTap;

  const PointCardVisual({
    super.key,
    required this.title,
    required this.rewardsText,
    this.remainingStamps,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '〜 ご褒美 〜',
                textAlign: TextAlign.center,
                style: t.titleMedium,
              ),
              const SizedBox(height: 12),
              // 複数行の説明をそのまま表示（\nで改行）
              Text(
                rewardsText,
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
              const SizedBox(height: 20),
              if (remainingStamps != null) ...[
                Text(
                  '次のご褒美まであと',
                  textAlign: TextAlign.center,
                  style: t.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '$remainingStampsスタンプ',
                  textAlign: TextAlign.center,
                  style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: content,
    );
  }
}
