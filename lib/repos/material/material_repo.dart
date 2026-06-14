import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:path/path.dart' as p;
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/services/firebase/ai/ai_service.dart';
import 'package:taleemmate/services/fault/faults.dart';

part 'material_mocks.dart';
part 'material_parser.dart';
part 'material_data_provider.dart';

/// Drift + Gemini backed repo for the text-extraction pipeline (ADR-013):
/// public methods take/return `Map`/`List<Map>`/primitives only — the cubit
/// does the `LibraryItem.fromJson` conversion.
class MaterialRepo {
  static final MaterialRepo _instance = MaterialRepo._();
  MaterialRepo._();

  static MaterialRepo get ins => _instance;

  /// --- repo functions --- ///

  /// Extract + persist text for one item map (a `LibraryItem.toJson()`).
  /// Returns the updated item map (real `processingStatus` + `indexedPageCount`).
  /// Throws a [Fault] on a genuine extraction failure (after marking the row
  /// `failed`); unsupported kinds resolve to a `failed` map without throwing.
  Future<Map<String, dynamic>> extract(Map<String, dynamic> item) =>
      _MaterialProvider.extract(item);

  /// Grounding source: extracted-text maps for a subject's items.
  Future<List<Map<String, dynamic>>> textsForSubject(
    String userId,
    String subjectId,
  ) => _MaterialProvider.textsForSubject(userId, subjectId);
}
