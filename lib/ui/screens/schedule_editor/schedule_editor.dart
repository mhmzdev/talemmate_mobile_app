import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/constants/study_windows.dart';
import 'package:taleemmate/core/models/schedule/schedule.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_back_button.dart';
import 'package:taleemmate/ui/widgets/core/header/stack_center.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/library/subject_chips.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_choice_chip.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_visuals.dart';
import 'package:taleemmate/ui/widgets/design/plan/regenerate.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';

part '_state.dart';
part 'widgets/_window_tile.dart';
part 'widgets/_exam_row.dart';
part 'widgets/_add_exam_sheet.dart';

/// Short month abbreviations for exam-date display (onboarding's `_monthAbbr`
/// lives in a `part of` file and isn't importable).
const _monthAbbr = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class ScheduleEditorScreen extends StatelessWidget {
  const ScheduleEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final plan = PlanCubit.c(context);
    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(
        schedule: plan.state.schedule,
        exams: plan.exams,
        subjects: LibraryCubit.c(context).state.subjects,
      ),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  void _save(BuildContext context, _ScreenState state) {
    if (!state.hasSchedule) {
      UIFlash.error(context, 'Finish onboarding to set up a schedule first.');
      return;
    }
    if (!state.isValid) {
      UIFlash.error(context, 'Keep at least one study window.');
      return;
    }
    // Changes apply only on rebuild — Save always asks; Later discards.
    final plan = PlanCubit.c(context);
    final user = UserCubit.c(context).state;
    final uid = user.user?.uid ?? user.userData?.uid;
    PlanRegenerate.confirm(
      context,
      onRebuild: () async {
        await plan.commitSchedule(
          dailyTargetHours: state.dailyTargetHours,
          enabledWindowIds: state.enabledWindowIds,
          upsertExams: state.upsertExams,
          removeExamIds: state.removeExamIds,
        );
        if (plan.state.saveSchedule.isFailed) {
          if (context.mounted) {
            UIFlash.error(context, plan.state.saveSchedule.errorMessage);
          }
          return;
        }
        if (uid != null) plan.generate(uid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Screen(
      keyboardHandler: true,
      overlayBuilders: const [PlanRebuildLoader()],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: Space.h.t20 + Space.t.t12,
              child: StackCenter(
                onLeft: const AppBackButton(),
                center: Text('Schedule & exams', style: AppText.h3),
              ),
            ),
            Space.y.t08,
            Expanded(
              child: ListView(
                padding: Space.sym(SpaceToken.t20, SpaceToken.t16),
                children: [
                  Text(
                    'STUDY WINDOWS',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  ...kStudyWindowCatalog.map(
                    (w) => Padding(
                      padding: Space.b.t08,
                      child: _WindowTile(
                        label: w.label,
                        time: '${w.startTime}–${w.endTime}',
                        enabled: state.isWindowEnabled(w.id),
                        onToggle: () => state.toggleWindow(w.id),
                      ),
                    ),
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
                  Space.y.t08,
                  Text(
                    'UPCOMING EXAMS',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  ...state.examDrafts.asMap().entries.map(
                    (e) => Padding(
                      padding: Space.b.t08,
                      child: _ExamRow(index: e.key, draft: e.value),
                    ),
                  ),
                  _AddExamTile(onTap: () => _AddExamSheet.show(context)),
                ],
              ),
            ),
            Padding(
              padding: Space.a.t20,
              child: AppButton(
                label: 'Save changes',
                mainAxisSize: .max,
                size: .large,
                onTap: () => _save(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Add exam" affordance below the exam list.
class _AddExamTile extends StatelessWidget {
  const _AddExamTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return AppTouch(
      onTap: onTap,
      hasSplash: false,
      child: Container(
        padding: Space.v.t16,
        alignment: .center,
        decoration: BoxDecoration(
          color: AppTheme.c.subBackground,
          borderRadius: 10.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(LucideIcons.plus, size: SpaceToken.t20, color: AppTheme.c.text),
            Space.x.t08,
            Text('Add an exam', style: AppText.b1.w(5)),
          ],
        ),
      ),
    );
  }
}
