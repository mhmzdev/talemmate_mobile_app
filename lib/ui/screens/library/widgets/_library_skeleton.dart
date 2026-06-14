part of '../library.dart';

/// Full-screen shimmer placeholder shown on the first load (before any items are
/// cached). Mirrors the real body — header counts, search, filter chips, grouped
/// sections, and the add tile — so the swap to real content is seamless. The
/// static chrome (the "Library" title + the search affordance) stays real.
/// Screen-private on purpose: it is shaped to this screen.
class _LibrarySkeleton extends StatelessWidget {
  const _LibrarySkeleton();

  // Faux section row counts — just enough to fill the first viewport.
  static const _sections = [2, 3];
  static const _chipWidths = [44.0, 150.0, 120.0];

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        // Header — real title, skeleton count (matches the real _Header).
        Padding(
          padding: Space.sym(SpaceToken.t24, SpaceToken.t12),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('Library', style: AppText.h1),
              Space.y.t04,
              const _Shimmer(child: _SkBox(width: 150, height: 12)),
            ],
          ),
        ),
        Padding(
          padding: Space.sym(SpaceToken.t24, SpaceToken.t04),
          child: _Shimmer(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                const _SkBox(height: 52, radius: 12), // search bar
                Space.y.t12,
                SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: Row(
                    children: _chipWidths
                        .asMap()
                        .entries
                        .expand(
                          (e) => [
                            if (e.key != 0) Space.x.t08,
                            _SkBox(width: e.value, height: 34, radius: 20),
                          ],
                        )
                        .toList(),
                  ),
                ),
                ..._sections.map((n) => _SkeletonSection(rows: n)),
                Space.y.t16,
                const _SkBox(height: 72, radius: 14), // add-material tile
              ],
            ),
          ),
        ),
        Space.y.t12,
        Text(
          'New uploads are processed privately on your device for OCR & '
          'embeddings.',
          style: AppText.b2.cl(AppTheme.c.subText),
          textAlign: .center,
        ),
        Space.y.t24,
      ],
    );
  }
}

/// Shared shimmer envelope — one cream sweep over whatever skeleton blocks it
/// wraps. Keep the base/highlight subtle so it reads as "loading", not "broken".
class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Shimmer.fromColors(
      baseColor: AppTheme.c.subText.withValues(alpha: 0.13),
      highlightColor: AppTheme.c.subText.withValues(alpha: 0.04),
      period: const Duration(milliseconds: 1300),
      child: child,
    );
  }
}

class _SkeletonSection extends StatelessWidget {
  const _SkeletonSection({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Space.t.t24,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const _SkBox(width: 8, height: 8),
                    Space.x.t08,
                    const _SkBox(width: 120, height: 14),
                    Space.x.t08,
                    const _SkBox(width: 36, height: 10),
                  ],
                ),
              ),
              Space.x.t08,
              const _SkBox(width: 44, height: 10),
            ],
          ),
          Space.y.t12,
          ...List.generate(rows, (i) => i).expand(
            (i) => [
              if (i > 0) Space.y.t08,
              const _SkeletonRow(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Space.a.t12,
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 10.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Row(
        children: [
          const _SkBox(width: 36, height: 36, radius: 6),
          Space.x.t12,
          const Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                FractionallySizedBox(
                  alignment: .centerLeft,
                  widthFactor: 0.72,
                  child: _SkBox(height: 12),
                ),
                SizedBox(height: 8),
                FractionallySizedBox(
                  alignment: .centerLeft,
                  widthFactor: 0.45,
                  child: _SkBox(height: 10),
                ),
              ],
            ),
          ),
          Space.x.t08,
          const _SkBox(width: 16, height: 16, radius: 4),
        ],
      ),
    );
  }
}

/// A single rounded shimmer block. `width: null` fills the available space (used
/// with [FractionallySizedBox] for partial-width text lines).
class _SkBox extends StatelessWidget {
  const _SkBox({this.width, required this.height, this.radius = 4});

  final double? width;
  final double height;
  final int radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Opaque fill; Shimmer overpaints it with the base→highlight gradient.
        color: AppTheme.c.subText,
        borderRadius: radius.radius(),
      ),
    );
  }
}
