part of '../onboarding.dart';

class _TagColorPicker extends StatelessWidget {
  const _TagColorPicker({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Wrap(
      spacing: 10,
      children: [
        for (final hex in _subjectColors)
          GestureDetector(
            onTap: () => onSelect(hex),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: .circle,
                color: hex.toColor(),
                border: Border.all(
                  color: selected == hex ? AppTheme.c.text : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
