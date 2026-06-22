part of '../schedule_editor.dart';

/// One exam row: subject swatch + name, days-until, date, and a remove button.
class _ExamRow extends StatelessWidget {
  const _ExamRow({required this.index, required this.draft});

  final int index;
  final _ExamDraft draft;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context);
    final subject = state.subjectById(draft.subjectId);
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
          SubjectSwatch(colorHex: subject?.colorHex ?? '#6B6B85', size: 10),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  subject?.name ?? draft.label ?? 'Exam ${index + 1}',
                  style: AppText.b1b,
                ),
                Text(daysText, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ),
          Text(dateText, style: AppText.b1b),
          Space.x.t12,
          AppTouch(
            onTap: () => state.removeExamAt(index),
            hasSplash: false,
            child: Icon(
              LucideIcons.x,
              size: SpaceToken.t20,
              color: AppTheme.c.subText,
            ),
          ),
        ],
      ),
    );
  }
}
