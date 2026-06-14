part of '../tutor.dart';

/// A suggested next question. Tapping sends its [FollowUpPoint.body].
class _FollowUpChip extends StatelessWidget {
  const _FollowUpChip({required this.point});

  final FollowUpPoint point;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return AppTouch(
      onTap: () => ChatCubit.c(context).send(point.body),
      hasSplash: false,
      child: Container(
        padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
        decoration: BoxDecoration(
          color: AppTheme.c.background,
          borderRadius: 20.radius(),
          border: Border.all(color: AppTheme.c.accent.addOpacity(.5)),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.sparkles,
              size: SpaceToken.t12,
              color: AppTheme.c.accent,
            ),
            Space.x.t04,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                point.label,
                style: AppText.b2.cl(AppTheme.c.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
