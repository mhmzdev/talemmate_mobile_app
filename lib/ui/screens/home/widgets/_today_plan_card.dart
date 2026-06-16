part of '../home.dart';

/// Home "Today's plan" card — progress at a glance plus today's blocks, with a
/// (stubbed) "Begin next block" CTA. Block status is derived from device time
/// via [StudyBlockStatus.effectiveStatus]; nothing is mutated here.
class _TodayPlanCard extends StatelessWidget {
  const _TodayPlanCard({required this.today});

  final DayPlan today;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final blocks = today.blocks;
    final total = blocks.length;
    final done = blocks
        .where((b) => b.effectiveStatus() == BlockStatus.done)
        .length;
    final remaining = total - done;
    final summary = remaining == 0
        ? 'All blocks done — great work today.'
        : '$remaining ${remaining == 1 ? 'block' : 'blocks'} left to go today.';

    return Container(
      padding: Space.a.t16,
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'TODAY\'S PLAN',
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(letterSpacing: 1.2),
              ),
              Text(
                '$done of $total',
                style: AppText.b2.cl(AppTheme.c.subText).gm(),
              ),
            ],
          ),
          Space.y.t08,
          Text(summary, style: AppText.h2.cl(AppTheme.c.subText)),
          Space.y.t16,
          _Meter(fraction: total == 0 ? 0 : done / total),
          Space.y.t20,
          ...blocks.map((b) => _TodayBlockRow(block: b)),
          Space.y.t12,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Begin next block',
                  icon: LucideIcons.arrow_right,
                  mainAxisSize: .max,
                  onTap: () => AppRoutes.plan.pushReplace(context),
                ),
              ),
              Space.x.t08,
              AppIconButton(
                icon: LucideIcons.clock,
                // Reschedule is a later (Focus) plan — placeholder no-op.
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One block row inside [_TodayPlanCard].
class _TodayBlockRow extends StatelessWidget {
  const _TodayBlockRow({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final status = block.effectiveStatus();
    final isDone = status == BlockStatus.done;
    final isNow = status == BlockStatus.now;
    final isGold = !isNow && (block.aiInsight?.trim().isNotEmpty ?? false);
    final subject = LibraryCubit.c(context).subjectById(block.subjectId);
    final subjectName = subject?.name ?? 'Study';

    return Container(
      margin: Space.b.t04,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
        minHeight: SpaceToken.t100,
      ),
      decoration: BoxDecoration(
        color: isNow ? AppTheme.c.subBackground : Colors.transparent,
        borderRadius: 10.radius(),
        border: isNow ? Border.all(color: AppTheme.c.border) : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .stretch,
          children: [
            Container(
              width: 2,
              color: isNow
                  ? AppTheme.c.primary
                  : isGold
                  ? AppTheme.c.accent
                  : Colors.transparent,
            ),
            Expanded(
              child: Padding(
                padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
                child: Row(
                  crossAxisAlignment: .center,
                  children: [
                    _StatusDot(status: status),
                    Space.x.t12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            block.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.b1
                                .cl(
                                  isDone ? AppTheme.c.subText : AppTheme.c.text,
                                )
                                .copyWith(
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                          ),
                          Space.y.t04,
                          Row(
                            children: [
                              SubjectSwatch(colorHex: subject?.colorHex),
                              Space.x.t08,
                              Flexible(
                                child: Text(
                                  '$subjectName · '
                                  '${fmtBlockLength(block.durationMinutes)}',
                                  style: AppText.b2.cl(AppTheme.c.subText),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Space.x.t08,
                    Text(
                      block.startTime,
                      style: AppText.b2.cl(AppTheme.c.subText).gm(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Leading status indicator — filled check (done), thick ring (now), or an
/// open ring (upcoming).
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final BlockStatus status;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    if (status == BlockStatus.done) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.c.primary,
        ),
        child: Icon(
          LucideIcons.check,
          size: SpaceToken.t12,
          color: AppTheme.c.onPrimary,
        ),
      );
    }
    final isNow = status == BlockStatus.now;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isNow ? AppTheme.c.primary : AppTheme.c.border,
          width: isNow ? 2.5 : 1.5,
        ),
      ),
    );
  }
}

/// Thin rounded progress meter.
class _Meter extends StatelessWidget {
  const _Meter({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ClipRRect(
      borderRadius: 999.radius(),
      child: Container(
        height: 6,
        color: AppTheme.c.border,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: fraction.clamp(0.0, 1.0),
          child: Container(color: AppTheme.c.primary),
        ),
      ),
    );
  }
}
