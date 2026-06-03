// ignore: unused_import
import 'dart:async'; // used by _state.dart part (Timer)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_back_button.dart';
import 'package:taleemmate/ui/widgets/core/header/stack_center.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:uuid/uuid.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/blocs/onboarding/cubit.dart';
import 'package:taleemmate/core/models/onboarding/onboarding_data.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/core/models/schedule/schedule.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/design/full_screen_loader/full_screen_loader.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/headless/keep_alive_page_view.dart';
import 'package:taleemmate/utils/flash.dart';

part 'models/_subject_draft.dart';
part 'models/_exam_draft.dart';

part 'static/_form_data.dart';
part 'static/_form_keys.dart';
part 'static/_data.dart';

part 'utils.dart';
part '_state.dart';
part 'listeners/_complete.dart';

part 'pages/_1_about_you.dart';
part 'pages/_2_subjects.dart';
part 'pages/_3_schedule.dart';
part 'pages/_4_material.dart';

part 'widgets/_institution_chip.dart';
part 'widgets/_level_tile.dart';
part 'widgets/_year_chip.dart';
part 'widgets/_goal_card.dart';
part 'widgets/_goal_list.dart';
part 'widgets/_tutor_preview.dart';
part 'widgets/_subject_entry.dart';
part 'widgets/_add_tile.dart';
part 'widgets/_time_window_tile.dart';
part 'widgets/_exam_row.dart';
part 'widgets/_source_chip.dart';
part 'widgets/_so_far_card.dart';
part 'widgets/_file_item.dart';
part 'widgets/_modal_header.dart';
part 'widgets/_modal_text_field.dart';
part 'widgets/_tag_color_picker.dart';
part 'widgets/_subject_suggestions.dart';
part 'widgets/_exam_subject_chips.dart';
part 'widgets/_exam_type_chips.dart';
part 'widgets/_add_subject_modal.dart';
part 'widgets/_add_exam_modal.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context);

    return Screen(
      keyboardHandler: true,
      padding: Space.v.t20,
      overlayBuilders: const [_CompleteListener()],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: Space.h.t20,
              child: const _StepHeader(),
            ),
            Space.y.t24,
            Padding(
              padding: Space.h.t20,
              child: const _StepProgressBar(),
            ),
            Space.y.t24,
            Expanded(
              child: PageView(
                controller: state.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: state.updateCurrentStep,
                children: const [
                  _StepAboutYou(),
                  _StepSubjects(),
                  _StepSchedule(),
                  _StepMaterial(),
                ].map((e) => KeepAlivePageView(child: e)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);
    final step = state.currentStep;
    final isLast = step == 3;

    return StackCenter(
      onLeft: AppBackButton(
        onTap: () {
          if (step == 0) {
            AppRoutes.createAccount.pushReplace(context);
          } else {
            state.prevPage();
          }
        },
      ),
      center: Text(
        '${(step + 1).toString().padLeft(2, '0')} / 04',
        style: AppText.l1b.cl(AppTheme.c.subText).copyWith(letterSpacing: 1.0),
      ),
      onRight: step > 0
          ? AppTouch(
              onTap: isLast ? () => state.finish(context) : state.nextPage,
              child: Text(
                isLast ? 'Skip for now' : 'Skip',
                style: AppText.b2.cl(AppTheme.c.subText).w(6),
              ),
            )
          : null,
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context, true);
    final currentStep = screenState.currentStep;

    return Row(
      children: [
        for (int i = 0; i < 4; i++) ...[
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: i <= currentStep
                    ? AppTheme.c.primary
                    : AppTheme.c.border,
                borderRadius: 2.radius(),
              ),
            ),
          ),
          if (i < 3) Space.x.t04,
        ],
      ],
    );
  }
}
