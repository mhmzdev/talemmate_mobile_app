import 'package:drift/drift.dart';

@DataClassName('OnboardingDataRow')
class OnboardingDataTable extends Table {
  @override
  String get tableName => 'onboarding_data';

  TextColumn get userId => text()();
  IntColumn get step => integer().withDefault(const Constant(1))();
  TextColumn get institution => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
