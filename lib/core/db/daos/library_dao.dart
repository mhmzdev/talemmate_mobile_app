part of '../database.dart';

@DriftAccessor(tables: [LibraryItems])
class LibraryDao extends DatabaseAccessor<AppDatabase> with _$LibraryDaoMixin {
  LibraryDao(super.db);

  Stream<List<LibraryItemRow>> watchByUser(String userId) =>
      (select(libraryItems)
            ..where((l) => l.userId.equals(userId))
            ..orderBy([(l) => OrderingTerm.desc(l.uploadedAt)]))
          .watch();

  Stream<List<LibraryItemRow>> watchBySubject(String subjectId) =>
      (select(libraryItems)
            ..where((l) => l.subjectId.equals(subjectId)))
          .watch();

  Future<void> upsert(LibraryItemsCompanion companion) =>
      into(libraryItems).insertOnConflictUpdate(companion);

  Future<int> deleteItem(String id) =>
      (delete(libraryItems)..where((l) => l.id.equals(id))).go();
}
