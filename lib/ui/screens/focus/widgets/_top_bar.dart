part of '../focus.dart';

/// In-body Focus top bar: close (chevron-down), centered session label with
/// "Block N of M · Do Not Disturb on", and a pause/resume toggle.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final ss = _ScreenState.s(context, true);

    return Padding(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t12),
      child: Row(
        children: [
          AppIconButton(
            icon: LucideIcons.chevron_down,
            onTap: () => AppRoutes.focus.pop(context),
          ),
          Expanded(
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  'FOCUS SESSION',
                  style: AppText.l1b
                      .cl(AppTheme.c.subText)
                      .copyWith(letterSpacing: 1.4),
                ),
                Space.y.t04,
                Text(
                  _subtitle(context),
                  style: AppText.b2.cl(AppTheme.c.subText),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: ss.paused ? LucideIcons.play : LucideIcons.pause,
            onTap: ss.togglePause,
          ),
        ],
      ),
    );
  }

  String _subtitle(BuildContext context) {
    const dnd = 'Do Not Disturb on';
    final blocks = PlanCubit.c(context).today?.blocks ?? const [];
    final i = blocks.indexWhere((b) => b.id == block.id);
    if (i < 0) return dnd;
    return 'Block ${i + 1} of ${blocks.length} · $dnd';
  }
}
