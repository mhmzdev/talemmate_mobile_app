import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quiz/cubit.dart';
import 'package:taleemmate/repos/quiz/quiz_repo.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockQuizRepo repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    repo = MockQuizRepo();
    QuizRepo.ins = repo;
  });

  Future<List<QuizState>> record(
    Future<void> Function(QuizCubit cubit) act,
  ) async {
    final cubit = QuizCubit();
    addTearDown(cubit.close);
    final states = <QuizState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    // Flush the final emission (stream delivery is a microtask).
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  group('generate', () {
    test('emits [loading, success] and hydrates Quiz.fromJson', () async {
      when(
        () => repo.generate(
          userId: any(named: 'userId'),
          subjectId: any(named: 'subjectId'),
          topicId: any(named: 'topicId'),
          sourceItemIds: any(named: 'sourceItemIds'),
        ),
      ).thenAnswer((_) async => TestQuiz.rawJson());

      final states = await record(
        (c) => c.generate(userId: TestUser.uid, subjectId: 'subj-maths'),
      );

      expect(states.first.generate.isLoading, isTrue);
      expect(states.last.generate.isSuccess, isTrue);
      final quiz = states.last.generate.data!;
      expect(quiz.id, TestQuiz.id);
      expect(quiz.questions, hasLength(2));
      expect(quiz.questions.first.correctAnswerIndex, 1);
      expect(quiz.questions.first.explanation, isNotEmpty);
    });

    test('emits [loading, failed] with the fault on a repo throw', () async {
      when(
        () => repo.generate(
          userId: any(named: 'userId'),
          subjectId: any(named: 'subjectId'),
          topicId: any(named: 'topicId'),
          sourceItemIds: any(named: 'sourceItemIds'),
        ),
      ).thenThrow(testFault('quiz down'));

      final states = await record(
        (c) => c.generate(userId: TestUser.uid, subjectId: 'subj-maths'),
      );

      expect(states.first.generate.isLoading, isTrue);
      expect(states.last.generate.isFailed, isTrue);
      expect(states.last.generate.errorMessage, 'quiz down');
    });

    test('forwards a chosen subset of materials to the repo', () async {
      when(
        () => repo.generate(
          userId: any(named: 'userId'),
          subjectId: any(named: 'subjectId'),
          topicId: any(named: 'topicId'),
          sourceItemIds: any(named: 'sourceItemIds'),
        ),
      ).thenAnswer((_) async => TestQuiz.rawJson());

      await record(
        (c) => c.generate(
          userId: TestUser.uid,
          subjectId: 'subj-maths',
          sourceItemIds: const ['item-1', 'item-2'],
        ),
      );

      verify(
        () => repo.generate(
          userId: TestUser.uid,
          subjectId: 'subj-maths',
          topicId: null,
          sourceItemIds: const ['item-1', 'item-2'],
        ),
      ).called(1);
    });
  });

  group('recordAnswer', () {
    setUp(() {
      when(() => repo.recordAnswer(any())).thenAnswer((_) async {});
    });

    /// Captures the single map passed to `repo.recordAnswer`.
    Map<String, dynamic> capturedAttempt() =>
        verify(() => repo.recordAnswer(captureAny())).captured.single
            as Map<String, dynamic>;

    test('marks a correct pick isCorrect:true with the right ids', () async {
      final quiz = TestQuiz.sample();
      final q = quiz.questions.first; // correct index = 1

      await record(
        (c) => c.recordAnswer(
          quizId: quiz.id,
          userId: TestUser.uid,
          question: q,
          selectedIndex: 1,
        ),
      );

      final attempt = capturedAttempt();
      expect(attempt['quizId'], quiz.id);
      expect(attempt['userId'], TestUser.uid);
      expect(attempt['questionId'], q.id);
      expect(attempt['selectedAnswerIndex'], 1);
      expect(attempt['isCorrect'], isTrue);
      expect(attempt['id'], isNotEmpty);
      expect(attempt['timestamp'], isNotNull);
    });

    test('marks a wrong pick isCorrect:false', () async {
      final q = TestQuiz.sample().questions.first; // correct index = 1

      await record(
        (c) => c.recordAnswer(
          quizId: TestQuiz.id,
          userId: TestUser.uid,
          question: q,
          selectedIndex: 0,
        ),
      );

      expect(capturedAttempt()['isCorrect'], isFalse);
    });

    test('records a skip as isCorrect:false with a null selection', () async {
      final q = TestQuiz.sample().questions.first;

      await record(
        (c) => c.recordAnswer(
          quizId: TestQuiz.id,
          userId: TestUser.uid,
          question: q,
          selectedIndex: null,
        ),
      );

      final attempt = capturedAttempt();
      expect(attempt['selectedAnswerIndex'], isNull);
      expect(attempt['isCorrect'], isFalse);
    });
  });
}
