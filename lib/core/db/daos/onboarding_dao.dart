part of '../database.dart';

@DriftAccessor(tables: [OnboardingDataTable])
class OnboardingDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardingDaoMixin {
  OnboardingDao(super.db);

  Future<OnboardingDataRow?> findByUser(String userId) =>
      (select(onboardingDataTable)..where((o) => o.userId.equals(userId)))
          .getSingleOrNull();

  Future<void> upsert(OnboardingDataTableCompanion companion) =>
      into(onboardingDataTable).insertOnConflictUpdate(companion);
}
