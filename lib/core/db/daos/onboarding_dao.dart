part of '../database.dart';

@DriftAccessor(tables: [OnboardingDataTable])
class OnboardingDao extends DatabaseAccessor<AppDatabase>
    with _$OnboardingDaoMixin {
  OnboardingDao(super.db);

  Future<OnboardingDataRow?> findByUser(String userId) => (select(
    onboardingDataTable,
  )..where((o) => o.userId.equals(userId))).getSingleOrNull();

  Future<void> upsert(OnboardingDataTableCompanion companion) =>
      into(onboardingDataTable).insertOnConflictUpdate(companion);

  /// Targeted update of just the institution on an existing row — a partial
  /// UPDATE (not upsert) so we never insert a row with a null [step] when the
  /// user edits their institution after onboarding.
  Future<int> updateInstitution(String userId, String? value) =>
      (update(onboardingDataTable)..where((o) => o.userId.equals(userId)))
          .write(OnboardingDataTableCompanion(institution: Value(value)));
}
