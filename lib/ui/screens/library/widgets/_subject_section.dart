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

    // Quiz generation needs a subject to ground on + at least one indexed
    // material; the "Unsorted" bucket (subject == null) is never quizzable.
    final indexedItems = subject == null
        ? const <LibraryItem>[]
        : section.items
              .where((i) => i.processingStatus == ProcessingStatus.indexed)
              .toList();

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
              if (subject != null && indexedItems.isNotEmpty) ...[
                Space.x.t08,
                AppTouch(
                  onTap: () => _showQuizScope(context, subject, indexedItems),
                  hasSplash: false,
                  child: Container(
                    padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
                    decoration: BoxDecoration(
                      color: AppTheme.c.accent.withValues(alpha: 0.12),
                      borderRadius: 999.radius(),
                      border: Border.all(
                        color: AppTheme.c.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          LucideIcons.circle_question_mark,
                          size: 13,
                          color: AppTheme.c.accent,
                        ),
                        Space.x.t04,
                        Text(
                          'Quiz',
                          style: AppText.l1b
                              .cl(AppTheme.c.accent)
                              .copyWith(letterSpacing: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  key: ValueKey('material_more_${item.id}'),
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
