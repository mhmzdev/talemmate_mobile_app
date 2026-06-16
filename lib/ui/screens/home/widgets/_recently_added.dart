part of '../home.dart';

/// Home "Recently added" — the latest uploaded materials as compact tiles, with
/// a "See all" link into the Library. Hidden until the library has items.
class _RecentlyAdded extends StatelessWidget {
  const _RecentlyAdded();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final items = [...?LibraryCubit.c(context, true).state.load.data]
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    if (items.isEmpty) return const SizedBox.shrink();
    final recent = items.take(4).toList();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'RECENTLY ADDED',
              style: AppText.l1b
                  .cl(AppTheme.c.subText)
                  .copyWith(letterSpacing: 1.2),
            ),
            GestureDetector(
              onTap: () => AppRoutes.library.pushReplace(context),
              child: Text(
                'See all →',
                style: AppText.b2.cl(AppTheme.c.subText),
              ),
            ),
          ],
        ),
        Space.y.t12,
        SingleChildScrollView(
          scrollDirection: .horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: .start,
              children: recent
                  .asMap()
                  .entries
                  .expand(
                    (e) => [
                      if (e.key > 0) Space.x.t12,
                      _UploadTile(item: e.value),
                    ],
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

/// A compact uploaded-material card — colored thumbnail with the kind tag, then
/// name + size/pages meta.
class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.item});

  final LibraryItem item;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final pages = item.indexedPageCount;
    final meta = pages != null && pages > 0
        ? '${item.fileSize.readableSize} · $pages pages'
        : item.fileSize.readableSize;
    // Match the Library: the thumbnail colour comes from the material kind
    // (PDF/IMG/NOTE…), not the subject colour.
    final color = item.kind.badgeColor;

    return Container(
      padding: Space.a.t12,
      constraints: BoxConstraints(
        maxWidth: SpaceToken.t100 + SpaceToken.t32,
      ),
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            height: 64,
            alignment: .topLeft,
            padding: Space.a.t08,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.85),
              borderRadius: 8.radius(),
            ),
            child: Text(
              item.kind.name.toUpperCase(),
              style: AppText.l1
                  .cl(AppColors.onPrimary)
                  .gm()
                  .copyWith(letterSpacing: 1.2),
            ),
          ),
          Space.y.t08,
          Text(
            item.name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.b2.cl(AppTheme.c.text).fra(),
          ),
          Space.y.t04,
          Text(
            meta,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.l1.cl(AppTheme.c.subText),
          ),
        ],
      ),
    );
  }
}
