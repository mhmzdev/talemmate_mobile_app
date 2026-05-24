import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

@freezed
sealed class Subject with _$Subject {
  const Subject._();

  const factory Subject({
    required String id,
    required String code,
    required String name,
    required String colorHex,
    required double confidenceLevel,
    @Default(0) int order,
  }) = _Subject;

  factory Subject.fromJson(Map<String, Object?> json) =>
      _$SubjectFromJson(json);
}
