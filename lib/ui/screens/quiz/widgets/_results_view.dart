part of '../quiz.dart';

/// End-of-quiz results: a score header with percentage, a one-line summary, and
/// a per-question review (the student's answer, the correct answer, and the
/// explanation). "Done" pops back to the originating screen.
class _ResultsView extends StatelessWidget {
  const _ResultsView({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final st = _ScreenState.s(context);
    final questions = quiz.questions;
    final total = questions.length;
    final correct = st.score(questions);
    final pct = total == 0 ? 0 : ((correct / total) * 100).round();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
          child: Row(
            children: [
              AppIconButton(
                icon: LucideIcons.x,
                onTap: () => AppRoutes.quiz.pop(context),
              ),
              Expanded(
                child: Text(
                  'RESULTS',
                  textAlign: .center,
                  style: AppText.l1b
                      .cl(AppTheme.c.subText)
                      .copyWith(letterSpacing: 1.4),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: Space.sym(SpaceToken.t24, SpaceToken.t16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                _ScoreHeader(correct: correct, total: total, pct: pct),
                Space.y.t24,
                Text(
                  'Review',
                  style: AppText.l1b
                      .cl(AppTheme.c.subText)
                      .copyWith(letterSpacing: 1.2),
                ),
                Space.y.t12,
                ...questions.asMap().entries.map(
                  (e) => Padding(
                    padding: Space.b.t12,
                    child: _ReviewRow(
                      number: e.key + 1,
                      question: e.value,
                      selected: st.answers[e.key],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: Space.sym(SpaceToken.t24, SpaceToken.t12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.c.border)),
          ),
          child: AppButton(
            label: 'Done',
            icon: LucideIcons.check,
            size: .large,
            mainAxisSize: .max,
            onTap: () => AppRoutes.quiz.pop(context),
          ),
        ),
      ],
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({
    required this.correct,
    required this.total,
    required this.pct,
  });

  final int correct;
  final int total;
  final int pct;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final passed = pct >= 60;
    final tint = passed ? AppTheme.c.success : AppTheme.c.accent;

    return Container(
      padding: Space.a.t24,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: 16.radius(),
        border: Border.all(color: tint.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const AppAiPill(text: 'QUIZ COMPLETE'),
          Space.y.t12,
          Text('$pct%', style: AppText.h1b.cl(tint)),
          Space.y.t04,
          Text(
            'You got $correct of $total correct.',
            style: AppText.b1.cl(AppTheme.c.text),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.number,
    required this.question,
    required this.selected,
  });

  final int number;
  final QuizQuestion question;
  final int? selected;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final correctIndex = question.correctAnswerIndex;
    final isCorrect = selected != null && selected == correctIndex;
    final skipped = selected == null;
    final tint = isCorrect ? AppTheme.c.success : AppTheme.c.error;
    final yourAnswer = skipped
        ? 'Skipped'
        : _optionText(selected!);
    final correctAnswer = correctIndex == null
        ? '—'
        : _optionText(correctIndex);

    return Container(
      padding: Space.a.t16,
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Icon(
                isCorrect ? LucideIcons.circle_check : LucideIcons.circle_x,
                size: 16,
                color: tint,
              ),
              Space.x.t08,
              Expanded(
                child: Text(
                  '$number. ${question.text}',
                  style: AppText.b1b.cl(AppTheme.c.text),
                ),
              ),
            ],
          ),
          Space.y.t08,
          _AnswerLine(
            label: skipped ? 'You skipped this' : 'Your answer',
            value: yourAnswer,
            color: isCorrect ? AppTheme.c.success : AppTheme.c.error,
          ),
          if (!isCorrect) ...[
            Space.y.t04,
            _AnswerLine(
              label: 'Correct answer',
              value: correctAnswer,
              color: AppTheme.c.success,
            ),
          ],
          if (question.explanation?.trim().isNotEmpty ?? false) ...[
            Space.y.t08,
            Text(
              question.explanation!.trim(),
              style: AppText.b2.cl(AppTheme.c.subText),
            ),
          ],
        ],
      ),
    );
  }

  String _optionText(int index) {
    if (index < 0 || index >= question.options.length) return '—';
    return '${String.fromCharCode(65 + index)}. ${question.options[index]}';
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Row(
      crossAxisAlignment: .start,
      children: [
        Text('$label: ', style: AppText.b2.cl(AppTheme.c.subText)),
        Expanded(child: Text(value, style: AppText.b2b.cl(color))),
      ],
    );
  }
}
