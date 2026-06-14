// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  q: json['q'] as String,
  a: json['a'] as String?,
  i: json['i'] as String?,
  date: json['date'] as String,
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'q': instance.q,
  'a': instance.a,
  'i': instance.i,
  'date': instance.date,
};
