part of '../library.dart';

/// Shown when the library has no materials at all — a centred illustration, a
/// short explainer, and a single "Add new material" CTA. No search, filters, or
/// floating button (nothing to search or filter yet).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.h.t24,
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: 96,
            height: 96,
            alignment: .center,
            decoration: BoxDecoration(
              color: AppTheme.c.subBackground,
              borderRadius: 28.radius(),
              border: Border.all(color: AppTheme.c.border),
            ),
            child: Icon(
              LucideIcons.library_big,
              size: SpaceToken.t32,
              color: AppTheme.c.subText,
            ),
          ),
          Space.y.t24,
          Text('Your library is empty', style: AppText.h2, textAlign: .center),
          Space.y.t12,
          Text(
            'Add your notes, slides, or photos to start — everything is '
            'processed privately on your device for OCR & embeddings.',
            style: AppText.b2.cl(AppTheme.c.subText),
            textAlign: .center,
          ),
          Space.y.t32,
          const _AddMaterialTile(),
        ],
      ),
    );
  }
}
