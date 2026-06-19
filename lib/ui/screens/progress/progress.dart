import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/blocs/progress/progress_dashboard.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/core/header/app_core_header.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_edge_card.dart';
import 'package:taleemmate/ui/widgets/design/progress/app_meter.dart';
import 'package:taleemmate/ui/widgets/design/progress/app_score_chart.dart';
import 'package:taleemmate/ui/widgets/design/progress/app_stat.dart';

part '_state.dart';
part 'widgets/_hero_card.dart';
part 'widgets/_mastery_card.dart';
part 'widgets/_quiz_history.dart';
part 'widgets/_insight_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
    _ScreenState.s(context).startIfNeeded(context);

    return Screen(
      keyboardHandler: true,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const _Header(),
            Space.y.t08,
            Expanded(
              child: BlocBuilder<ProgressCubit, ProgressState>(
                builder: (context, state) => _content(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, ProgressState state) {
    final ds = state.dashboard;
    final data = ds.data;
    if (ds.isFailed && data == null) return const _ErrorState();
    if (data == null) return const _LoadingState();
    if (data.isEmpty) return const _EmptyState();
    return _Content(data: data);
  }
}

/// Header — serif greeting + the student's name, "Last 14 days" sub, and a
/// trailing button that re-checks for fresh data.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final user = UserCubit.c(context).state.userData;
    return AppCoreHeader(
      greeting: 'Assalam-o-alaikum,',
      name: user?.fullName,
      subtitle: 'Last 14 days',
      trailing: AppIconButton(
        icon: LucideIcons.refresh_cw,
        onTap: () => _refresh(context),
      ),
    );
  }

  void _refresh(BuildContext context) {
    final s = UserCubit.c(context).state;
    final uid = s.user?.uid ?? s.userData?.uid;
    if (uid != null) ProgressCubit.c(context).loadForUser(uid);
  }
}

/// The assembled dashboard — the five sections, scrollable.
class _Content extends StatelessWidget {
  const _Content({required this.data});

  final ProgressDashboard data;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final hero = data.hero;
    final insight = data.studyInsight;

    return SingleChildScrollView(
      padding: Space.h.t24 + Space.b.t100 + Space.b.t60,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Space.y.t08,
          if (hero != null) ...[_HeroCard(hero: hero), Space.y.t24],
          if (data.subjects.isNotEmpty) ...[
            _eyebrow('Mastery by subject'),
            Space.y.t08,
            _MasteryCard(subjects: data.subjects),
            Space.y.t24,
          ],
          _QuizHistory(
            scores: data.dailyScores,
            quizCount: data.quizCount,
            questionCount: data.questionCount,
          ),
          Space.y.t16,
          AppStatCard(
            stats: [
              AppStat(
                value: '${data.streakDays}',
                unit: 'days',
                label: 'Study streak',
              ),
              AppStat(
                value: data.weekHours.toStringAsFixed(1),
                unit: 'hrs',
                label: 'This week',
              ),
              AppStat(
                value: '${data.avgSessionMinutes}',
                unit: 'min',
                label: 'Avg session',
              ),
            ],
          ),
          if (insight != null && insight.isNotEmpty) ...[
            Space.y.t16,
            _InsightCard(insight: insight),
          ],
        ],
      ),
    );
  }
}

/// Mono/bold uppercase section caption.
Widget _eyebrow(String text) => Text(
  text.toUpperCase(),
  style: AppText.l1b.cl(AppTheme.c.subText).copyWith(letterSpacing: 1.2),
);

/// The shared bordered surface used by the hero / mastery / chart cards.
BoxDecoration _cardDeco() => BoxDecoration(
  color: AppTheme.c.specBackground,
  borderRadius: 14.radius(),
  border: Border.all(color: AppTheme.c.border),
);

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Center(child: CircularProgressIndicator(color: AppTheme.c.primary));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Center(
      child: Padding(
        padding: Space.h.t32,
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(LucideIcons.chart_column, size: 40, color: AppTheme.c.subText),
            Space.y.t16,
            Text(
              'No progress yet',
              style: AppText.h3.fra().cl(AppTheme.c.text),
              textAlign: TextAlign.center,
            ),
            Space.y.t08,
            Text(
              'Finish a quiz or a focus session and your readiness, streak and '
              'quiz history will show up here.',
              style: AppText.b2.cl(AppTheme.c.subText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Center(
      child: Padding(
        padding: Space.h.t32,
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              'Couldn\'t load your progress.',
              style: AppText.b1.cl(AppTheme.c.text),
              textAlign: TextAlign.center,
            ),
            Space.y.t16,
            AppButton(label: 'Try again', onTap: () => _retry(context)),
          ],
        ),
      ),
    );
  }

  void _retry(BuildContext context) {
    final s = UserCubit.c(context).state;
    final uid = s.user?.uid ?? s.userData?.uid;
    if (uid != null) ProgressCubit.c(context).loadForUser(uid);
  }
}
