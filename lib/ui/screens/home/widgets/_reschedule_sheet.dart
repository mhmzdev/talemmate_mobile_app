part of '../home.dart';

/// The four deterministic reschedule actions offered for a single block.
enum _RescheduleChoice { snooze, tonight, shorten, skip }

/// Opens the reschedule/snooze sheet for [block], then runs the chosen action
/// on the (valid) screen context once the sheet has popped. Each action edits
/// the block locally (streams to Home) and triggers a "Why this plan" refresh.
Future<void> showRescheduleSheet(
  BuildContext context,
  StudyBlock block, {
  String? subjectName,
}) async {
  final cubit = PlanCubit.c(context);
  final action = await showModalBottomSheet<_RescheduleChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/reschedule'),
    builder: (_) => _RescheduleSheet(block: block, subjectName: subjectName),
  );

  if (!context.mounted || action == null) return;
  switch (action) {
    case _RescheduleChoice.snooze:
      cubit.snoozeBlock(block);
    case _RescheduleChoice.tonight:
      cubit.moveToTonight(block);
    case _RescheduleChoice.shorten:
      cubit.shortenBlock(block);
    case _RescheduleChoice.skip:
      cubit.skipBlock(block);
  }
}

class _RescheduleSheet extends StatelessWidget {
  const _RescheduleSheet({required this.block, this.subjectName});

  final StudyBlock block;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final meta = [
      ?subjectName,
      block.title,
      block.startTime,
      fmtBlockLength(block.durationMinutes),
    ].join(' · ');

    return AppModalBase(
      dragger: true,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: .center,
                decoration: BoxDecoration(
                  color: AppTheme.c.accent.withValues(alpha: 0.15),
                  borderRadius: 8.radius(),
                ),
                child: Icon(
                  LucideIcons.clock,
                  size: 20,
                  color: AppTheme.c.accent,
                ),
              ),
              Space.x.t12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text('Reschedule this block', style: AppText.h3),
                    Space.y.t04,
                    Text(
                      meta,
                      style: AppText.b2.cl(AppTheme.c.subText),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Space.y.t16,
          ..._actions.asMap().entries.expand(
            (e) => [
              if (e.key != 0) Space.y.t08,
              _RescheduleAction(data: e.value),
            ],
          ),
          Space.y.t16,
          AppEdgeCard(
            child: Text(
              'I\'ll re-plan around your choice and update "Why this plan".',
              style: AppText.b2.cl(AppTheme.c.subText),
            ),
          ),
          Space.y.t16,
          AppButton(
            label: 'Cancel',
            style: .creamy,
            mainAxisSize: .max,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  List<_RescheduleActionData> get _actions => [
    _RescheduleActionData(
      icon: LucideIcons.alarm_clock,
      title: 'Snooze 30 min',
      subtitle: 'Start this block at '
          '${block.startTime.clockPlusMinutes(30)} instead',
      choice: _RescheduleChoice.snooze,
    ),
    const _RescheduleActionData(
      icon: LucideIcons.moon,
      title: 'Move to tonight',
      subtitle: 'Slot it after Isha · 20:30',
      choice: _RescheduleChoice.tonight,
    ),
    _RescheduleActionData(
      icon: LucideIcons.timer,
      title: 'Shorten to 30 min',
      subtitle: 'Keep ${block.startTime}, trim the walkthrough',
      choice: _RescheduleChoice.shorten,
    ),
    const _RescheduleActionData(
      icon: LucideIcons.calendar_arrow_down,
      title: 'Skip today',
      subtitle: 'Fold it into tomorrow\'s plan',
      choice: _RescheduleChoice.skip,
    ),
  ];
}

/// Immutable row descriptor for one reschedule action.
class _RescheduleActionData {
  const _RescheduleActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.choice,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final _RescheduleChoice choice;
}

/// A tappable reschedule row — icon tile + title/subtitle + trailing chevron.
class _RescheduleAction extends StatelessWidget {
  const _RescheduleAction({required this.data});

  final _RescheduleActionData data;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppTouch(
      onTap: () => Navigator.pop(context, data.choice),
      hasSplash: false,
      child: Container(
        padding: Space.a.t12,
        decoration: BoxDecoration(
          color: AppTheme.c.subBackground,
          borderRadius: 12.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: Row(
          children: [
            Icon(data.icon, size: 20, color: AppTheme.c.text),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(data.title, style: AppText.b1.w(5).cl(AppTheme.c.text)),
                  Space.y.t04,
                  Text(
                    data.subtitle,
                    style: AppText.b2.cl(AppTheme.c.subText),
                  ),
                ],
              ),
            ),
            Space.x.t08,
            Icon(
              LucideIcons.chevron_right,
              size: 18,
              color: AppTheme.c.subText,
            ),
          ],
        ),
      ),
    );
  }
}
