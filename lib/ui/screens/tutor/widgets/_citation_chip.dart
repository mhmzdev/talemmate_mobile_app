part of '../tutor.dart';

/// A pill referencing a source material. Tapping peeks the citation details
/// (non-destructive — full item navigation is out of scope for v1).
class _CitationChip extends StatelessWidget {
  const _CitationChip({required this.citation});

  final Citation citation;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final page = citation.pageReference;
    return AppTouch(
      onTap: () => showAppAlert(
        context,
        icon: const Icon(LucideIcons.book_open),
        title: citation.source,
        subtitle: page == null ? 'From your materials.' : 'Reference: $page',
        routeName: 'citation',
        actions: [
          AppAlertAction(
            label: 'Close',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
      hasSplash: false,
      child: Container(
        padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
        decoration: BoxDecoration(
          color: AppTheme.c.background,
          borderRadius: 8.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.book_open,
              size: SpaceToken.t12,
              color: AppTheme.c.accent,
            ),
            Space.x.t04,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                page == null ? citation.source : '${citation.source} · $page',
                style: AppText.b2.cl(AppTheme.c.subText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
