part of '../library.dart';

/// The real per-row extraction status — a spinner while reading, the gold
/// "AI INDEXED" pill (+ page count) once indexed, or a muted tap-to-retry on
/// failure. Lives in the meta row of a [LibraryItemTile].
class _MaterialStatus extends StatelessWidget {
  const _MaterialStatus({required this.item});

  final LibraryItem item;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final metaStyle = AppText.b2.cl(AppTheme.c.subText);

    return switch (item.processingStatus) {
      ProcessingStatus.pending || ProcessingStatus.processing => Row(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppTheme.c.subText,
            ),
          ),
          Space.x.t04,
          Text('Reading…', style: metaStyle),
        ],
      ),
      ProcessingStatus.indexed => _indexed(metaStyle),
      ProcessingStatus.failed => AppTouch(
        onTap: () => MaterialCubit.c(context).process(item),
        hasSplash: false,
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(LucideIcons.circle_alert, size: 12, color: AppTheme.c.error),
            Space.x.t04,
            Text(
              'Couldn\'t read · retry',
              style: metaStyle.cl(AppTheme.c.error),
            ),
          ],
        ),
      ),
    };
  }

  Widget _indexed(TextStyle metaStyle) {
    final pages = item.indexedPageCount;
    return Row(
      mainAxisSize: .min,
      children: [
        const AppAiPill(text: 'AI INDEXED'),
        if (pages != null) ...[
          Space.x.t04,
          Text('$pages ${pages == 1 ? 'page' : 'pages'}', style: metaStyle),
        ],
      ],
    );
  }
}
