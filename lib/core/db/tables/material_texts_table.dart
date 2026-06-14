import 'package:drift/drift.dart';

import 'library_table.dart';

/// Extracted plain text for a single [LibraryItems] material — the grounding
/// source consumed by the Chat agent. One row per indexed item.
@DataClassName('MaterialTextRow')
class MaterialTexts extends Table {
  TextColumn get itemId => text().references(LibraryItems, #id)();
  TextColumn get content => text()();
  IntColumn get pageCount => integer().withDefault(const Constant(0))();
  IntColumn get charCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get extractedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {itemId};
}
