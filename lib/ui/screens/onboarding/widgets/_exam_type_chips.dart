part of '../onboarding.dart';

class _ExamTypeChips extends StatelessWidget {
  const _ExamTypeChips({required this.selected, required this.onSelect});

  final ExamType selected;
  final ValueChanged<ExamType> onSelect;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Wrap(
      children: [
        for (int i = 0; i < ExamType.values.length; i++) ...[
          if (i > 0) Space.x.t08,
          GestureDetector(
            onTap: () => onSelect(ExamType.values[i]),
            child: Container(
              padding: Space.a.t08 + Space.h.t04,
              decoration: BoxDecoration(
                color: selected == ExamType.values[i]
                    ? AppTheme.c.primary
                    : Colors.transparent,
                borderRadius: 8.radius(),
                border: Border.all(
                  color: selected == ExamType.values[i]
                      ? AppTheme.c.primary
                      : AppTheme.c.border,
                ),
              ),
              child: Text(
                ExamType.values[i].name.titleCase,
                textAlign: .center,
                style: AppText.b1
                    .w(6)
                    .cl(
                      selected == ExamType.values[i]
                          ? AppTheme.c.background
                          : AppTheme.c.text,
                    ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
