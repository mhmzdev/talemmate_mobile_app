part of '../schedule_editor.dart';

/// A selectable study-window row with a checkbox, label, and time range.
class _WindowTile extends StatelessWidget {
  const _WindowTile({
    required this.label,
    required this.time,
    required this.enabled,
    required this.onToggle,
  });

  final String label;
  final String time;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
        decoration: BoxDecoration(
          color: enabled ? AppTheme.c.subBackground : Colors.transparent,
          borderRadius: 10.radius(),
          border: Border.all(
            color: enabled ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: enabled ? AppTheme.c.text : Colors.transparent,
                borderRadius: 5.radius(),
                border: Border.all(
                  color: enabled ? AppTheme.c.text : AppTheme.c.border,
                  width: 1.5,
                ),
              ),
              child: enabled
                  ? Icon(Icons.check, size: 13, color: AppTheme.c.background)
                  : null,
            ),
            Space.x.t12,
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: AppText.b1b),
                Text(time, style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
