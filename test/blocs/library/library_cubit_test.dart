import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/core/models/subject/subject.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockLibraryRepo repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    repo = MockLibraryRepo();
    // load() reads materials + subjects — stub both so the post-write refresh
    // settles deterministically.
    when(() => repo.materials(any())).thenAnswer((_) async => const []);
    when(() => repo.subjects(any())).thenAnswer((_) async => const []);
  });

  Subject subject({String id = 's1', double confidence = 0.5}) => Subject(
    id: id,
    code: 'MATH',
    name: 'Mathematics',
    colorHex: '#4F7A5C',
    confidenceLevel: confidence,
  );

  /// A cubit with the session uid seeded (ADR-014) and the mock repo injected.
  LibraryCubit signedInCubit() {
    final cubit = LibraryCubit(repo: repo);
    addTearDown(cubit.close);
    cubit.initUid(TestUser.uid);
    return cubit;
  }

  Future<List<LibraryState>> record(
    LibraryCubit cubit,
    Future<void> Function(LibraryCubit cubit) act,
  ) async {
    final states = <LibraryState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  group('commitSubjects', () {
    test('removes then upserts (uid-scoped), reloads once, emits success',
        () async {
      when(() => repo.upsertSubject(any())).thenAnswer((_) async {});
      when(() => repo.removeSubject(any())).thenAnswer((_) async {});

      final cubit = signedInCubit();
      final states = await record(
        cubit,
        (c) => c.commitSubjects(
          upserts: [subject(id: 's1'), subject(id: 's2')],
          removeIds: const ['s9'],
        ),
      );

      expect(states.first.saveSubject.isLoading, isTrue);
      expect(states.last.saveSubject.isSuccess, isTrue);
      verify(() => repo.removeSubject('s9')).called(1);
      final sent = verify(() => repo.upsertSubject(captureAny())).captured;
      expect(sent, hasLength(2));
      expect((sent.first as Map)['userId'], TestUser.uid);
      // A single reload follows the whole batch.
      verify(() => repo.materials(TestUser.uid)).called(1);
    });

    test('emits [loading, failed] when a write throws a Fault', () async {
      when(() => repo.removeSubject(any())).thenThrow(testFault('locked'));

      final cubit = signedInCubit();
      final states = await record(
        cubit,
        (c) => c.commitSubjects(upserts: const [], removeIds: const ['s1']),
      );

      expect(states.last.saveSubject.isFailed, isTrue);
      expect(states.last.saveSubject.fault, isNotNull);
    });

    test('no-ops when there is no session uid', () async {
      final cubit = LibraryCubit(repo: repo);
      addTearDown(cubit.close);

      await cubit.commitSubjects(upserts: [subject()], removeIds: const []);

      verifyNever(() => repo.upsertSubject(any()));
    });
  });
}
