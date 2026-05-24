// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressMetric {

 String get userId; String get subjectId; int get readinessScore; DateTime get lastUpdatedAt; ScoreRange? get predictedScoreRange; int? get weeklyGain; String? get aiInsight;
/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressMetricCopyWith<ProgressMetric> get copyWith => _$ProgressMetricCopyWithImpl<ProgressMetric>(this as ProgressMetric, _$identity);

  /// Serializes this ProgressMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressMetric&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.predictedScoreRange, predictedScoreRange) || other.predictedScoreRange == predictedScoreRange)&&(identical(other.weeklyGain, weeklyGain) || other.weeklyGain == weeklyGain)&&(identical(other.aiInsight, aiInsight) || other.aiInsight == aiInsight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,subjectId,readinessScore,lastUpdatedAt,predictedScoreRange,weeklyGain,aiInsight);

@override
String toString() {
  return 'ProgressMetric(userId: $userId, subjectId: $subjectId, readinessScore: $readinessScore, lastUpdatedAt: $lastUpdatedAt, predictedScoreRange: $predictedScoreRange, weeklyGain: $weeklyGain, aiInsight: $aiInsight)';
}


}

/// @nodoc
abstract mixin class $ProgressMetricCopyWith<$Res>  {
  factory $ProgressMetricCopyWith(ProgressMetric value, $Res Function(ProgressMetric) _then) = _$ProgressMetricCopyWithImpl;
@useResult
$Res call({
 String userId, String subjectId, int readinessScore, DateTime lastUpdatedAt, ScoreRange? predictedScoreRange, int? weeklyGain, String? aiInsight
});


$ScoreRangeCopyWith<$Res>? get predictedScoreRange;

}
/// @nodoc
class _$ProgressMetricCopyWithImpl<$Res>
    implements $ProgressMetricCopyWith<$Res> {
  _$ProgressMetricCopyWithImpl(this._self, this._then);

  final ProgressMetric _self;
  final $Res Function(ProgressMetric) _then;

/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? subjectId = null,Object? readinessScore = null,Object? lastUpdatedAt = null,Object? predictedScoreRange = freezed,Object? weeklyGain = freezed,Object? aiInsight = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,predictedScoreRange: freezed == predictedScoreRange ? _self.predictedScoreRange : predictedScoreRange // ignore: cast_nullable_to_non_nullable
as ScoreRange?,weeklyGain: freezed == weeklyGain ? _self.weeklyGain : weeklyGain // ignore: cast_nullable_to_non_nullable
as int?,aiInsight: freezed == aiInsight ? _self.aiInsight : aiInsight // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoreRangeCopyWith<$Res>? get predictedScoreRange {
    if (_self.predictedScoreRange == null) {
    return null;
  }

  return $ScoreRangeCopyWith<$Res>(_self.predictedScoreRange!, (value) {
    return _then(_self.copyWith(predictedScoreRange: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressMetric].
extension ProgressMetricPatterns on ProgressMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressMetric value)  $default,){
final _that = this;
switch (_that) {
case _ProgressMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressMetric value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String subjectId,  int readinessScore,  DateTime lastUpdatedAt,  ScoreRange? predictedScoreRange,  int? weeklyGain,  String? aiInsight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressMetric() when $default != null:
return $default(_that.userId,_that.subjectId,_that.readinessScore,_that.lastUpdatedAt,_that.predictedScoreRange,_that.weeklyGain,_that.aiInsight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String subjectId,  int readinessScore,  DateTime lastUpdatedAt,  ScoreRange? predictedScoreRange,  int? weeklyGain,  String? aiInsight)  $default,) {final _that = this;
switch (_that) {
case _ProgressMetric():
return $default(_that.userId,_that.subjectId,_that.readinessScore,_that.lastUpdatedAt,_that.predictedScoreRange,_that.weeklyGain,_that.aiInsight);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String subjectId,  int readinessScore,  DateTime lastUpdatedAt,  ScoreRange? predictedScoreRange,  int? weeklyGain,  String? aiInsight)?  $default,) {final _that = this;
switch (_that) {
case _ProgressMetric() when $default != null:
return $default(_that.userId,_that.subjectId,_that.readinessScore,_that.lastUpdatedAt,_that.predictedScoreRange,_that.weeklyGain,_that.aiInsight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressMetric extends ProgressMetric {
  const _ProgressMetric({required this.userId, required this.subjectId, required this.readinessScore, required this.lastUpdatedAt, this.predictedScoreRange, this.weeklyGain, this.aiInsight}): super._();
  factory _ProgressMetric.fromJson(Map<String, dynamic> json) => _$ProgressMetricFromJson(json);

@override final  String userId;
@override final  String subjectId;
@override final  int readinessScore;
@override final  DateTime lastUpdatedAt;
@override final  ScoreRange? predictedScoreRange;
@override final  int? weeklyGain;
@override final  String? aiInsight;

/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressMetricCopyWith<_ProgressMetric> get copyWith => __$ProgressMetricCopyWithImpl<_ProgressMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressMetric&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.predictedScoreRange, predictedScoreRange) || other.predictedScoreRange == predictedScoreRange)&&(identical(other.weeklyGain, weeklyGain) || other.weeklyGain == weeklyGain)&&(identical(other.aiInsight, aiInsight) || other.aiInsight == aiInsight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,subjectId,readinessScore,lastUpdatedAt,predictedScoreRange,weeklyGain,aiInsight);

@override
String toString() {
  return 'ProgressMetric(userId: $userId, subjectId: $subjectId, readinessScore: $readinessScore, lastUpdatedAt: $lastUpdatedAt, predictedScoreRange: $predictedScoreRange, weeklyGain: $weeklyGain, aiInsight: $aiInsight)';
}


}

/// @nodoc
abstract mixin class _$ProgressMetricCopyWith<$Res> implements $ProgressMetricCopyWith<$Res> {
  factory _$ProgressMetricCopyWith(_ProgressMetric value, $Res Function(_ProgressMetric) _then) = __$ProgressMetricCopyWithImpl;
@override @useResult
$Res call({
 String userId, String subjectId, int readinessScore, DateTime lastUpdatedAt, ScoreRange? predictedScoreRange, int? weeklyGain, String? aiInsight
});


@override $ScoreRangeCopyWith<$Res>? get predictedScoreRange;

}
/// @nodoc
class __$ProgressMetricCopyWithImpl<$Res>
    implements _$ProgressMetricCopyWith<$Res> {
  __$ProgressMetricCopyWithImpl(this._self, this._then);

  final _ProgressMetric _self;
  final $Res Function(_ProgressMetric) _then;

/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? subjectId = null,Object? readinessScore = null,Object? lastUpdatedAt = null,Object? predictedScoreRange = freezed,Object? weeklyGain = freezed,Object? aiInsight = freezed,}) {
  return _then(_ProgressMetric(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,predictedScoreRange: freezed == predictedScoreRange ? _self.predictedScoreRange : predictedScoreRange // ignore: cast_nullable_to_non_nullable
as ScoreRange?,weeklyGain: freezed == weeklyGain ? _self.weeklyGain : weeklyGain // ignore: cast_nullable_to_non_nullable
as int?,aiInsight: freezed == aiInsight ? _self.aiInsight : aiInsight // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProgressMetric
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoreRangeCopyWith<$Res>? get predictedScoreRange {
    if (_self.predictedScoreRange == null) {
    return null;
  }

  return $ScoreRangeCopyWith<$Res>(_self.predictedScoreRange!, (value) {
    return _then(_self.copyWith(predictedScoreRange: value));
  });
}
}

// dart format on
