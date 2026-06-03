part of '../onboarding.dart';

class _StepSchedule extends StatelessWidget {
  const _StepSchedule();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Padding(
      padding: Space.h.t20,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'STEP 3 OF 4 · YOUR RHYTHM',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  Text('When do you study best?', style: AppText.h1),
                  Space.y.t04,
                  Text(
                    'Pick your preferred windows and I\'ll schedule sessions only when you\'re available.',
                    style: AppText.b1.cl(AppTheme.c.subText),
                  ),
                  Space.y.t24,

                  for (final (id, label, time) in _studyWindows) ...[
                    _TimeWindowTile(
                      label: label,
                      time: time,
                      enabled: state.enabledWindowIds.contains(id),
                      onToggle: () => state.toggleWindow(id),
                    ),
                    Space.y.t08,
                  ],

                  Space.y.t08,

                  Text(
                    'DAILY TARGET',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Row(
                    children: [
                      Text(
                        'Study time per day',
                        style: AppText.b2.cl(AppTheme.c.subText),
                      ),
                      Space.xm,
                      Text(
                        '${state.dailyTargetHours.toStringAsFixed(1)} hrs',
                        style: AppText.h3.w(6),
                      ),
                    ],
                  ),
                  Slider(
                    padding: Space.v.t16,
                    value: state.dailyTargetHours,
                    min: 0.5,
                    max: 6.0,
                    divisions: 11,
                    onChanged: state.setDailyTarget,
                    activeColor: AppTheme.c.accent,
                  ),

                  Space.y.t16,

                  Text(
                    'UPCOMING EXAMS',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  for (int i = 0; i < state.exams.length; i++) ...[
                    _ExamRow(index: i, draft: state.exams[i]),
                    Space.y.t08,
                  ],
                  GestureDetector(
                    onTap: () => _openAddExamModal(context, state),
                    child: Container(
                      padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
                      decoration: BoxDecoration(
                        borderRadius: 10.radius(),
                        border: Border.all(color: AppTheme.c.border),
                      ),
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.add, size: 18, color: AppTheme.c.subText),
                          Space.x.t08,
                          Text(
                            'Add exam',
                            style: AppText.b1.cl(AppTheme.c.subText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Space.y.t24,
                ],
              ),
            ),
          ),
          Space.y.t12,
          AppButton(
            label: 'Continue',
            onTap: state.nextPage,
            mainAxisSize: .max,
            size: .large,
          ),
        ],
      ),
    );
  }

  void _openAddExamModal(BuildContext context, _ScreenState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/add-exam'),
      builder: (_) => _AddExamModal(
        subjects: state.subjects,
        onAdd: state.addExamDraft,
      ),
    );
  }
}

class _TimeWindowTile extends StatelessWidget {
  const _TimeWindowTile({
    required this.label,
    required this.time,
    required this.enabled,
    required this.onToggle,
  });

  final String label;
  final String time;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
        decoration: BoxDecoration(
          color: enabled ? AppTheme.c.subBackground : Colors.transparent,
          borderRadius: 10.radius(),
          border: Border.all(
            color: enabled ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: enabled ? AppTheme.c.text : Colors.transparent,
                borderRadius: 5.radius(),
                border: Border.all(
                  color: enabled ? AppTheme.c.text : AppTheme.c.border,
                  width: 1.5,
                ),
              ),
              child: enabled
                  ? Icon(Icons.check, size: 13, color: AppTheme.c.background)
                  : null,
            ),
            Space.x.t12,
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: AppText.b1b),
                Text(time, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamRow extends StatelessWidget {
  const _ExamRow({required this.index, required this.draft});

  final int index;
  final _ExamDraft draft;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final dotColor = Color(
      int.parse(draft.subjectColorHex.replaceFirst('#', '0xFF')),
    );
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
            decoration: BoxDecoration(
              shape: .circle,
              color: dotColor,
            ),
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
