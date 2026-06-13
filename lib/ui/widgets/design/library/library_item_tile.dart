import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';

/// Badge colour per material kind — the coloured square in front of a row.
extension ItemKindBadge on ItemKind {
  Color get badgeColor => switch (this) {
    ItemKind.pdf => const Color(0xFFE05252),
    ItemKind.img => const Color(0xFF4A90D9),
    ItemKind.note => const Color(0xFF4CAF50),
    ItemKind.slide => const Color(0xFFE09A2B),
    ItemKind.video => const Color(0xFF9B59B6),
    ItemKind.voice => const Color(0xFF1ABC9C),
  };
}

/// A single material row — kind badge + name + meta (subject · size · added ·
/// status · AI-INDEXED) + an optional trailing affordance. Shared across the
/// onboarding "added so far" list and the Library.
class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.item,
    this.subjectName,
    this.statusLabel,
    this.showAiIndexed = false,
    this.trailing,
    this.onTap,
  });

  final LibraryItem item;

  /// Resolved name of the subject this material is attached to (if any).
  final String? subjectName;

  /// MOCK presentational status ("Annotated", "being read"). Library passes it;
  /// onboarding leaves it null.
  final String? statusLabel;

  /// Renders the gold "AI INDEXED" pill when true.
  final bool showAiIndexed;

  /// Trailing affordance — onboarding's remove X, Library's "…" menu button.
  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final color = item.kind.badgeColor;
    final metaStyle = AppText.b2.cl(AppTheme.c.subText);

    final meta = <Widget>[
      if (subjectName != null)
        Row(
          mainAxisSize: .min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: .circle,
                color: item.colorHex?.toColor() ?? AppTheme.c.subText,
              ),
            ),
            Space.x.t04,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                subjectName!,
                style: metaStyle,
                maxLines: 1,
                overflow: .ellipsis,
              ),
            ),
          ],
        ),
      Text(item.fileSize.readableSize, style: metaStyle),
      Text(_agoLabel(item.uploadedAt), style: metaStyle),
      if (statusLabel != null) Text(statusLabel!, style: metaStyle),
      if (showAiIndexed) const AppAiPill(text: 'AI INDEXED'),
    ];

    return GestureDetector(
      behavior: .opaque,
      onTap: onTap,
      child: Container(
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
                  Space.y.t04,
                  Wrap(
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: meta
                        .asMap()
                        .entries
                        .expand(
                          (e) => [
                            if (e.key != 0)
                              Text(' · ', style: metaStyle),
                            e.value,
                          ],
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[Space.x.t08, trailing!],
          ],
        ),
      ),
    );
  }
}

/// "added today" / "added Xd ago" from a material's upload timestamp.
String _agoLabel(DateTime uploadedAt) {
  final days = DateTime.now().difference(uploadedAt).inDays;
  if (days <= 0) return 'added today';
  if (days == 1) return 'added 1d ago';
  return 'added ${days}d ago';
}
