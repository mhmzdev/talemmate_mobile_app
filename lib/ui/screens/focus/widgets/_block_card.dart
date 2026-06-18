part of '../focus.dart';

/// The block's identity + guidance: a subject·walkthrough label, the serif
/// title, and the block's `activities` rendered as the method to follow.
class _BlockCard extends StatelessWidget {
  const _BlockCard({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final subject = LibraryCubit.c(context).subjectById(block.subjectId);
    final subjectName = (subject?.name ?? 'Study').toUpperCase();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          mainAxisAlignment: .center,
          children: [
            SubjectSwatch(colorHex: subject?.colorHex),
            Space.x.t08,
            Text(
              '$subjectName · WALKTHROUGH',
              style: AppText.l1b
                  .cl(AppTheme.c.subText)
                  .copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
        Space.y.t12,
        Text(
          block.title,
          textAlign: .center,
          style: AppText.h1.cl(AppTheme.c.text),
        ),
        Space.y.t16,
        Container(
          padding: Space.a.t16,
          decoration: BoxDecoration(
            color: AppTheme.c.background,
            borderRadius: 14.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Text(
            block.activities,
            style: AppText.b1.cl(AppTheme.c.text),
          ),
        ),
      ],
    );
  }
}
