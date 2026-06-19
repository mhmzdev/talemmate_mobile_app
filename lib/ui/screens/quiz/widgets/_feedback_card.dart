part of '../quiz.dart';

/// Inline feedback shown once a question is revealed: a Correct / Not quite
/// verdict, the AI explanation, and the source citation (when grounded).
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.question, required this.isCorrect});

  final QuizQuestion question;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final explanation = question.explanation?.trim() ?? '';
    final citation = question.citation?.trim() ?? '';

    return Container(
      padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              const AppAiPill(text: 'FEEDBACK'),
              Space.x.t08,
              Text(
                isCorrect ? 'Correct' : 'Not quite',
                style: AppText.b2b.cl(
                  isCorrect ? AppTheme.c.success : AppTheme.c.error,
                ),
              ),
            ],
          ),
          if (explanation.isNotEmpty) ...[
            Space.y.t08,
            Text(explanation, style: AppText.b1.cl(AppTheme.c.text)),
          ],
          if (citation.isNotEmpty) ...[
            Space.y.t12,
            Row(
              crossAxisAlignment: .start,
              children: [
                Icon(
                  LucideIcons.book_open,
                  size: 14,
                  color: AppTheme.c.subText,
                ),
                Space.x.t08,
                Expanded(
                  child: Text(
                    citation,
                    style: AppText.b2.cl(AppTheme.c.subText),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
