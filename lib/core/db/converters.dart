import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/tutor/citation.dart';
import 'package:taleemmate/core/models/tutor/follow_up_point.dart';

class EnumConverter<T extends Enum> extends TypeConverter<T, String> {
  final List<T> values;
  const EnumConverter(this.values);

  @override
  T fromSql(String fromDb) => values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(T value) => value.name;
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

class FollowUpPointsConverter
    extends TypeConverter<List<FollowUpPoint>, String> {
  const FollowUpPointsConverter();

  @override
  List<FollowUpPoint> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) => FollowUpPoint.fromJson(Map<String, Object?>.from(e as Map)))
        .toList();
  }

  @override
  String toSql(List<FollowUpPoint> value) =>
      jsonEncode(value.map((e) => e.toJson()).toList());
}

class CitationsConverter extends TypeConverter<List<Citation>, String> {
  const CitationsConverter();

  @override
  List<Citation> fromSql(String fromDb) {
    final list = jsonDecode(fromDb) as List;
    return list
        .map((e) => Citation.fromJson(Map<String, Object?>.from(e as Map)))
        .toList();
  }

  @override
  String toSql(List<Citation> value) =>
      jsonEncode(value.map((e) => e.toJson()).toList());
}
