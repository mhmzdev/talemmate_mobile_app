import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/blocs/quiz/cubit.dart';
import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/core/models/quiz/quiz.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';
import 'package:taleemmate/utils/flash.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/design/alerts/app_alert_base.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/full_screen_loader/full_screen_loader.dart';

part 'listeners/_generate.dart';
part 'widgets/_question_view.dart';
part 'widgets/_quiz_option.dart';
part 'widgets/_results_view.dart';
part 'widgets/_progress_bar.dart';
part 'widgets/_feedback_card.dart';
part '_state.dart';

/// Generation params passed as the `/quiz` route argument: which subject (and
/// optionally topic) to build the quiz from. [sourceItemIds] scopes grounding to
/// specific materials — one (single-material quiz), several (a chosen subset), or
/// null/empty (the whole subject's indexed materials).
class QuizArgs {
  const QuizArgs({required this.subjectId, this.topicId, this.sourceItemIds});

  final String subjectId;
  final String? topicId;
  final List<String>? sourceItemIds;

  factory QuizArgs.fromMap(Map<String, dynamic> map) => QuizArgs(
    subjectId: map['subjectId'] as String,
    topicId: map['topicId'] as String?,
    sourceItemIds: (map['sourceItemIds'] as List?)
        ?.whereType<String>()
        .toList(),
  );
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final raw = ModalRoute.of(context)!.settings.arguments;
    final args = raw is QuizArgs
        ? raw
        : QuizArgs.fromMap(raw as Map<String, dynamic>);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(
        subjectId: args.subjectId,
        topicId: args.topicId,
        sourceItemIds: args.sourceItemIds,
      ),
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

    // While a generated quiz is being taken, intercept back (system gesture or
    // header arrow) to confirm before discarding progress. Loading, failure and
    // the results phase pop freely.
    final inQuiz =
        QuizCubit.c(context, true).state.generate.isSuccess &&
        _ScreenState.s(context, true).phase == QuizPhase.taking;

    return Screen(
      scaffoldBackgroundColor: AppTheme.c.background,
      canPop: !inQuiz,
      onBackPressed: inQuiz ? () => _confirmExitQuiz(context) : null,
      child: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<QuizCubit, QuizState>(
              buildWhen: (a, b) => a.generate != b.generate,
              builder: (context, state) {
                final quiz = state.generate.data;
                if (state.generate.isFailed) return const _GenerateError();
                if (quiz == null || quiz.questions.isEmpty) {
                  return const SizedBox.shrink();
                }
                final phase = _ScreenState.s(context, true).phase;
                return phase == QuizPhase.results
                    ? _ResultsView(quiz: quiz)
                    : _QuestionView(quiz: quiz);
              },
            ),
            const _GenerateListener(),
          ],
        ),
      ),
    );
  }
}

/// Failure state for generation — a calm retry, shown when [QuizCubit.generate]
/// faults (the listener also surfaces a flash).
class _GenerateError extends StatelessWidget {
  const _GenerateError();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.a.t24,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            LucideIcons.circle_alert,
            size: SpaceToken.t32,
            color: AppTheme.c.subText,
          ),
          Space.y.t16,
          Text(
            'Couldn\'t build your quiz',
            style: AppText.h3,
            textAlign: .center,
          ),
          Space.y.t08,
          Text(
            'Please check your connection and try again.',
            style: AppText.b2.cl(AppTheme.c.subText),
            textAlign: .center,
          ),
          Space.y.t24,
          AppButton(
            label: 'Try again',
            icon: LucideIcons.refresh_cw,
            size: .large,
            mainAxisSize: .max,
            onTap: () => _ScreenState.s(context).retry(context),
          ),
          Space.y.t12,
          AppButton(
            label: 'Go back',
            style: .creamy,
            size: .large,
            mainAxisSize: .max,
            onTap: () => AppRoutes.quiz.pop(context),
          ),
        ],
      ),
    );
  }
}

/// Confirms before abandoning a quiz in progress (answers aren't persisted as a
/// resumable quiz). Used by the header back arrow and the system back gesture.
void _confirmExitQuiz(BuildContext context) {
  showAppAlert(
    context,
    routeName: 'quiz-exit-confirm',
    icon: const Icon(LucideIcons.circle_alert),
    title: 'Leave the quiz?',
    subtitle: 'Your progress on this quiz won\'t be saved.',
    actions: [
      AppAlertAction(label: 'Keep going', onTap: () => Navigator.pop(context)),
      AppAlertAction(
        label: 'Leave',
        isDestructive: true,
        onTap: () {
          Navigator.pop(context); // close the alert
          AppRoutes.quiz.pop(context); // leave the quiz
        },
      ),
    ],
  );
}
