part of '../library.dart';

/// One subject's materials under a header (colour dot · serif name · mono code ·
/// count). `section.subject == null` renders the trailing "Unsorted" bucket.
class _SubjectSection extends StatelessWidget {
  const _SubjectSection({required this.section});

  final LibrarySection section;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final subject = section.subject;
    final name = subject?.name ?? 'Unsorted';
    final dotColor = subject != null
        ? subject.colorHex.toColor()
        : AppTheme.c.subText;
    final count = section.items.length;
    final countLabel = '$count ${count == 1 ? 'item' : 'items'}';

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
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: dotColor,
                      ),
                    ),
                    Space.x.t08,
                    Flexible(
                      child: Text(
                        name,
                        style: AppText.h3,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                    if (subject != null) ...[
                      Space.x.t08,
                      Text(
                        subject.code,
                        style: AppText.l1.gm().cl(AppTheme.c.subText),
                      ),
                    ],
                  ],
                ),
              ),
              Space.x.t08,
              Text(countLabel, style: AppText.b2.cl(AppTheme.c.subText)),
            ],
          ),
          Space.y.t12,
          ...section.items.expand(
            (item) => [
              LibraryItemTile(
                item: item,
                status: _MaterialStatus(item: item),
                trailing: AppTouch(
                  onTap: () =>
                      _showMaterialActions(context, item, subject?.name),
                  hasSplash: false,
                  child: Icon(
                    LucideIcons.ellipsis,
                    size: 18,
                    color: AppTheme.c.subText,
                  ),
                ),
              ),
              Space.y.t08,
            ],
          ),
        ],
      ),
    );
  }
}
