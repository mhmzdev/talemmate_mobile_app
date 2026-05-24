// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryItem _$LibraryItemFromJson(Map<String, dynamic> json) => _LibraryItem(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  kind: $enumDecode(_$ItemKindEnumMap, json['kind']),
  fileSize: (json['fileSize'] as num).toInt(),
  uploadedAt: DateTime.parse(json['uploadedAt'] as String),
  processingStatus: $enumDecode(
    _$ProcessingStatusEnumMap,
    json['processingStatus'],
  ),
  subjectId: json['subjectId'] as String?,
  metadata: json['metadata'] as String?,
  colorHex: json['colorHex'] as String?,
  indexedPageCount: (json['indexedPageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$LibraryItemToJson(_LibraryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'kind': _$ItemKindEnumMap[instance.kind]!,
      'fileSize': instance.fileSize,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'processingStatus': _$ProcessingStatusEnumMap[instance.processingStatus]!,
      'subjectId': instance.subjectId,
      'metadata': instance.metadata,
      'colorHex': instance.colorHex,
      'indexedPageCount': instance.indexedPageCount,
    };

const _$ItemKindEnumMap = {
  ItemKind.pdf: 'pdf',
  ItemKind.img: 'img',
  ItemKind.slide: 'slide',
  ItemKind.note: 'note',
  ItemKind.video: 'video',
  ItemKind.voice: 'voice',
};

const _$ProcessingStatusEnumMap = {
  ProcessingStatus.pending: 'pending',
  ProcessingStatus.processing: 'processing',
  ProcessingStatus.indexed: 'indexed',
  ProcessingStatus.failed: 'failed',
};
