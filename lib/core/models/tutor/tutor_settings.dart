import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutor_settings.freezed.dart';
part 'tutor_settings.g.dart';

enum TutorScope { libraryOnly, libraryAndLectures }

enum ReasoningDepth { brief, balanced, detailed }

@freezed
sealed class TutorSettings with _$TutorSettings {
  const TutorSettings._();

  const factory TutorSettings({
    required String userId,
    @Default(true) bool showCitationsOnEveryReply,
    @Default(TutorScope.libraryAndLectures) TutorScope scope,
    @Default(ReasoningDepth.balanced) ReasoningDepth reasoningDepth,
  }) = _TutorSettings;

  factory TutorSettings.fromJson(Map<String, Object?> json) =>
      _$TutorSettingsFromJson(json);
}
