// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreRange {

 int get min; int get max;
/// Create a copy of ScoreRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreRangeCopyWith<ScoreRange> get copyWith => _$ScoreRangeCopyWithImpl<ScoreRange>(this as ScoreRange, _$identity);

  /// Serializes this ScoreRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreRange&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'ScoreRange(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class $ScoreRangeCopyWith<$Res>  {
  factory $ScoreRangeCopyWith(ScoreRange value, $Res Function(ScoreRange) _then) = _$ScoreRangeCopyWithImpl;
@useResult
$Res call({
 int min, int max
});




}
/// @nodoc
class _$ScoreRangeCopyWithImpl<$Res>
    implements $ScoreRangeCopyWith<$Res> {
  _$ScoreRangeCopyWithImpl(this._self, this._then);

  final ScoreRange _self;
  final $Res Function(ScoreRange) _then;

/// Create a copy of ScoreRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? min = null,Object? max = null,}) {
  return _then(_self.copyWith(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreRange].
extension ScoreRangePatterns on ScoreRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreRange value)  $default,){
final _that = this;
switch (_that) {
case _ScoreRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreRange value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int min,  int max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreRange() when $default != null:
return $default(_that.min,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int min,  int max)  $default,) {final _that = this;
switch (_that) {
case _ScoreRange():
return $default(_that.min,_that.max);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int min,  int max)?  $default,) {final _that = this;
switch (_that) {
case _ScoreRange() when $default != null:
return $default(_that.min,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreRange extends ScoreRange {
  const _ScoreRange({required this.min, required this.max}): super._();
  factory _ScoreRange.fromJson(Map<String, dynamic> json) => _$ScoreRangeFromJson(json);

@override final  int min;
@override final  int max;

/// Create a copy of ScoreRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreRangeCopyWith<_ScoreRange> get copyWith => __$ScoreRangeCopyWithImpl<_ScoreRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreRangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreRange&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'ScoreRange(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class _$ScoreRangeCopyWith<$Res> implements $ScoreRangeCopyWith<$Res> {
  factory _$ScoreRangeCopyWith(_ScoreRange value, $Res Function(_ScoreRange) _then) = __$ScoreRangeCopyWithImpl;
@override @useResult
$Res call({
 int min, int max
});




}
/// @nodoc
class __$ScoreRangeCopyWithImpl<$Res>
    implements _$ScoreRangeCopyWith<$Res> {
  __$ScoreRangeCopyWithImpl(this._self, this._then);

  final _ScoreRange _self;
  final $Res Function(_ScoreRange) _then;

/// Create a copy of ScoreRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? min = null,Object? max = null,}) {
  return _then(_ScoreRange(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
