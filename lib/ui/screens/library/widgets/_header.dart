part of '../library.dart';

/// Library top bar — serif title + "N documents · size" subtitle, with a
/// decorative search affordance on the right (the search field lives below).
class _Header extends StatelessWidget {
  const _Header({required this.count, required this.totalSize});

  final int count;
  final int totalSize;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final noun = count == 1 ? 'document' : 'documents';

    return Padding(
      padding: Space.sym(SpaceToken.t24, SpaceToken.t12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Library', style: AppText.h1),
          Space.y.t04,
          Text(
            '$count $noun · ${totalSize.readableSize}',
            style: AppText.b2
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}
