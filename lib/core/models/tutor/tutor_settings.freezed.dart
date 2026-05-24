// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutor_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TutorSettings {

 String get userId; bool get showCitationsOnEveryReply; TutorScope get scope; ReasoningDepth get reasoningDepth;
/// Create a copy of TutorSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorSettingsCopyWith<TutorSettings> get copyWith => _$TutorSettingsCopyWithImpl<TutorSettings>(this as TutorSettings, _$identity);

  /// Serializes this TutorSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.showCitationsOnEveryReply, showCitationsOnEveryReply) || other.showCitationsOnEveryReply == showCitationsOnEveryReply)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.reasoningDepth, reasoningDepth) || other.reasoningDepth == reasoningDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,showCitationsOnEveryReply,scope,reasoningDepth);

@override
String toString() {
  return 'TutorSettings(userId: $userId, showCitationsOnEveryReply: $showCitationsOnEveryReply, scope: $scope, reasoningDepth: $reasoningDepth)';
}


}

/// @nodoc
abstract mixin class $TutorSettingsCopyWith<$Res>  {
  factory $TutorSettingsCopyWith(TutorSettings value, $Res Function(TutorSettings) _then) = _$TutorSettingsCopyWithImpl;
@useResult
$Res call({
 String userId, bool showCitationsOnEveryReply, TutorScope scope, ReasoningDepth reasoningDepth
});




}
/// @nodoc
class _$TutorSettingsCopyWithImpl<$Res>
    implements $TutorSettingsCopyWith<$Res> {
  _$TutorSettingsCopyWithImpl(this._self, this._then);

  final TutorSettings _self;
  final $Res Function(TutorSettings) _then;

/// Create a copy of TutorSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? showCitationsOnEveryReply = null,Object? scope = null,Object? reasoningDepth = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,showCitationsOnEveryReply: null == showCitationsOnEveryReply ? _self.showCitationsOnEveryReply : showCitationsOnEveryReply // ignore: cast_nullable_to_non_nullable
as bool,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TutorScope,reasoningDepth: null == reasoningDepth ? _self.reasoningDepth : reasoningDepth // ignore: cast_nullable_to_non_nullable
as ReasoningDepth,
  ));
}

}


/// Adds pattern-matching-related methods to [TutorSettings].
extension TutorSettingsPatterns on TutorSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TutorSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TutorSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TutorSettings value)  $default,){
final _that = this;
switch (_that) {
case _TutorSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TutorSettings value)?  $default,){
final _that = this;
switch (_that) {
case _TutorSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool showCitationsOnEveryReply,  TutorScope scope,  ReasoningDepth reasoningDepth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TutorSettings() when $default != null:
return $default(_that.userId,_that.showCitationsOnEveryReply,_that.scope,_that.reasoningDepth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool showCitationsOnEveryReply,  TutorScope scope,  ReasoningDepth reasoningDepth)  $default,) {final _that = this;
switch (_that) {
case _TutorSettings():
return $default(_that.userId,_that.showCitationsOnEveryReply,_that.scope,_that.reasoningDepth);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool showCitationsOnEveryReply,  TutorScope scope,  ReasoningDepth reasoningDepth)?  $default,) {final _that = this;
switch (_that) {
case _TutorSettings() when $default != null:
return $default(_that.userId,_that.showCitationsOnEveryReply,_that.scope,_that.reasoningDepth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TutorSettings extends TutorSettings {
  const _TutorSettings({required this.userId, this.showCitationsOnEveryReply = true, this.scope = TutorScope.libraryAndLectures, this.reasoningDepth = ReasoningDepth.balanced}): super._();
  factory _TutorSettings.fromJson(Map<String, dynamic> json) => _$TutorSettingsFromJson(json);

@override final  String userId;
@override@JsonKey() final  bool showCitationsOnEveryReply;
@override@JsonKey() final  TutorScope scope;
@override@JsonKey() final  ReasoningDepth reasoningDepth;

/// Create a copy of TutorSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TutorSettingsCopyWith<_TutorSettings> get copyWith => __$TutorSettingsCopyWithImpl<_TutorSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TutorSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TutorSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.showCitationsOnEveryReply, showCitationsOnEveryReply) || other.showCitationsOnEveryReply == showCitationsOnEveryReply)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.reasoningDepth, reasoningDepth) || other.reasoningDepth == reasoningDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,showCitationsOnEveryReply,scope,reasoningDepth);

@override
String toString() {
  return 'TutorSettings(userId: $userId, showCitationsOnEveryReply: $showCitationsOnEveryReply, scope: $scope, reasoningDepth: $reasoningDepth)';
}


}

/// @nodoc
abstract mixin class _$TutorSettingsCopyWith<$Res> implements $TutorSettingsCopyWith<$Res> {
  factory _$TutorSettingsCopyWith(_TutorSettings value, $Res Function(_TutorSettings) _then) = __$TutorSettingsCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool showCitationsOnEveryReply, TutorScope scope, ReasoningDepth reasoningDepth
});




}
/// @nodoc
class __$TutorSettingsCopyWithImpl<$Res>
    implements _$TutorSettingsCopyWith<$Res> {
  __$TutorSettingsCopyWithImpl(this._self, this._then);

  final _TutorSettings _self;
  final $Res Function(_TutorSettings) _then;

/// Create a copy of TutorSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? showCitationsOnEveryReply = null,Object? scope = null,Object? reasoningDepth = null,}) {
  return _then(_TutorSettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,showCitationsOnEveryReply: null == showCitationsOnEveryReply ? _self.showCitationsOnEveryReply : showCitationsOnEveryReply // ignore: cast_nullable_to_non_nullable
as bool,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TutorScope,reasoningDepth: null == reasoningDepth ? _self.reasoningDepth : reasoningDepth // ignore: cast_nullable_to_non_nullable
as ReasoningDepth,
  ));
}


}

// dart format on
