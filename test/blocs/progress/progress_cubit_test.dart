import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';
import 'package:taleemmate/repos/progress/streak_math.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockProgressRepo repo;

  setUp(() {
    repo = MockProgressRepo();
    ProgressRepo.ins = repo;
  });

  // Collects emissions off the cubit stream, flushing microtasks (stream watch
  // + the async refresh chain) before returning.
  Future<List<ProgressState>> record(
    Future<void> Function(ProgressCubit) act,
  ) async {
    final cubit = ProgressCubit();
    addTearDown(cubit.close);
    final states = <ProgressState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await sub.cancel();
    return states;
  }

  void stubLoad({
    Map<String, dynamic>? data,
    List<Map<String, dynamic>>? metrics,
    String? insight = 'You retain best in the morning.',
  }) {
    when(
      () => repo.dashboardData(any()),
    ).thenAnswer((_) async => data ?? TestProgress.rawDashboardData());
    when(
      () => repo.watchMetrics(any()),
    ).thenAnswer((_) => Stream.value(metrics ?? const []));
    when(() => repo.refreshReadiness(any())).thenAnswer((_) async => insight);
  }

  group('loadForUser', () {
    test('emits [loading, success] and assembles the dashboard', () async {
      stubLoad(metrics: TestProgress.rawMetrics(updatedAt: DateTime.now()));

      final states = await record((c) => c.loadForUser(TestUser.uid));

      expect(states.first.dashboard.isLoading, isTrue);
      expect(states.last.dashboard.isSuccess, isTrue);
      final dash = states.last.dashboard.data!;
      expect(dash.streakDays, 3);
      expect(dash.subjects.length, 2);
      expect(dash.dailyScores, [60, 72, 80]);
      expect(dash.quizCount, 3);
    });

    test('does NOT refresh readiness when metrics are fresh', () async {
      stubLoad(metrics: TestProgress.rawMetrics(updatedAt: DateTime.now()));

      await record((c) => c.loadForUser(TestUser.uid));

      verifyNever(() => repo.refreshReadiness(any()));
    });

    test('refreshes readiness when metrics are absent (stale)', () async {
      stubLoad(metrics: const []);

      await record((c) => c.loadForUser(TestUser.uid));

      verify(() => repo.refreshReadiness(TestUser.uid)).called(1);
    });

    test('refreshes readiness when metrics are older than the window', () async {
      stubLoad(
        metrics: TestProgress.rawMetrics(
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      await record((c) => c.loadForUser(TestUser.uid));

      verify(() => repo.refreshReadiness(TestUser.uid)).called(1);
    });

    test('a readiness AiFault leaves the deterministic dashboard intact',
        () async {
      stubLoad(metrics: const []);
      when(
        () => repo.refreshReadiness(any()),
      ).thenThrow(testFault('AI down'));

      final states = await record((c) => c.loadForUser(TestUser.uid));

      expect(states.last.dashboard.isSuccess, isTrue);
      expect(states.last.dashboard.data!.streakDays, 3);
      expect(states.last.dashboard.data!.subjects.length, 2);
    });

    test('emits failed when the deterministic load throws', () async {
      when(() => repo.dashboardData(any())).thenThrow(testFault('db down'));
      when(() => repo.watchMetrics(any())).thenAnswer((_) => Stream.value([]));

      final states = await record((c) => c.loadForUser(TestUser.uid));

      expect(states.last.dashboard.isFailed, isTrue);
    });
  });

  group('recordQuizResult', () {
    test('forwards score + total to the repo', () async {
      when(
        () => repo.recordQuizScore(
          userId: any(named: 'userId'),
          subjectId: any(named: 'subjectId'),
          score: any(named: 'score'),
          total: any(named: 'total'),
          date: any(named: 'date'),
        ),
      ).thenAnswer((_) async {});

      final cubit = ProgressCubit();
      addTearDown(cubit.close);
      await cubit.recordQuizResult(
        userId: TestUser.uid,
        subjectId: 'subj-maths',
        score: 8,
        total: 10,
      );

      verify(
        () => repo.recordQuizScore(
          userId: TestUser.uid,
          subjectId: 'subj-maths',
          score: 8,
          total: 10,
          date: any(named: 'date'),
        ),
      ).called(1);
    });

    test('swallows a repo failure (best-effort)', () async {
      when(
        () => repo.recordQuizScore(
          userId: any(named: 'userId'),
          subjectId: any(named: 'subjectId'),
          score: any(named: 'score'),
          total: any(named: 'total'),
          date: any(named: 'date'),
        ),
      ).thenThrow(testFault());

      final cubit = ProgressCubit();
      addTearDown(cubit.close);

      // Must not throw.
      await cubit.recordQuizResult(
        userId: TestUser.uid,
        subjectId: 'subj-maths',
        score: 5,
        total: 10,
      );
    });
  });

  group('resetUid', () {
    test('clears the dashboard back to default', () async {
      stubLoad(metrics: TestProgress.rawMetrics(updatedAt: DateTime.now()));

      final states = await record((c) async {
        await c.loadForUser(TestUser.uid);
        c.resetUid();
      });

      expect(states.last.dashboard.isDefault, isTrue);
      expect(states.last.dashboard.data, isNull);
    });
  });

  // Pure date-math for the streak transition (the repo's data-provider talks to
  // AppDatabase directly, so the transition is extracted here to be testable).
  group('computeStreak', () {
    final today = DateTime(2026, 6, 19);

    test('starts a fresh streak when there is no prior row', () {
      final u = computeStreak(today: today);
      expect(u.dayCount, 1);
      expect(u.changed, isTrue);
      expect(u.startDate, DateTime(2026, 6, 19));
    });

    test('is a no-op when already counted today', () {
      final u = computeStreak(
        today: today,
        currentDayCount: 4,
        lastStudiedDate: DateTime(2026, 6, 19, 9),
        startDate: DateTime(2026, 6, 16),
      );
      expect(u.changed, isFalse);
      expect(u.dayCount, 4);
    });

    test('increments on a consecutive day', () {
      final u = computeStreak(
        today: today,
        currentDayCount: 4,
        lastStudiedDate: DateTime(2026, 6, 18),
        startDate: DateTime(2026, 6, 15),
      );
      expect(u.changed, isTrue);
      expect(u.dayCount, 5);
      expect(u.startDate, DateTime(2026, 6, 15));
    });

    test('resets after a gap', () {
      final u = computeStreak(
        today: today,
        currentDayCount: 9,
        lastStudiedDate: DateTime(2026, 6, 16),
        startDate: DateTime(2026, 6, 8),
      );
      expect(u.changed, isTrue);
      expect(u.dayCount, 1);
      expect(u.startDate, DateTime(2026, 6, 19));
    });
  });
}
