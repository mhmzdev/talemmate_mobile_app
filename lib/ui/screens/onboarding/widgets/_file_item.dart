part of '../onboarding.dart';

class _FileItem extends StatelessWidget {
  const _FileItem({required this.item, required this.onRemove});

  final LibraryItem item;
  final VoidCallback onRemove;

  static Color _badgeColor(ItemKind kind) => switch (kind) {
    ItemKind.pdf => const Color(0xFFE05252),
    ItemKind.img => const Color(0xFF4A90D9),
    ItemKind.note => const Color(0xFF4CAF50),
    ItemKind.slide => const Color(0xFFE09A2B),
    ItemKind.video => const Color(0xFF9B59B6),
    ItemKind.voice => const Color(0xFF1ABC9C),
  };

  String get _readableSize {
    final kb = item.fileSize / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final color = _badgeColor(item.kind);

    return Container(
      padding: Space.a.t12,
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 10.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: 6.radius(),
            ),
            child: Text(
              item.kind.name.toUpperCase(),
              style: AppText.l1b.cl(color).copyWith(letterSpacing: 0.5),
            ),
          ),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  item.name,
                  style: AppText.b2,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                Text(_readableSize, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ),
          AppTouch(
            onTap: onRemove,
            hasSplash: false,
            child: Icon(LucideIcons.x, size: 18, color: AppTheme.c.subText),
          ),
        ],
      ),
    );
  }
}
