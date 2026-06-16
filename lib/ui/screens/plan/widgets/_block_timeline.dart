part of '../plan.dart';

/// Vertical timeline of the selected day's study blocks, with a header summary
/// ("Tuesday · 5 blocks · 3.5 hrs") and a calm empty state.
class _BlockTimeline extends StatelessWidget {
  const _BlockTimeline({required this.day});

  final DayPlan day;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final blocks = day.blocks;
    final hrs = (day.totalDurationMinutes / 60).toStringAsFixed(1);
    final header =
        '${day.date.weekdayLong.toUpperCase()} · ${blocks.length} '
        '${blocks.length == 1 ? 'BLOCK' : 'BLOCKS'} · $hrs HRS';

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          header,
          style: AppText.l1b
              .cl(AppTheme.c.subText)
              .copyWith(letterSpacing: 1.2),
        ),
        Space.y.t16,
        if (blocks.isEmpty)
          const PlanPlaceholder(
            message:
                'Nothing scheduled for this day. A good day to rest or '
                'catch up.',
          )
        else
          ...blocks.map((b) => _BlockTile(block: b)),
      ],
    );
  }
}

class _BlockTile extends StatelessWidget {
  const _BlockTile({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final status = block.effectiveStatus();
    final isNow = status == BlockStatus.now;
    final isDone = status == BlockStatus.done;
    final subject = LibraryCubit.c(context).subjectById(block.subjectId);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          // Time column.
          SizedBox(
            width: 48,
            child: Padding(
              padding: Space.t.t12,
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  Text(
                    block.startTime,
                    style: AppText.b2.cl(AppTheme.c.text).w(5),
                  ),
                  Space.y.t04,
                  Text(
                    fmtBlockLength(block.durationMinutes),
                    style: AppText.l1.cl(AppTheme.c.subText),
                  ),
                ],
              ),
            ),
          ),
          Space.x.t12,
          // Spine + dot.
          _Spine(status: status),
          Space.x.t12,
          // Card.
          Expanded(
            child: Opacity(
              opacity: isDone ? 0.55 : 1,
              child: _BlockCard(
                block: block,
                subject: subject,
                isNow: isNow,
                isDone: isDone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The timeline spine line with a status dot.
class _Spine extends StatelessWidget {
  const _Spine({required this.status});

  final BlockStatus status;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final isNow = status == BlockStatus.now;
    final isDone = status == BlockStatus.done;

    return SizedBox(
      width: 13,
      child: Column(
        children: [
          Space.y.t12,
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppTheme.c.primary : AppTheme.c.background,
              border: isDone
                  ? null
                  : Border.all(
                      color: isNow ? AppTheme.c.primary : AppTheme.c.border,
                      width: isNow ? 2 : 1.5,
                    ),
            ),
          ),
          Expanded(child: Container(width: 1.5, color: AppTheme.c.border)),
        ],
      ),
    );
  }
}

/// The block's content card — subject row, title, activities, optional AI note.
class _BlockCard extends StatelessWidget {
  const _BlockCard({
    required this.block,
    required this.subject,
    required this.isNow,
    required this.isDone,
  });

  final StudyBlock block;
  final Subject? subject;
  final bool isNow;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final insight = block.aiInsight;

    return Container(
      margin: Space.b.t16,
      padding: isNow ? Space.a.t12 : Space.v.t08,
      decoration: BoxDecoration(
        color: isNow ? AppTheme.c.specBackground : Colors.transparent,
        borderRadius: 12.radius(),
        border: isNow ? Border.all(color: AppTheme.c.border) : null,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    SubjectSwatch(colorHex: subject?.colorHex),
                    Space.x.t08,
                    Flexible(
                      child: Text(
                        subject?.name ?? 'Study',
                        style: AppText.b2.cl(AppTheme.c.subText).w(5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (isNow)
                Text('Now', style: AppText.b2.cl(AppTheme.c.primary).w(7)),
            ],
          ),
          Space.y.t04,
          Text(
            block.title,
            style: AppText.h3
                .cl(AppTheme.c.text)
                .copyWith(
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
          ),
          Space.y.t04,
          Text(block.activities, style: AppText.b2.cl(AppTheme.c.subText)),
          if (insight != null && insight.trim().isNotEmpty) ...[
            Space.y.t08,
            _AiInsight(text: insight),
          ],
        ],
      ),
    );
  }
}

/// Gold "gold note" chip for a high-impact block.
class _AiInsight extends StatelessWidget {
  const _AiInsight({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      padding: Space.a.t08,
      decoration: BoxDecoration(
        color: AppTheme.c.accent.withValues(alpha: 0.12),
        borderRadius: 8.radius(),
        border: Border.all(color: AppTheme.c.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(
            LucideIcons.sparkles,
            size: SpaceToken.t16,
            color: AppTheme.c.accent,
          ),
          Space.x.t08,
          Expanded(
            child: Text(text, style: AppText.b2.cl(AppTheme.c.text)),
          ),
        ],
      ),
    );
  }
}
