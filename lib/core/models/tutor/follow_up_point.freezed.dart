// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_up_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowUpPoint {

 String get label; String get body;
/// Create a copy of FollowUpPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowUpPointCopyWith<FollowUpPoint> get copyWith => _$FollowUpPointCopyWithImpl<FollowUpPoint>(this as FollowUpPoint, _$identity);

  /// Serializes this FollowUpPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowUpPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,body);

@override
String toString() {
  return 'FollowUpPoint(label: $label, body: $body)';
}


}

/// @nodoc
abstract mixin class $FollowUpPointCopyWith<$Res>  {
  factory $FollowUpPointCopyWith(FollowUpPoint value, $Res Function(FollowUpPoint) _then) = _$FollowUpPointCopyWithImpl;
@useResult
$Res call({
 String label, String body
});




}
/// @nodoc
class _$FollowUpPointCopyWithImpl<$Res>
    implements $FollowUpPointCopyWith<$Res> {
  _$FollowUpPointCopyWithImpl(this._self, this._then);

  final FollowUpPoint _self;
  final $Res Function(FollowUpPoint) _then;

/// Create a copy of FollowUpPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? body = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowUpPoint].
extension FollowUpPointPatterns on FollowUpPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowUpPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowUpPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowUpPoint value)  $default,){
final _that = this;
switch (_that) {
case _FollowUpPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowUpPoint value)?  $default,){
final _that = this;
switch (_that) {
case _FollowUpPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowUpPoint() when $default != null:
return $default(_that.label,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String body)  $default,) {final _that = this;
switch (_that) {
case _FollowUpPoint():
return $default(_that.label,_that.body);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String body)?  $default,) {final _that = this;
switch (_that) {
case _FollowUpPoint() when $default != null:
return $default(_that.label,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowUpPoint extends FollowUpPoint {
  const _FollowUpPoint({required this.label, required this.body}): super._();
  factory _FollowUpPoint.fromJson(Map<String, dynamic> json) => _$FollowUpPointFromJson(json);

@override final  String label;
@override final  String body;

/// Create a copy of FollowUpPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowUpPointCopyWith<_FollowUpPoint> get copyWith => __$FollowUpPointCopyWithImpl<_FollowUpPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowUpPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowUpPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,body);

@override
String toString() {
  return 'FollowUpPoint(label: $label, body: $body)';
}


}

/// @nodoc
abstract mixin class _$FollowUpPointCopyWith<$Res> implements $FollowUpPointCopyWith<$Res> {
  factory _$FollowUpPointCopyWith(_FollowUpPoint value, $Res Function(_FollowUpPoint) _then) = __$FollowUpPointCopyWithImpl;
@override @useResult
$Res call({
 String label, String body
});




}
/// @nodoc
class __$FollowUpPointCopyWithImpl<$Res>
    implements _$FollowUpPointCopyWith<$Res> {
  __$FollowUpPointCopyWithImpl(this._self, this._then);

  final _FollowUpPoint _self;
  final $Res Function(_FollowUpPoint) _then;

/// Create a copy of FollowUpPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? body = null,}) {
  return _then(_FollowUpPoint(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
