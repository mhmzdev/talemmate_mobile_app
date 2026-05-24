// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyWindow {

 String get id; String get label; String get startTime; String get endTime; bool get isEnabled;
/// Create a copy of StudyWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyWindowCopyWith<StudyWindow> get copyWith => _$StudyWindowCopyWithImpl<StudyWindow>(this as StudyWindow, _$identity);

  /// Serializes this StudyWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,startTime,endTime,isEnabled);

@override
String toString() {
  return 'StudyWindow(id: $id, label: $label, startTime: $startTime, endTime: $endTime, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $StudyWindowCopyWith<$Res>  {
  factory $StudyWindowCopyWith(StudyWindow value, $Res Function(StudyWindow) _then) = _$StudyWindowCopyWithImpl;
@useResult
$Res call({
 String id, String label, String startTime, String endTime, bool isEnabled
});




}
/// @nodoc
class _$StudyWindowCopyWithImpl<$Res>
    implements $StudyWindowCopyWith<$Res> {
  _$StudyWindowCopyWithImpl(this._self, this._then);

  final StudyWindow _self;
  final $Res Function(StudyWindow) _then;

/// Create a copy of StudyWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? startTime = null,Object? endTime = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyWindow].
extension StudyWindowPatterns on StudyWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyWindow value)  $default,){
final _that = this;
switch (_that) {
case _StudyWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyWindow value)?  $default,){
final _that = this;
switch (_that) {
case _StudyWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String startTime,  String endTime,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyWindow() when $default != null:
return $default(_that.id,_that.label,_that.startTime,_that.endTime,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String startTime,  String endTime,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _StudyWindow():
return $default(_that.id,_that.label,_that.startTime,_that.endTime,_that.isEnabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String startTime,  String endTime,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _StudyWindow() when $default != null:
return $default(_that.id,_that.label,_that.startTime,_that.endTime,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyWindow extends StudyWindow {
  const _StudyWindow({required this.id, required this.label, required this.startTime, required this.endTime, this.isEnabled = true}): super._();
  factory _StudyWindow.fromJson(Map<String, dynamic> json) => _$StudyWindowFromJson(json);

@override final  String id;
@override final  String label;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of StudyWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyWindowCopyWith<_StudyWindow> get copyWith => __$StudyWindowCopyWithImpl<_StudyWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,startTime,endTime,isEnabled);

@override
String toString() {
  return 'StudyWindow(id: $id, label: $label, startTime: $startTime, endTime: $endTime, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$StudyWindowCopyWith<$Res> implements $StudyWindowCopyWith<$Res> {
  factory _$StudyWindowCopyWith(_StudyWindow value, $Res Function(_StudyWindow) _then) = __$StudyWindowCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String startTime, String endTime, bool isEnabled
});




}
/// @nodoc
class __$StudyWindowCopyWithImpl<$Res>
    implements _$StudyWindowCopyWith<$Res> {
  __$StudyWindowCopyWithImpl(this._self, this._then);

  final _StudyWindow _self;
  final $Res Function(_StudyWindow) _then;

/// Create a copy of StudyWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? startTime = null,Object? endTime = null,Object? isEnabled = null,}) {
  return _then(_StudyWindow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
