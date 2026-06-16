part of '../plan.dart';

/// Horizontal 7-day selector. Each cell shows the weekday, date number, a row
/// of block-count dots, and an exam marker when the day has an exam. Tapping a
/// cell selects that day's timeline.
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.week, required this.selectedIndex});

  final WeekPlan week;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.h.t16,
      child: Row(
        children: week.days.asMap().entries.map((e) {
          return Expanded(
            child: Padding(
              padding: Space.h.t04,
              child: _DayCell(
                day: e.value,
                selected: e.key == selectedIndex,
                onTap: () => _ScreenState.s(context).selectDay(e.key),
              ).withBottomAnimation(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DayPlan day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final fg = selected ? AppTheme.c.onPrimary : AppTheme.c.text;
    final dotCount = day.blocks.length.clamp(0, 5);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: AppProps.medium,
            padding: Space.v.t12,
            decoration: BoxDecoration(
              color: selected ? AppTheme.c.primary : Colors.transparent,
              borderRadius: 12.radius(),
              border: Border.all(
                color: selected ? AppTheme.c.primary : AppTheme.c.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  day.date.weekdayShort,
                  style: AppText.l1
                      .cl(fg.withValues(alpha: 0.7))
                      .copyWith(letterSpacing: 0.8),
                ),
                Space.y.t04,
                Text('${day.date.day}', style: AppText.h3.cl(fg)),
                Space.y.t08,
                SizedBox(
                  height: 4,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: List.generate(dotCount, (i) => i)
                        .expand(
                          (i) => [
                            if (i != 0) Space.x.t04,
                            _DayDot(selected: selected),
                          ],
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (day.exam != null)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.c.error,
                  border: Border.all(color: AppTheme.c.background, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single block-count dot inside a [_DayCell].
class _DayDot extends StatelessWidget {
  const _DayDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (selected ? AppTheme.c.onPrimary : AppTheme.c.subText)
            .withValues(alpha: 0.5),
      ),
    );
  }
}
