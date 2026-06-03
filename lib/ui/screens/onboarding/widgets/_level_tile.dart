part of '../onboarding.dart';

class _LevelTile extends StatelessWidget {
  const _LevelTile({
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.text : AppTheme.c.specBackground,
          borderRadius: 8.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2
              .cl(selected ? AppTheme.c.background : AppTheme.c.text)
              .w(6),
          textAlign: .center,
        ),
      ),
    );
  }
}
