part of '../onboarding.dart';

class _ExamRow extends StatelessWidget {
  const _ExamRow({required this.index, required this.draft});

  final int index;
  final _ExamDraft draft;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final dotColor = _hexColor(draft.subjectColorHex);
    final daysAway = draft.date.difference(DateTime.now()).inDays;
    final daysText = daysAway <= 0
        ? 'today'
        : 'in $daysAway ${daysAway == 1 ? 'day' : 'days'}';
    final dateText = '${draft.date.day} ${_monthAbbr[draft.date.month - 1]}';

    return Container(
      padding: Space.sym(SpaceToken.t16, SpaceToken.t16),
      decoration: BoxDecoration(
        color: AppTheme.c.background,
        borderRadius: 10.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: .circle, color: dotColor),
          ),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  draft.subjectName.isEmpty
                      ? 'Exam ${index + 1}'
                      : draft.subjectName,
                  style: AppText.b1b,
                ),
                Text(daysText, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ),
          Text(dateText, style: AppText.b1b),
        ],
      ),
    );
  }
}
