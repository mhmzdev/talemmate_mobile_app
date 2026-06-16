import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:taleemmate/core/constants/study_windows.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/core/models/schedule/study_window.dart';
import 'package:taleemmate/services/firebase/ai/ai_service.dart';
import 'package:taleemmate/services/firebase/ai/system_prompts.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:uuid/uuid.dart';

part 'plan_mocks.dart';
part 'plan_parser.dart';
part 'plan_data_provider.dart';

/// Drift + Gemini backed repo for weekly study-plan generation (ADR-013):
/// public methods take/return `Map`/`List<Map>`/primitives only — `PlanCubit`
/// does the `WeekPlan.fromJson` / `StudyBlock.fromJson` conversion.
class PlanRepo {
  static final PlanRepo _instance = PlanRepo._();
  PlanRepo._();

  static PlanRepo get ins => _instance;

  /// --- repo functions --- ///

  /// Generates a fresh 7-day plan for [userId] from the saved schedule,
  /// subjects and exams, persists the blocks + reasoning, and returns a
  /// `WeekPlan.toJson()`-shaped map. Throws a [Fault] on failure.
  Future<Map<String, dynamic>> generate(String userId) =>
      _PlanProvider.generate(userId);

  /// Live block list for a schedule (by date, then start time), as
  /// `StudyBlock.toJson()`-shaped maps.
  Stream<List<Map<String, dynamic>>> watchBlocks(String scheduleId) =>
      _PlanProvider.watchBlocks(scheduleId);

  /// The user's schedule row as a `Schedule.toJson()`-shaped map, or null.
  Future<Map<String, dynamic>?> currentSchedule(String userId) =>
      _PlanProvider.currentSchedule(userId);

  /// A user's exams, as `Exam.toJson()`-shaped maps — used to mark exam days.
  Future<List<Map<String, dynamic>>> exams(String userId) =>
      _PlanProvider.exams(userId);
}
