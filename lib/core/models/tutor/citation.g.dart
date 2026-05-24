// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Citation _$CitationFromJson(Map<String, dynamic> json) => _Citation(
  id: json['id'] as String,
  source: json['source'] as String,
  pageReference: json['pageReference'] as String?,
  colorHex: json['colorHex'] as String?,
  libraryItemId: json['libraryItemId'] as String?,
);

Map<String, dynamic> _$CitationToJson(_Citation instance) => <String, dynamic>{
  'id': instance.id,
  'source': instance.source,
  'pageReference': instance.pageReference,
  'colorHex': instance.colorHex,
  'libraryItemId': instance.libraryItemId,
};
