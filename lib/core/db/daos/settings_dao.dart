part of '../database.dart';

@DriftAccessor(tables: [
  NotificationSettingsTable,
  AppearancePrefsTable,
  LanguagePrefsTable,
  PrivacySettingsTable,
])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<NotificationSettingsRow?> notificationsForUser(String userId) =>
      (select(notificationSettingsTable)
            ..where((s) => s.userId.equals(userId)))
          .getSingleOrNull();

  Future<AppearancePreferencesRow?> appearanceForUser(String userId) =>
      (select(appearancePrefsTable)..where((s) => s.userId.equals(userId)))
          .getSingleOrNull();

  Future<LanguagePreferencesRow?> languageForUser(String userId) =>
      (select(languagePrefsTable)..where((s) => s.userId.equals(userId)))
          .getSingleOrNull();

  Future<PrivacySettingsRow?> privacyForUser(String userId) =>
      (select(privacySettingsTable)..where((s) => s.userId.equals(userId)))
          .getSingleOrNull();

  Future<void> upsertNotifications(
          NotificationSettingsTableCompanion companion) =>
      into(notificationSettingsTable).insertOnConflictUpdate(companion);

  Future<void> upsertAppearance(AppearancePrefsTableCompanion companion) =>
      into(appearancePrefsTable).insertOnConflictUpdate(companion);

  Future<void> upsertLanguage(LanguagePrefsTableCompanion companion) =>
      into(languagePrefsTable).insertOnConflictUpdate(companion);

  Future<void> upsertPrivacy(PrivacySettingsTableCompanion companion) =>
      into(privacySettingsTable).insertOnConflictUpdate(companion);
}
