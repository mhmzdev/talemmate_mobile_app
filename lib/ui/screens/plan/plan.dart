import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/schedule/day_plan.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/core/models/schedule/week_plan.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/animations/bottom_animation.dart';
import 'package:taleemmate/ui/widgets/core/header/app_core_header.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_avatar.dart';
import 'package:taleemmate/ui/widgets/design/plan/ai_reasoning_card.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_placeholder.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_visuals.dart';

part '_state.dart';
part 'widgets/_header.dart';
part 'widgets/_week_strip.dart';
part 'widgets/_block_timeline.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  void initState() {
    super.initState();

    final libraryCubit = LibraryCubit.c(context);
    if (libraryCubit.state.subjects.isEmpty) libraryCubit.load();

    final userState = UserCubit.c(context).state;
    final userId = userState.user?.uid ?? userState.userData?.uid;
    if (userId != null) PlanCubit.c(context).watchForUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    // Optional pre-selected day, passed as an ISO-8601 string when arriving
    // from Home's "See what's next" (today fully done → jump to the next day).
    final arg = ModalRoute.of(context)?.settings.arguments;
    final initialDate = arg is String ? DateTime.tryParse(arg) : null;

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(initialDate: initialDate),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Screen(
      keyboardHandler: true,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const _PlanHeader(),
            Space.y.t08,
            Expanded(
              child: BlocBuilder<PlanCubit, PlanState>(
                builder: (context, state) => _PlanContent(state: state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Resolves the plan area: a loading / failed / empty placeholder, else the
/// week strip + reasoning + the selected day's timeline.
class _PlanContent extends StatelessWidget {
  const _PlanContent({required this.state});

  final PlanState state;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final week = state.week.data;

    if (state.week.isLoading && week == null) {
      return Padding(
        padding: Space.h.t20 + Space.t.t12,
        child: const PlanPlaceholder(message: 'Loading your plan…', busy: true),
      );
    }
    if (state.week.isFailed) {
      return Padding(
        padding: Space.h.t20 + Space.t.t12,
        child: PlanPlaceholder(
          message: state.week.errorMessage,
          onRetry: () => _retry(context),
        ),
      );
    }
    if (week == null || week.days.every((d) => d.blocks.isEmpty)) {
      return Padding(
        padding: Space.h.t20 + Space.t.t12,
        child: const PlanPlaceholder(
          message: 'No study plan yet. Finish onboarding to generate one.',
        ),
      );
    }

    // Selected day priority: an explicit tap, else a pre-seeded initialDate
    // (from Home's "See what's next"), else today, else the first day.
    final ss = _ScreenState.s(context, true);
    final todayIndex = week.days.indexWhere((d) => d.isToday);
    int? initialIndex;
    if (ss.selectedDayIndex == null && ss.initialDate != null) {
      final i = week.days.indexWhere((d) => _sameDay(d.date, ss.initialDate!));
      if (i >= 0) initialIndex = i;
    }
    var index =
        ss.selectedDayIndex ?? initialIndex ?? (todayIndex < 0 ? 0 : todayIndex);
    if (index < 0 || index >= week.days.length) index = 0;
    final day = week.days[index];

    return SingleChildScrollView(
      padding: Space.b.t100 + Space.b.t60,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Space.y.t12,
          _WeekStrip(week: week, selectedIndex: index),
          if (week.aiReasoning != null) ...[
            Space.y.t16,
            Padding(
              padding: Space.h.t20,
              child: AiReasoningCard(
                pillText: 'Why this week',
                reasoning: week.aiReasoning!,
              ),
            ),
          ],
          Space.y.t24,
          Padding(
            padding: Space.h.t20,
            child: _BlockTimeline(day: day),
          ),
        ],
      ),
    );
  }

  void _retry(BuildContext context) {
    final userState = UserCubit.c(context).state;
    final userId = userState.user?.uid ?? userState.userData?.uid;
    if (userId != null) PlanCubit.c(context).watchForUser(userId);
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
