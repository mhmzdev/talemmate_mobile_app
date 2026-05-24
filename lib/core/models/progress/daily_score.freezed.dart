// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyScore {

 DateTime get date; int get score; String? get topicId;
/// Create a copy of DailyScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyScoreCopyWith<DailyScore> get copyWith => _$DailyScoreCopyWithImpl<DailyScore>(this as DailyScore, _$identity);

  /// Serializes this DailyScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyScore&&(identical(other.date, date) || other.date == date)&&(identical(other.score, score) || other.score == score)&&(identical(other.topicId, topicId) || other.topicId == topicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,score,topicId);

@override
String toString() {
  return 'DailyScore(date: $date, score: $score, topicId: $topicId)';
}


}

/// @nodoc
abstract mixin class $DailyScoreCopyWith<$Res>  {
  factory $DailyScoreCopyWith(DailyScore value, $Res Function(DailyScore) _then) = _$DailyScoreCopyWithImpl;
@useResult
$Res call({
 DateTime date, int score, String? topicId
});




}
/// @nodoc
class _$DailyScoreCopyWithImpl<$Res>
    implements $DailyScoreCopyWith<$Res> {
  _$DailyScoreCopyWithImpl(this._self, this._then);

  final DailyScore _self;
  final $Res Function(DailyScore) _then;

/// Create a copy of DailyScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? score = null,Object? topicId = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyScore].
extension DailyScorePatterns on DailyScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyScore value)  $default,){
final _that = this;
switch (_that) {
case _DailyScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyScore value)?  $default,){
final _that = this;
switch (_that) {
case _DailyScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int score,  String? topicId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyScore() when $default != null:
return $default(_that.date,_that.score,_that.topicId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int score,  String? topicId)  $default,) {final _that = this;
switch (_that) {
case _DailyScore():
return $default(_that.date,_that.score,_that.topicId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int score,  String? topicId)?  $default,) {final _that = this;
switch (_that) {
case _DailyScore() when $default != null:
return $default(_that.date,_that.score,_that.topicId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyScore extends DailyScore {
  const _DailyScore({required this.date, required this.score, this.topicId}): super._();
  factory _DailyScore.fromJson(Map<String, dynamic> json) => _$DailyScoreFromJson(json);

@override final  DateTime date;
@override final  int score;
@override final  String? topicId;

/// Create a copy of DailyScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyScoreCopyWith<_DailyScore> get copyWith => __$DailyScoreCopyWithImpl<_DailyScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyScore&&(identical(other.date, date) || other.date == date)&&(identical(other.score, score) || other.score == score)&&(identical(other.topicId, topicId) || other.topicId == topicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,score,topicId);

@override
String toString() {
  return 'DailyScore(date: $date, score: $score, topicId: $topicId)';
}


}

/// @nodoc
abstract mixin class _$DailyScoreCopyWith<$Res> implements $DailyScoreCopyWith<$Res> {
  factory _$DailyScoreCopyWith(_DailyScore value, $Res Function(_DailyScore) _then) = __$DailyScoreCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int score, String? topicId
});




}
/// @nodoc
class __$DailyScoreCopyWithImpl<$Res>
    implements _$DailyScoreCopyWith<$Res> {
  __$DailyScoreCopyWithImpl(this._self, this._then);

  final _DailyScore _self;
  final $Res Function(_DailyScore) _then;

/// Create a copy of DailyScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? score = null,Object? topicId = freezed,}) {
  return _then(_DailyScore(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
