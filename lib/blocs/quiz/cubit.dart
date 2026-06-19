import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/quiz/quiz.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';
import 'package:taleemmate/repos/quiz/quiz_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'state.dart';

class QuizCubit extends Cubit<QuizState> {
  static QuizCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<QuizCubit>(context, listen: listen);

  QuizCubit() : super(QuizState.def());

  static const _uuid = Uuid();

  /// Generates + persists a fresh quiz for [subjectId] (optionally scoped to
  /// [topicId], or grounded on specific materials via [sourceItemIds] — one,
  /// several, or null/empty for the whole subject) and hydrates it into
  /// `generate`. Drives the loader.
  Future<void> generate({
    required String userId,
    required String subjectId,
    String? topicId,
    List<String>? sourceItemIds,
  }) async {
    emit(state.copyWith(generate: state.generate.toLoading()));
    try {
      final raw = await QuizRepo.ins.generate(
        userId: userId,
        subjectId: subjectId,
        topicId: topicId,
        sourceItemIds: sourceItemIds,
      );
      emit(
        state.copyWith(
          generate: state.generate.toSuccess(data: Quiz.fromJson(raw)),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(generate: state.generate.toFailed(fault: e)));
    }
  }

  /// Persists one answered (or skipped) question as a [QuizAttempt].
  /// Fire-and-forget — recording must never block the quiz, so a failure is
  /// swallowed rather than surfaced.
  Future<void> recordAnswer({
    required String quizId,
    required String userId,
    required QuizQuestion question,
    int? selectedIndex,
  }) async {
    try {
      await QuizRepo.ins.recordAnswer({
        'id': _uuid.v4(),
        'quizId': quizId,
        'userId': userId,
        'questionId': question.id,
        'timestamp': DateTime.now().toIso8601String(),
        'selectedAnswerIndex': selectedIndex,
        'isCorrect': selectedIndex != null &&
            selectedIndex == question.correctAnswerIndex,
      });
    } on Fault {
      // Best-effort: a recording failure must not interrupt the quiz.
    }
  }

  void reset() => emit(QuizState.def());
}
