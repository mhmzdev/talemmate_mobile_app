part of '../login.dart';

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppTheme.c.primary.withValues(alpha: 0.12)),
        ),
        Space.x.t12,
        Text('or', style: AppText.b2.cl(AppTheme.c.subText)),
        Space.x.t12,
        Expanded(
          child: Divider(color: AppTheme.c.primary.withValues(alpha: 0.12)),
        ),
      ],
    );
  }
}
