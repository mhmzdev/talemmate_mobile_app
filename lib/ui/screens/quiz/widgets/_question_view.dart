part of '../quiz.dart';

/// The quiz-taking flow for the current question: header + segmented progress,
/// the AI-source pill + display stopwatch, the question stem, the options with
/// inline correct/wrong feedback, and the Skip / Next footer.
class _QuestionView extends StatelessWidget {
  const _QuestionView({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final st = _ScreenState.s(context, true);
    st.startClock();

    final total = quiz.questions.length;
    final cursor = st.cursor.clamp(0, total - 1);
    final question = quiz.questions[cursor];
    final isLast = cursor == total - 1;
    final pickedCorrect = st.selected == question.correctAnswerIndex;
    final hasFeedback = (question.explanation?.trim().isNotEmpty ?? false) ||
        (question.citation?.trim().isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        // --- header ---
        Padding(
          padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
          child: Row(
            children: [
              AppIconButton(
                key: const ValueKey('quiz_back'),
                icon: LucideIcons.arrow_left,
                onTap: () => _confirmExitQuiz(context),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      'QUIZ',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.4),
                    ),
                    Space.y.t04,
                    Text(
                      'Question ${cursor + 1} of $total',
                      style: AppText.b2.cl(AppTheme.c.text),
                    ),
                  ],
                ),
              ),
              // Balances the leading icon button so the label stays centred.
              const SizedBox(width: 48),
            ],
          ),
        ),
        Padding(padding: Space.h.t24, child: _ProgressBar(total: total, current: cursor)),

        // --- scrollable question body ---
        Expanded(
          child: SingleChildScrollView(
            padding: Space.sym(SpaceToken.t24, SpaceToken.t16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppAiPill(text: quiz.sourceLabel ?? 'AI QUIZ'),
                    Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 13,
                          color: AppTheme.c.subText,
                        ),
                        Space.x.t04,
                        Text(
                          st.elapsedLabel,
                          style: AppText.b2.cl(AppTheme.c.subText),
                        ),
                      ],
                    ),
                  ],
                ),
                Space.y.t12,
                Text(
                  question.text,
                  style: AppText.h2.copyWith(height: 1.3),
                ),
                Space.y.t04,
                Text(
                  'Single answer · ${question.markValue} mark',
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
                Space.y.t16,
                ...question.options.asMap().entries.map(
                  (e) => Padding(
                    padding: Space.b.t08,
                    child: _QuizOption(
                      index: e.key,
                      text: e.value,
                      correctIndex: question.correctAnswerIndex,
                      selected: st.selected,
                      revealed: st.revealed,
                      onTap: () => _pick(context, question, e.key),
                    ),
                  ),
                ),
                if (st.revealed && hasFeedback) ...[
                  Space.y.t08,
                  _FeedbackCard(question: question, isCorrect: pickedCorrect),
                ],
              ],
            ),
          ),
        ),

        // --- footer ---
        Container(
          padding: Space.sym(SpaceToken.t24, SpaceToken.t12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.c.border)),
          ),
          child: Row(
            children: [
              AppButton(
                label: 'Skip',
                style: .creamy,
                onTap: st.revealed ? null : () => _skip(context, question),
              ),
              Space.x.t08,
              Expanded(
                child: AppButton(
                  label: isLast ? 'See results' : 'Next question',
                  icon: LucideIcons.arrow_right,
                  mainAxisSize: .max,
                  state: st.revealed ? .def : .disabled,
                  onTap: st.revealed ? () => _finish(context, total) : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Advances; on the taking→results transition, records the quiz result
  /// (a `DailyScore` + streak bump) best-effort so the Progress tab reflects it.
  void _finish(BuildContext context, int total) {
    final st = _ScreenState.s(context);
    st.next(total);
    if (st.phase != QuizPhase.results) return;
    final uid = st.userId;
    if (uid == null) return;
    ProgressCubit.c(context).recordQuizResult(
      userId: uid,
      subjectId: quiz.subjectId,
      score: st.score(quiz.questions),
      total: quiz.questions.length,
    );
  }

  void _pick(BuildContext context, QuizQuestion question, int index) {
    final st = _ScreenState.s(context);
    if (st.revealed) return;
    st.pick(index);
    final uid = st.userId;
    if (uid != null) {
      QuizCubit.c(context).recordAnswer(
        quizId: quiz.id,
        userId: uid,
        question: question,
        selectedIndex: index,
      );
    }
  }

  void _skip(BuildContext context, QuizQuestion question) {
    final st = _ScreenState.s(context);
    if (st.revealed) return;
    st.skip();
    final uid = st.userId;
    if (uid != null) {
      QuizCubit.c(context).recordAnswer(
        quizId: quiz.id,
        userId: uid,
        question: question,
        selectedIndex: null,
      );
    }
  }
}
