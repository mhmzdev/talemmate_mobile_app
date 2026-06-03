part of '../onboarding.dart';

class _InstitutionChip extends StatelessWidget {
  const _InstitutionChip({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.text : AppTheme.c.subBackground,
          borderRadius: 20.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2.cl(
            selected ? AppTheme.c.background : AppTheme.c.text,
          ),
        ),
      ),
    );
  }
}
