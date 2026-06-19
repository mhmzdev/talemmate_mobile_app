part of '../quiz.dart';

/// A single MCQ option row with an A/B/C/D letter chip. Before reveal it's a
/// plain tappable card; once revealed it shows the correct option (green) and,
/// if the student picked wrong, their pick (rose).
class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.index,
    required this.text,
    required this.correctIndex,
    required this.selected,
    required this.revealed,
    required this.onTap,
  });

  final int index;
  final String text;
  final int? correctIndex;
  final int? selected;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final isCorrect = revealed && index == correctIndex;
    final isWrongPicked = revealed && index == selected && index != correctIndex;

    final Color border;
    final Color bg;
    if (isCorrect) {
      border = AppTheme.c.success;
      bg = AppTheme.c.success.withValues(alpha: 0.06);
    } else if (isWrongPicked) {
      border = AppTheme.c.error;
      bg = AppTheme.c.error.withValues(alpha: 0.05);
    } else {
      border = AppTheme.c.border;
      bg = AppTheme.c.specBackground;
    }

    final chipBg = isCorrect
        ? AppTheme.c.success
        : isWrongPicked
        ? AppTheme.c.error
        : AppTheme.c.subBackground;
    final chipFg = (isCorrect || isWrongPicked)
        ? AppTheme.c.background
        : AppTheme.c.text;

    return AbsorbPointer(
      absorbing: revealed,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: Space.a.t12,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: 14.radius(),
            border: Border.all(
              color: border,
              width: (isCorrect || isWrongPicked) ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: 8.radius(),
                ),
                child: isCorrect
                    ? Icon(LucideIcons.check, size: 14, color: chipFg)
                    : isWrongPicked
                    ? Icon(LucideIcons.x, size: 14, color: chipFg)
                    : Text(
                        String.fromCharCode(65 + index),
                        style: AppText.b2b.cl(chipFg),
                      ),
              ),
              Space.x.t12,
              Expanded(
                child: Padding(
                  padding: Space.t.t04,
                  child: Text(text, style: AppText.b1.cl(AppTheme.c.text)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
