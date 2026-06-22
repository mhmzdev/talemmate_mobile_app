part of 'library_repo.dart';

class _LibraryProvider {
  /// A user's materials as `LibraryItem.fromJson`-compatible maps, newest first.
  static Future<List<Map<String, dynamic>>> materials(String userId) async {
    try {
      final rows = await AppDatabase.ins.libraryDao.getByUser(userId);
      return rows.map(_libraryItemJson).toList();
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not load your library.', st);
    }
  }

  /// A user's subjects as `Subject.fromJson`-compatible maps (for grouping
  /// headers). Scoped per account (ADR-014) — never load all subjects.
  static Future<List<Map<String, dynamic>>> subjects(String userId) async {
    try {
      final rows = await AppDatabase.ins.subjectDao.getByUser(userId);
      return rows.map((r) => r.toJson()).toList();
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not load your subjects.', st);
    }
  }

  /// Adds one material. [values] is a `LibraryItem.toJson()` map; the model↔row
  /// mapping lives in `AppDatabase.saveLibraryItem` so this stays model-free.
  static Future<void> add(Map<String, dynamic> values) async {
    try {
      await AppDatabase.ins.saveLibraryItem(values);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not add the material.', st);
    }
  }

  static Future<void> remove(String id) async {
    try {
      await AppDatabase.ins.deleteLibraryItem(id);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not remove the material.', st);
    }
  }

  /// Upserts one subject; the Map→row mapping lives in `AppDatabase`.
  static Future<void> upsertSubject(Map<String, dynamic> values) async {
    try {
      await AppDatabase.ins.upsertSubject(values);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not save the subject.', st);
    }
  }

  /// Removes a subject and its derived rows (cascade lives in `AppDatabase`).
  static Future<void> removeSubject(String id) async {
    try {
      await AppDatabase.ins.deleteSubjectCascade(id);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Could not remove the subject.', st);
    }
  }
}

/// Maps a Drift [LibraryItemRow] to a `LibraryItem.fromJson`-compatible map.
/// Drift's own `toJson()` emits the raw enum values and a non-ISO date, so we
/// build the exact JSON shape the freezed model expects by hand.
Map<String, dynamic> _libraryItemJson(LibraryItemRow r) => {
  'id': r.id,
  'userId': r.userId,
  'name': r.name,
  'kind': r.kind.name,
  'fileSize': r.fileSize,
  'uploadedAt': r.uploadedAt.toIso8601String(),
  'processingStatus': r.processingStatus.name,
  'subjectId': r.subjectId,
  'metadata': r.metadata,
  'colorHex': r.colorHex,
  'indexedPageCount': r.indexedPageCount,
};
