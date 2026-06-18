import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/ui/screens/home/home.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockPlanRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    repo = MockPlanRepo();
    PlanRepo.ins = repo;
    when(() => repo.updateBlock(any())).thenAnswer((_) async {});
  });

  /// Pumps a host with an "open" button that shows the reschedule sheet for
  /// [block] over a real [PlanCubit] (driven through the mock repo).
  Future<void> pumpSheet(
    WidgetTester tester, {
    required StudyBlock block,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final planCubit = PlanCubit();
    addTearDown(planCubit.close);

    await tester.pumpWidget(
      BlocProvider<PlanCubit>.value(
        value: planCubit,
        child: MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showRescheduleSheet(
                    context,
                    block,
                    subjectName: 'Maths',
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('reschedule sheet — rendering', () {
    testWidgets('shows the header and four actions with computed subtitles',
        (tester) async {
      await pumpSheet(tester, block: TestBlock.sample(startTime: '08:30'));

      expect(find.text('Reschedule this block'), findsOneWidget);

      expect(find.text('Snooze 30 min'), findsOneWidget);
      expect(find.text('Start this block at 09:00 instead'), findsOneWidget);

      expect(find.text('Move to tonight'), findsOneWidget);
      expect(find.text('Slot it after Isha · 20:30'), findsOneWidget);

      expect(find.text('Shorten to 30 min'), findsOneWidget);
      expect(find.text('Keep 08:30, trim the walkthrough'), findsOneWidget);

      expect(find.text('Skip today'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('reschedule sheet — actions', () {
    testWidgets('tapping Snooze rescheduled the block to start + 30',
        (tester) async {
      await pumpSheet(tester, block: TestBlock.sample(startTime: '08:30'));

      await tester.tap(find.text('Snooze 30 min'));
      await tester.pumpAndSettle();

      final patch = verify(() => repo.updateBlock(captureAny())).captured.single
          as Map<String, dynamic>;
      expect(patch['startTime'], '09:00');
    });

    testWidgets('tapping Skip advances the block by a day', (tester) async {
      await pumpSheet(
        tester,
        block: TestBlock.sample(date: DateTime(2026, 6, 18)),
      );

      await tester.tap(find.text('Skip today'));
      await tester.pumpAndSettle();

      final patch = verify(() => repo.updateBlock(captureAny())).captured.single
          as Map<String, dynamic>;
      expect(patch['date'], DateTime(2026, 6, 19).toIso8601String());
    });

    testWidgets('tapping Cancel changes nothing', (tester) async {
      await pumpSheet(tester, block: TestBlock.sample());

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => repo.updateBlock(any()));
    });
  });
}
