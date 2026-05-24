import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/settings/appearance_preferences.dart';
import 'package:taleemmate/core/models/settings/language_preferences.dart';

import '../converters.dart';

@DataClassName('NotificationSettingsRow')
class NotificationSettingsTable extends Table {
  @override
  String get tableName => 'notification_settings';

  TextColumn get userId => text()();
  BoolColumn get blockReminders =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get dailyCheckIn => boolean().withDefault(const Constant(true))();
  BoolColumn get examCountdown => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('AppearancePreferencesRow')
class AppearancePrefsTable extends Table {
  @override
  String get tableName => 'appearance_preferences';

  TextColumn get userId => text()();
  TextColumn get theme =>
      text().map(const EnumConverter<ThemeSetting>(ThemeSetting.values))();
  BoolColumn get showDuaCard => boolean().withDefault(const Constant(true))();
  BoolColumn get showHijriDate => boolean().withDefault(const Constant(true))();
  TextColumn get dailyDuaText => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('LanguagePreferencesRow')
class LanguagePrefsTable extends Table {
  @override
  String get tableName => 'language_preferences';

  TextColumn get userId => text()();
  TextColumn get appLanguage =>
      text().map(const EnumConverter<AppLanguage>(AppLanguage.values))();
  BoolColumn get useUrduNastaliq =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('PrivacySettingsRow')
class PrivacySettingsTable extends Table {
  @override
  String get tableName => 'privacy_settings';

  TextColumn get userId => text()();
  BoolColumn get onDeviceProcessing =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get cloudBackupEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get cloudBackupLastSync => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
