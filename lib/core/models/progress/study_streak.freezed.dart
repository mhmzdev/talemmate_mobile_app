// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyStreak {

 String get userId; int get dayCount; DateTime get lastStudiedDate; DateTime get startDate;
/// Create a copy of StudyStreak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyStreakCopyWith<StudyStreak> get copyWith => _$StudyStreakCopyWithImpl<StudyStreak>(this as StudyStreak, _$identity);

  /// Serializes this StudyStreak to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyStreak&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dayCount, dayCount) || other.dayCount == dayCount)&&(identical(other.lastStudiedDate, lastStudiedDate) || other.lastStudiedDate == lastStudiedDate)&&(identical(other.startDate, startDate) || other.startDate == startDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,dayCount,lastStudiedDate,startDate);

@override
String toString() {
  return 'StudyStreak(userId: $userId, dayCount: $dayCount, lastStudiedDate: $lastStudiedDate, startDate: $startDate)';
}


}

/// @nodoc
abstract mixin class $StudyStreakCopyWith<$Res>  {
  factory $StudyStreakCopyWith(StudyStreak value, $Res Function(StudyStreak) _then) = _$StudyStreakCopyWithImpl;
@useResult
$Res call({
 String userId, int dayCount, DateTime lastStudiedDate, DateTime startDate
});




}
/// @nodoc
class _$StudyStreakCopyWithImpl<$Res>
    implements $StudyStreakCopyWith<$Res> {
  _$StudyStreakCopyWithImpl(this._self, this._then);

  final StudyStreak _self;
  final $Res Function(StudyStreak) _then;

/// Create a copy of StudyStreak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? dayCount = null,Object? lastStudiedDate = null,Object? startDate = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dayCount: null == dayCount ? _self.dayCount : dayCount // ignore: cast_nullable_to_non_nullable
as int,lastStudiedDate: null == lastStudiedDate ? _self.lastStudiedDate : lastStudiedDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyStreak].
extension StudyStreakPatterns on StudyStreak {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyStreak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyStreak() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyStreak value)  $default,){
final _that = this;
switch (_that) {
case _StudyStreak():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyStreak value)?  $default,){
final _that = this;
switch (_that) {
case _StudyStreak() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int dayCount,  DateTime lastStudiedDate,  DateTime startDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyStreak() when $default != null:
return $default(_that.userId,_that.dayCount,_that.lastStudiedDate,_that.startDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int dayCount,  DateTime lastStudiedDate,  DateTime startDate)  $default,) {final _that = this;
switch (_that) {
case _StudyStreak():
return $default(_that.userId,_that.dayCount,_that.lastStudiedDate,_that.startDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int dayCount,  DateTime lastStudiedDate,  DateTime startDate)?  $default,) {final _that = this;
switch (_that) {
case _StudyStreak() when $default != null:
return $default(_that.userId,_that.dayCount,_that.lastStudiedDate,_that.startDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyStreak extends StudyStreak {
  const _StudyStreak({required this.userId, required this.dayCount, required this.lastStudiedDate, required this.startDate}): super._();
  factory _StudyStreak.fromJson(Map<String, dynamic> json) => _$StudyStreakFromJson(json);

@override final  String userId;
@override final  int dayCount;
@override final  DateTime lastStudiedDate;
@override final  DateTime startDate;

/// Create a copy of StudyStreak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyStreakCopyWith<_StudyStreak> get copyWith => __$StudyStreakCopyWithImpl<_StudyStreak>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyStreakToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyStreak&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dayCount, dayCount) || other.dayCount == dayCount)&&(identical(other.lastStudiedDate, lastStudiedDate) || other.lastStudiedDate == lastStudiedDate)&&(identical(other.startDate, startDate) || other.startDate == startDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,dayCount,lastStudiedDate,startDate);

@override
String toString() {
  return 'StudyStreak(userId: $userId, dayCount: $dayCount, lastStudiedDate: $lastStudiedDate, startDate: $startDate)';
}


}

/// @nodoc
abstract mixin class _$StudyStreakCopyWith<$Res> implements $StudyStreakCopyWith<$Res> {
  factory _$StudyStreakCopyWith(_StudyStreak value, $Res Function(_StudyStreak) _then) = __$StudyStreakCopyWithImpl;
@override @useResult
$Res call({
 String userId, int dayCount, DateTime lastStudiedDate, DateTime startDate
});




}
/// @nodoc
class __$StudyStreakCopyWithImpl<$Res>
    implements _$StudyStreakCopyWith<$Res> {
  __$StudyStreakCopyWithImpl(this._self, this._then);

  final _StudyStreak _self;
  final $Res Function(_StudyStreak) _then;

/// Create a copy of StudyStreak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? dayCount = null,Object? lastStudiedDate = null,Object? startDate = null,}) {
  return _then(_StudyStreak(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dayCount: null == dayCount ? _self.dayCount : dayCount // ignore: cast_nullable_to_non_nullable
as int,lastStudiedDate: null == lastStudiedDate ? _self.lastStudiedDate : lastStudiedDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
