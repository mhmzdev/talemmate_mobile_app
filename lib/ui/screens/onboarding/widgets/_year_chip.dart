part of '../onboarding.dart';

class _YearChip extends StatelessWidget {
  const _YearChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppProps.medium,
        padding: Space.sym(SpaceToken.t16, SpaceToken.t04),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.accent : Colors.transparent,
          borderRadius: 20.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.accent : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2.cl(selected ? Colors.white : AppTheme.c.text),
        ),
      ),
    );
  }
}
