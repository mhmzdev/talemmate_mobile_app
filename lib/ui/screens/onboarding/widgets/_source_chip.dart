part of '../onboarding.dart';

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            borderRadius: 12.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: AppTheme.c.text),
              Space.y.t08,
              Text(label, style: AppText.b2),
            ],
          ),
        ),
      ),
    );
  }
}
