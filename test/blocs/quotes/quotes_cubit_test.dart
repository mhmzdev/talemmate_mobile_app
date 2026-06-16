import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/repos/quotes/quotes_repo.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockQuotesRepo repo;

  setUp(() {
    repo = MockQuotesRepo();
    QuotesRepo.ins = repo;
  });

  Future<List<QuotesState>> record(
    Future<void> Function(QuotesCubit cubit) act,
  ) async {
    final cubit = QuotesCubit();
    addTearDown(cubit.close);
    final states = <QuotesState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    // Let the final emission flush through the broadcast stream before we stop
    // listening — stream delivery is a microtask, so a macrotask hop drains it.
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  group('today', () {
    test('emits [loading, success] with the fetched quote', () async {
      when(() => repo.today()).thenAnswer((_) async => TestQuote.sample());

      final states = await record((c) => c.today());

      expect(states.first.today.isLoading, isTrue);
      expect(states.last.today.isSuccess, isTrue);
      expect(states.last.today.data?.a, 'Lao Tzu');
      verify(() => repo.today()).called(1);
    });

    test('emits [loading, failed] when the repo throws a Fault', () async {
      when(() => repo.today()).thenThrow(testFault('network down'));

      final states = await record((c) => c.today());

      expect(states.first.today.isLoading, isTrue);
      expect(states.last.today.isFailed, isTrue);
      expect(states.last.today.fault, isNotNull);
    });
  });

  group('reset', () {
    test('returns to a fresh default state', () async {
      when(() => repo.today()).thenAnswer((_) async => TestQuote.sample());

      final cubit = QuotesCubit();
      addTearDown(cubit.close);
      await cubit.today();
      expect(cubit.state.today.isSuccess, isTrue);

      cubit.reset();

      expect(cubit.state, QuotesState.def());
    });
  });
}
