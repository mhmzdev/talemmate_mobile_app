import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_back_button.dart';
import 'package:taleemmate/ui/widgets/core/header/stack_center.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_visuals.dart';
import 'package:taleemmate/ui/widgets/design/plan/regenerate.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';

part '_state.dart';
part 'widgets/_subject_row.dart';
part 'widgets/_add_subject_sheet.dart';

/// Confidence scale — mirrors the onboarding thresholds (`onboarding/utils.dart`,
/// which is `part of` and not importable). Shaky <0.35 · Getting there <0.7.
String _confidenceLabel(double v) {
  if (v < 0.35) return 'Shaky';
  if (v < 0.7) return 'Getting there';
  return 'Confident';
}

Color _confidenceColor(double v) {
  if (v < 0.35) return const Color(0xFFE05252);
  if (v < 0.7) return const Color(0xFFE09A2B);
  return const Color(0xFF4CAF50);
}

/// Tag colours offered when creating a subject (mirrors onboarding's palette).
const _subjectColors = [
  '#6B6B85',
  '#4CAF50',
  '#E05252',
  '#E09A2B',
  '#4A90D9',
  '#9B59B6',
  '#1ABC9C',
];

/// Compact filled input decoration shared by the editor rows + add sheet.
InputDecoration _editorInputDec(String hint) => InputDecoration(
  isDense: true,
  hintText: hint,
  hintStyle: AppText.b2.cl(AppTheme.c.subText),
  contentPadding: Space.sym(SpaceToken.t12, SpaceToken.t08),
  filled: true,
  fillColor: AppTheme.c.specBackground,
  border: OutlineInputBorder(
    borderRadius: 8.radius(),
    borderSide: BorderSide(color: AppTheme.c.border),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: 8.radius(),
    borderSide: BorderSide(color: AppTheme.c.border),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: 8.radius(),
    borderSide: BorderSide(color: AppTheme.c.accent),
  ),
);

/// Selectable round colour swatches (used by the row + add sheet). `.map()` per
/// rule 11 — never a `for` in the widget tree.
class _ColorDots extends StatelessWidget {
  const _ColorDots({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _subjectColors
          .map(
            (hex) => GestureDetector(
              onTap: () => onSelect(hex),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: hex.toColor(),
                  border: Border.all(
                    color: selected == hex
                        ? AppTheme.c.text
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SubjectsEditorScreen extends StatelessWidget {
  const SubjectsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(LibraryCubit.c(context).state.subjects),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  void _save(BuildContext context, _ScreenState state) {
    if (!state.isValid) {
      UIFlash.error(context, 'Give every subject a name first.');
      return;
    }
    // Changes apply only on rebuild — Save always asks; Later discards.
    final library = LibraryCubit.c(context);
    final plan = PlanCubit.c(context);
    final user = UserCubit.c(context).state;
    final uid = user.user?.uid ?? user.userData?.uid;
    PlanRegenerate.confirm(
      context,
      onRebuild: () async {
        await library.commitSubjects(
          upserts: state.upserts,
          removeIds: state.removedIds,
        );
        if (library.state.saveSubject.isFailed) {
          if (context.mounted) {
            UIFlash.error(context, library.state.saveSubject.errorMessage);
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
                center: Text('Subjects', style: AppText.h3),
              ),
            ),
            Space.y.t08,
            Expanded(
              child: ListView(
                padding: Space.sym(SpaceToken.t20, SpaceToken.t16),
                children: [
                  Text(
                    'Edit your courses and how confident you feel. We use this '
                    'to weight your study plan.',
                    style: AppText.b1.cl(AppTheme.c.subText),
                  ),
                  Space.y.t16,
                  ...state.drafts.asMap().entries.map(
                    (e) => Padding(
                      padding: Space.b.t12,
                      child: _SubjectRow(index: e.key, draft: e.value),
                    ),
                  ),
                  _AddSubjectTile(onTap: () => _AddSubjectSheet.show(context)),
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

/// Dashed-look "add a subject" affordance below the list.
class _AddSubjectTile extends StatelessWidget {
  const _AddSubjectTile({required this.onTap});

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
            Text('Add a subject', style: AppText.b1.w(5)),
          ],
        ),
      ),
    );
  }
}
