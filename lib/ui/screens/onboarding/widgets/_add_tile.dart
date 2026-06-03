part of '../onboarding.dart';

// Dashed "add" row reused by the subjects and schedule steps.
class _AddTile extends StatelessWidget {
  const _AddTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
        decoration: BoxDecoration(
          borderRadius: 10.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.add, size: 18, color: AppTheme.c.subText),
            Space.x.t08,
            Text(label, style: AppText.b1.cl(AppTheme.c.subText)),
          ],
        ),
      ),
    );
  }
}
