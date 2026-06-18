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

                  ..._studyWindows.expand(
                    (w) => [
                      _TimeWindowTile(
                        label: w.$2,
                        time: w.$3,
                        enabled: state.enabledWindowIds.contains(w.$1),
                        onToggle: () => state.toggleWindow(w.$1),
                      ),
                      Space.y.t08,
                    ],
                  ),

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
                    'UPCOMING EXAMS (optional)',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  ...state.exams.asMap().entries.expand(
                    (e) => [
                      _ExamRow(index: e.key, draft: e.value),
                      Space.y.t08,
                    ],
                  ),
                  _AddTile(
                    label: 'Add exam',
                    onTap: () => _openAddExamModal(context, state),
                  ),
                  Space.y.t24,
                ],
              ),
            ),
          ),
          Space.y.t12,
          AppButton(
            label: 'Continue',
            onTap: () {
              if (state.isStep3Valid) state.nextPage();
            },
            state: state.isStep3Valid ? .def : .disabled,
            mainAxisSize: .max,
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
