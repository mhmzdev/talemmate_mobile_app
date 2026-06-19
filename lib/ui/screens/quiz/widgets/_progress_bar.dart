part of '../quiz.dart';

/// Segmented progress for the quiz: one bar per question — done (ink), current
/// (gold), upcoming (faint).
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Row(
      children: List.generate(total, (i) => i)
          .map(
            (i) => Expanded(
              child: Padding(
                padding: Space.r.t04,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: 2.radius(),
                    color: i < current
                        ? AppTheme.c.primary
                        : i == current
                        ? AppTheme.c.accent
                        : AppTheme.c.text.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
