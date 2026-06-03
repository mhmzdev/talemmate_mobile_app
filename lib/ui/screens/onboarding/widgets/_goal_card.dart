part of '../onboarding.dart';

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goalKey,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final OnboardingGoal goalKey;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.subBackground : Colors.transparent,
          borderRadius: 10.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.accent : AppTheme.c.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: .circle,
                border: Border.all(
                  color: selected ? AppTheme.c.accent : AppTheme.c.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: AppTheme.c.accent,
                        ),
                      ),
                    )
                  : null,
            ),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: AppText.b1b),
                  Text(subtitle, style: AppText.b2.cl(AppTheme.c.subText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
