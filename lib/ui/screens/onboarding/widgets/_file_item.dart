part of '../onboarding.dart';

class _FileItem extends StatelessWidget {
  const _FileItem({required this.file});

  final Map<String, dynamic> file;

  static Color _badgeColor(String type) => switch (type) {
    'PDF' => const Color(0xFFE05252),
    'IMG' => const Color(0xFF4A90D9),
    'NOTE' => const Color(0xFF4CAF50),
    'SLIDE' => const Color(0xFFE09A2B),
    _ => const Color(0xFF6B6B85),
  };

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final type = file['type'] as String? ?? '';
    final name = file['name'] as String? ?? '';
    final size = file['size'] as String? ?? '';

    return Container(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t12),
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _badgeColor(type).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: AppText.l1b.cl(_badgeColor(type)).copyWith(letterSpacing: 0.5),
            ),
          ),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.b2, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(size, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
