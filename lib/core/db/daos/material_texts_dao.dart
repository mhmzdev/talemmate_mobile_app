part of '../database.dart';

@DriftAccessor(tables: [MaterialTexts, LibraryItems])
class MaterialTextsDao extends DatabaseAccessor<AppDatabase>
    with _$MaterialTextsDaoMixin {
  MaterialTextsDao(super.db);

  Future<void> upsert(MaterialTextsCompanion c) =>
      into(materialTexts).insertOnConflictUpdate(c);

  /// Removes the extracted text for an item. Must run before deleting the owning
  /// material — `itemId` is a FK to `library_items.id`.
  Future<int> deleteForItem(String itemId) =>
      (delete(materialTexts)..where((t) => t.itemId.equals(itemId))).go();

  Future<MaterialTextRow?> forItem(String itemId) => (select(
    materialTexts,
  )..where((t) => t.itemId.equals(itemId))).getSingleOrNull();

  /// All extracted text for a user's items in a subject (grounding source),
  /// paired with the owning material's display name so the chat agent can tag
  /// each chunk `[itemId | name]` and cite it by name.
  Future<List<(MaterialTextRow, String)>> forSubject(
    String userId,
    String subjectId,
  ) {
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
    return q
        .map(
          (r) => (r.readTable(materialTexts), r.readTable(libraryItems).name),
        )
        .get();
  }
}
