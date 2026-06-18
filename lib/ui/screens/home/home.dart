import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/schedule/day_plan.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/core/header/app_core_header.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_avatar.dart';
import 'package:taleemmate/ui/widgets/design/library/library_item_tile.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_edge_card.dart';
import 'package:taleemmate/ui/widgets/design/plan/ai_reasoning_card.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_placeholder.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_visuals.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';

part '_state.dart';
part 'widgets/_recently_added.dart';
part 'widgets/_tutor_card.dart';
part 'widgets/_daily_reminder.dart';

part 'widgets/_today_plan_card.dart';
part 'widgets/_why_this_plan_card.dart';
part 'widgets/_reschedule_sheet.dart';

part 'widgets/_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final quotesCubit = QuotesCubit.c(context);
    if (quotesCubit.state.today.data == null) {
      quotesCubit.today();
    }

    // Subjects power the block swatches/names; the plan drives both cards.
    final libraryCubit = LibraryCubit.c(context);
    if (libraryCubit.state.subjects.isEmpty) libraryCubit.load();

    final userState = UserCubit.c(context).state;
    final userId = userState.user?.uid ?? userState.userData?.uid;
    if (userId != null) PlanCubit.c(context).watchForUser(userId);
  }

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

    return Screen(
      keyboardHandler: true,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: Space.b.t100 + Space.b.t60,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              const _Header(),
              Space.y.t08,
              BlocBuilder<PlanCubit, PlanState>(
                builder: (context, state) => Padding(
                  padding: Space.h.t20,
                  child: _HomePlanContent(state: state),
                ),
              ),
              Space.y.t24,
              Padding(padding: Space.h.t20, child: const _RecentlyAdded()),
              Space.y.t24,
              Padding(padding: Space.h.t20, child: const _TutorCard()),
              Space.y.t24,
              Padding(padding: Space.h.t20, child: const _DailyReminder()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resolves the home plan area: a loading / failed / empty placeholder, else
/// the "Today's plan" + "Why this plan" cards.
class _HomePlanContent extends StatelessWidget {
  const _HomePlanContent({required this.state});

  final PlanState state;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    if (state.week.isLoading && state.week.data == null) {
      return const PlanPlaceholder(message: 'Loading your plan…', busy: true);
    }
    if (state.week.isFailed) {
      return PlanPlaceholder(
        message: state.week.errorMessage,
        onRetry: () => _retry(context),
      );
    }
    final today = PlanCubit.c(context).today;
    if (today == null || today.blocks.isEmpty) {
      return const PlanPlaceholder(
        message: 'No study blocks scheduled for today. Enjoy the breather.',
      );
    }
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _TodayPlanCard(today: today),
        Space.y.t12,
        const _WhyThisPlanCard(),
      ],
    );
  }

  void _retry(BuildContext context) {
    final userState = UserCubit.c(context).state;
    final userId = userState.user?.uid ?? userState.userData?.uid;
    if (userId != null) PlanCubit.c(context).watchForUser(userId);
  }
}
