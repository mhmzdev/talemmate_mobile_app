// Pure streak transition logic, extracted so it's unit-testable without a
// database (the repo's data-provider talks to `AppDatabase.ins` directly).

/// The outcome of a streak transition.
class StreakUpdate {
  const StreakUpdate({
    required this.dayCount,
    required this.startDate,
    required this.changed,
  });

  final int dayCount;
  final DateTime startDate;

  /// False when [today] was already counted (a same-day no-op) — the caller
  /// skips the write.
  final bool changed;
}

/// Days since the Unix epoch for [d]'s calendar date, DST-safe (uses UTC).
int _epochDay(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

/// Computes the next streak for an activity on [today] given the current row:
/// - no prior row → start a fresh 1-day streak;
/// - same day as last → no-op (`changed: false`);
/// - exactly the next day → increment;
/// - a gap → reset to a fresh 1-day streak.
StreakUpdate computeStreak({
  required DateTime today,
  int? currentDayCount,
  DateTime? lastStudiedDate,
  DateTime? startDate,
}) {
  final todayOnly = DateTime(today.year, today.month, today.day);
  if (currentDayCount == null || lastStudiedDate == null) {
    return StreakUpdate(dayCount: 1, startDate: todayOnly, changed: true);
  }
  final diff = _epochDay(today) - _epochDay(lastStudiedDate);
  if (diff <= 0) {
    return StreakUpdate(
      dayCount: currentDayCount,
      startDate: startDate ?? todayOnly,
      changed: false,
    );
  } else if (diff == 1) {
    return StreakUpdate(
      dayCount: currentDayCount + 1,
      startDate: startDate ?? todayOnly,
      changed: true,
    );
  }
  return StreakUpdate(dayCount: 1, startDate: todayOnly, changed: true);
}
