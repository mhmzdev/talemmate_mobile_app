part of '../progress.dart';

/// Quiz-history section — eyebrow + "N quizzes · N questions" counter and a
/// bar chart of the last 14 quiz scores with "2 weeks ago / today" labels.
class _QuizHistory extends StatelessWidget {
  const _QuizHistory({
    required this.scores,
    required this.quizCount,
    required this.questionCount,
  });

  final List<int> scores;
  final int quizCount;
  final int questionCount;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            _eyebrow('Quiz history'),
            Text(
              '$quizCount quizzes · $questionCount questions',
              style: AppText.b2.cl(AppTheme.c.subText),
            ),
          ],
        ),
        Space.y.t08,
        Container(
          padding: Space.a.t16,
          decoration: _cardDeco(),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              AppScoreChart(scores: scores),
              Space.y.t08,
              Divider(height: 1, color: AppTheme.c.border),
              Space.y.t08,
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    '2 weeks ago',
                    style: AppText.l1.gm().cl(AppTheme.c.subText),
                  ),
                  Text(
                    'today',
                    style: AppText.l1.gm().cl(AppTheme.c.subText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
