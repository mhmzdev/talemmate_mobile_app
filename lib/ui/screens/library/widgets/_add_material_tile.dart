part of '../library.dart';

/// The "Add new material" affordance at the foot of the list. Opens the add
/// sheet (subject + Files/Photos/Camera) — wired in Phase 4.
class _AddMaterialTile extends StatelessWidget {
  const _AddMaterialTile();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppTouch(
      onTap: () => _showAddMaterial(context),
      hasSplash: false,
      child: Container(
        padding: Space.a.t16,
        decoration: BoxDecoration(
          color: AppTheme.c.subBackground,
          borderRadius: 14.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: .center,
              decoration: BoxDecoration(
                color: AppTheme.c.primary,
                borderRadius: 10.radius(),
              ),
              child: Icon(
                LucideIcons.plus,
                size: 20,
                color: AppTheme.c.background,
              ),
            ),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Add new material', style: AppText.b1.w(5)),
                  Space.y.t04,
                  Text(
                    'PDF · Photo of notes · Slide deck · Voice memo',
                    style: AppText.b2.cl(AppTheme.c.subText),
                  ),
                ],
              ),
            ),
            Space.x.t08,
            Icon(
              LucideIcons.arrow_right,
              size: 18,
              color: AppTheme.c.subText,
            ),
          ],
        ),
      ),
    );
  }
}
