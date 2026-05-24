// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionMetric {

 String get userId; DateTime get date; int get durationMinutes; List<String> get topicIds;
/// Create a copy of SessionMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionMetricCopyWith<SessionMetric> get copyWith => _$SessionMetricCopyWithImpl<SessionMetric>(this as SessionMetric, _$identity);

  /// Serializes this SessionMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionMetric&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&const DeepCollectionEquality().equals(other.topicIds, topicIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,date,durationMinutes,const DeepCollectionEquality().hash(topicIds));

@override
String toString() {
  return 'SessionMetric(userId: $userId, date: $date, durationMinutes: $durationMinutes, topicIds: $topicIds)';
}


}

/// @nodoc
abstract mixin class $SessionMetricCopyWith<$Res>  {
  factory $SessionMetricCopyWith(SessionMetric value, $Res Function(SessionMetric) _then) = _$SessionMetricCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime date, int durationMinutes, List<String> topicIds
});




}
/// @nodoc
class _$SessionMetricCopyWithImpl<$Res>
    implements $SessionMetricCopyWith<$Res> {
  _$SessionMetricCopyWithImpl(this._self, this._then);

  final SessionMetric _self;
  final $Res Function(SessionMetric) _then;

/// Create a copy of SessionMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? date = null,Object? durationMinutes = null,Object? topicIds = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,topicIds: null == topicIds ? _self.topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionMetric].
extension SessionMetricPatterns on SessionMetric {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionMetric() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionMetric value)  $default,){
final _that = this;
switch (_that) {
case _SessionMetric():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionMetric value)?  $default,){
final _that = this;
switch (_that) {
case _SessionMetric() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime date,  int durationMinutes,  List<String> topicIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionMetric() when $default != null:
return $default(_that.userId,_that.date,_that.durationMinutes,_that.topicIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime date,  int durationMinutes,  List<String> topicIds)  $default,) {final _that = this;
switch (_that) {
case _SessionMetric():
return $default(_that.userId,_that.date,_that.durationMinutes,_that.topicIds);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime date,  int durationMinutes,  List<String> topicIds)?  $default,) {final _that = this;
switch (_that) {
case _SessionMetric() when $default != null:
return $default(_that.userId,_that.date,_that.durationMinutes,_that.topicIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionMetric extends SessionMetric {
  const _SessionMetric({required this.userId, required this.date, required this.durationMinutes, final  List<String> topicIds = const []}): _topicIds = topicIds,super._();
  factory _SessionMetric.fromJson(Map<String, dynamic> json) => _$SessionMetricFromJson(json);

@override final  String userId;
@override final  DateTime date;
@override final  int durationMinutes;
 final  List<String> _topicIds;
@override@JsonKey() List<String> get topicIds {
  if (_topicIds is EqualUnmodifiableListView) return _topicIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topicIds);
}


/// Create a copy of SessionMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionMetricCopyWith<_SessionMetric> get copyWith => __$SessionMetricCopyWithImpl<_SessionMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionMetric&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&const DeepCollectionEquality().equals(other._topicIds, _topicIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,date,durationMinutes,const DeepCollectionEquality().hash(_topicIds));

@override
String toString() {
  return 'SessionMetric(userId: $userId, date: $date, durationMinutes: $durationMinutes, topicIds: $topicIds)';
}


}

/// @nodoc
abstract mixin class _$SessionMetricCopyWith<$Res> implements $SessionMetricCopyWith<$Res> {
  factory _$SessionMetricCopyWith(_SessionMetric value, $Res Function(_SessionMetric) _then) = __$SessionMetricCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime date, int durationMinutes, List<String> topicIds
});




}
/// @nodoc
class __$SessionMetricCopyWithImpl<$Res>
    implements _$SessionMetricCopyWith<$Res> {
  __$SessionMetricCopyWithImpl(this._self, this._then);

  final _SessionMetric _self;
  final $Res Function(_SessionMetric) _then;

/// Create a copy of SessionMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? date = null,Object? durationMinutes = null,Object? topicIds = null,}) {
  return _then(_SessionMetric(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,topicIds: null == topicIds ? _self._topicIds : topicIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
