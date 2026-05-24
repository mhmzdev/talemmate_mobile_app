import 'package:freezed_annotation/freezed_annotation.dart';

part 'citation.freezed.dart';
part 'citation.g.dart';

@freezed
sealed class Citation with _$Citation {
  const Citation._();

  const factory Citation({
    required String id,
    required String source,
    String? pageReference,
    String? colorHex,
    String? libraryItemId,
  }) = _Citation;

  factory Citation.fromJson(Map<String, Object?> json) =>
      _$CitationFromJson(json);
}
