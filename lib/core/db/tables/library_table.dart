import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/library/library_item.dart';

import '../converters.dart';
import 'subjects_table.dart';

@DataClassName('LibraryItemRow')
class LibraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get kind =>
      text().map(const EnumConverter<ItemKind>(ItemKind.values))();
  IntColumn get fileSize => integer()();
  DateTimeColumn get uploadedAt => dateTime()();
  TextColumn get processingStatus => text().map(
    const EnumConverter<ProcessingStatus>(ProcessingStatus.values),
  )();
  TextColumn get subjectId => text().references(Subjects, #id).nullable()();
  TextColumn get metadata => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  IntColumn get indexedPageCount => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
