import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_item.freezed.dart';
part 'library_item.g.dart';

enum ItemKind { pdf, img, slide, note, video, voice }

enum ProcessingStatus { pending, processing, indexed, failed }

@freezed
sealed class LibraryItem with _$LibraryItem {
  const LibraryItem._();

  const factory LibraryItem({
    required String id,
    required String userId,
    required String name,
    required ItemKind kind,
    required int fileSize,
    required DateTime uploadedAt,
    required ProcessingStatus processingStatus,
    String? subjectId,
    String? metadata,
    String? colorHex,
    int? indexedPageCount,
  }) = _LibraryItem;

  factory LibraryItem.fromJson(Map<String, Object?> json) =>
      _$LibraryItemFromJson(json);
}
