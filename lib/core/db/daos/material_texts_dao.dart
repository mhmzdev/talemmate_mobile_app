part of '../database.dart';

@DriftAccessor(tables: [MaterialTexts, LibraryItems])
class MaterialTextsDao extends DatabaseAccessor<AppDatabase>
    with _$MaterialTextsDaoMixin {
  MaterialTextsDao(super.db);

  Future<void> upsert(MaterialTextsCompanion c) =>
      into(materialTexts).insertOnConflictUpdate(c);

  Future<MaterialTextRow?> forItem(String itemId) => (select(
    materialTexts,
  )..where((t) => t.itemId.equals(itemId))).getSingleOrNull();

  /// All extracted text for a user's items in a subject (grounding source).
  Future<List<MaterialTextRow>> forSubject(String userId, String subjectId) {
    final q =
        select(materialTexts).join([
          innerJoin(
            libraryItems,
            libraryItems.id.equalsExp(materialTexts.itemId),
          ),
        ])..where(
          libraryItems.userId.equals(userId) &
              libraryItems.subjectId.equals(subjectId),
        );
    return q.map((r) => r.readTable(materialTexts)).get();
  }
}
