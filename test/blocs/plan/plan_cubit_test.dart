import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockPlanRepo repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    repo = MockPlanRepo();
    PlanRepo.ins = repo;
  });

  Future<List<PlanState>> record(
    Future<void> Function(PlanCubit cubit) act,
  ) async {
    final cubit = PlanCubit();
    addTearDown(cubit.close);
    final states = <PlanState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    // Flush the final emission (stream delivery is a microtask).
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  /// Captures the single map passed to `repo.updateBlock`.
  Map<String, dynamic> capturedPatch() =>
      verify(() => repo.updateBlock(captureAny())).captured.single
          as Map<String, dynamic>;

  // Stubs the watch chain so `watchForUser` settles and `_watchingUserId` is
  // set (required for the reasoning refresh + session recording).
  void stubWatch() {
    when(
      () => repo.currentSchedule(any()),
    ).thenAnswer((_) async => TestBlock.rawSchedule());
    when(() => repo.exams(any())).thenAnswer((_) async => const []);
    when(
      () => repo.watchBlocks(any()),
    ).thenAnswer((_) => Stream.value([TestBlock.sample().toJson()]));
  }

  group('reschedule actions — patch computation', () {
    setUp(() {
      when(() => repo.updateBlock(any())).thenAnswer((_) async {});
    });

    test('snoozeBlock adds 30 minutes to the start time', () async {
      await record((c) => c.snoozeBlock(TestBlock.sample(startTime: '08:30')));

      final patch = capturedPatch();
      expect(patch['id'], 'block-1');
      expect(patch['startTime'], '09:00');
    });

    test('snoozeBlock rolls the hour over past the top of the hour', () async {
      await record((c) => c.snoozeBlock(TestBlock.sample(startTime: '08:45')));
      expect(capturedPatch()['startTime'], '09:15');
    });

    test('moveToTonight sets the start time to 20:30', () async {
      await record((c) => c.moveToTonight(TestBlock.sample()));
      expect(capturedPatch()['startTime'], '20:30');
    });

    test('shortenBlock clamps a long block to 30 minutes', () async {
      await record(
        (c) => c.shortenBlock(TestBlock.sample(durationMinutes: 60)),
      );
      expect(capturedPatch()['durationMinutes'], 30);
    });

    test('shortenBlock leaves an already-short block untouched', () async {
      await record(
        (c) => c.shortenBlock(TestBlock.sample(durationMinutes: 25)),
      );
      expect(capturedPatch()['durationMinutes'], 25);
    });

    test('skipBlock advances the date by one day', () async {
      final block = TestBlock.sample(date: DateTime(2026, 6, 18));
      await record((c) => c.skipBlock(block));
      expect(capturedPatch()['date'], DateTime(2026, 6, 19).toIso8601String());
    });
  });

  group('_refreshReasoning (via a reschedule)', () {
    setUp(() {
      stubWatch();
      when(() => repo.updateBlock(any())).thenAnswer((_) async {});
    });

    test('emits reasoning [loading, success] and mirrors it into the '
        'week', () async {
      when(
        () => repo.updateReasoning(any()),
      ).thenAnswer((_) async => 'New reasoning.');

      final states = await record((c) async {
        await c.watchForUser(TestUser.uid);
        await c.snoozeBlock(TestBlock.sample());
      });

      expect(states.any((s) => s.reasoning.isLoading), isTrue);
      expect(states.last.reasoning.isSuccess, isTrue);
      expect(states.last.reasoning.data, 'New reasoning.');
      expect(states.last.week.data?.aiReasoning, 'New reasoning.');
    });

    test('keeps the prior reasoning when the AI refresh fails', () async {
      when(() => repo.updateReasoning(any())).thenThrow(testFault('ai down'));

      final states = await record((c) async {
        await c.watchForUser(TestUser.uid);
        await c.snoozeBlock(TestBlock.sample());
      });

      expect(states.last.reasoning.isFailed, isTrue);
      // The block move still stands; the week keeps its original reasoning.
      expect(states.last.week.data?.aiReasoning, 'Original reasoning.');
      verify(() => repo.updateBlock(any())).called(1);
    });
  });

  group('markBlockDone', () {
    late MockProgressRepo progressRepo;

    setUp(() {
      stubWatch();
      progressRepo = MockProgressRepo();
      ProgressRepo.ins = progressRepo;
      when(() => repo.updateBlock(any())).thenAnswer((_) async {});
      when(() => repo.recordSession(any())).thenAnswer((_) async {});
      when(
        () => progressRepo.recordStudyActivity(userId: any(named: 'userId')),
      ).thenAnswer((_) async {});
    });

    test('writes status:done and records a session with the block '
        'topic', () async {
      final block = TestBlock.sample(topicId: 'topic-x', durationMinutes: 45);

      await record((c) async {
        await c.watchForUser(TestUser.uid);
        await c.markBlockDone(block);
      });

      final donePatch =
          verify(() => repo.updateBlock(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(donePatch['id'], 'block-1');
      expect(donePatch['status'], BlockStatus.done.name);

      final metric =
          verify(() => repo.recordSession(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(metric['userId'], TestUser.uid);
      expect(metric['durationMinutes'], 45);
      expect(metric['topicIds'], ['topic-x']);
    });

    test('records an empty topic list when the block has no topic', () async {
      await record((c) async {
        await c.watchForUser(TestUser.uid);
        await c.markBlockDone(TestBlock.sample());
      });

      final metric =
          verify(() => repo.recordSession(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(metric['topicIds'], isEmpty);
    });

    test('also bumps the study streak for the user', () async {
      await record((c) async {
        await c.watchForUser(TestUser.uid);
        await c.markBlockDone(TestBlock.sample());
      });

      verify(
        () => progressRepo.recordStudyActivity(userId: TestUser.uid),
      ).called(1);
    });
  });
}
