import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_window.freezed.dart';
part 'study_window.g.dart';

@freezed
sealed class StudyWindow with _$StudyWindow {
  const StudyWindow._();

  const factory StudyWindow({
    required String id,
    required String label,
    required String startTime,
    required String endTime,
    @Default(true) bool isEnabled,
  }) = _StudyWindow;

  factory StudyWindow.fromJson(Map<String, Object?> json) =>
      _$StudyWindowFromJson(json);
}
