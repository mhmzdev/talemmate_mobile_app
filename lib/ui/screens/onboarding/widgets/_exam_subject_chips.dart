part of '../onboarding.dart';

class _ExamSubjectChips extends StatelessWidget {
  const _ExamSubjectChips({
    required this.subjects,
    required this.selectedId,
    required this.onSelect,
  });

  final List<_SubjectDraft> subjects;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    if (subjects.isEmpty) {
      return Text(
        'No subjects added yet — go back to step 2.',
        style: AppText.b2.cl(AppTheme.c.subText),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in subjects)
          GestureDetector(
            onTap: () => onSelect(s.id),
            child: Container(
              padding: Space.a.t08 + Space.h.t04,
              decoration: BoxDecoration(
                color: selectedId == s.id
                    ? AppTheme.c.primary
                    : Colors.transparent,
                borderRadius: 30.radius(),
                border: Border.all(
                  color: selectedId == s.id
                      ? AppTheme.c.primary
                      : AppTheme.c.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: _hexColor(s.colorHex),
                    ),
                  ),
                  Space.x.t08,
                  Text(
                    s.nameCtrl.text,
                    style: AppText.b1.cl(
                      selectedId == s.id
                          ? AppTheme.c.background
                          : AppTheme.c.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
