// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LanguagePreferences {

 String get userId; AppLanguage get appLanguage; bool get useUrduNastaliq;
/// Create a copy of LanguagePreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguagePreferencesCopyWith<LanguagePreferences> get copyWith => _$LanguagePreferencesCopyWithImpl<LanguagePreferences>(this as LanguagePreferences, _$identity);

  /// Serializes this LanguagePreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguagePreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.appLanguage, appLanguage) || other.appLanguage == appLanguage)&&(identical(other.useUrduNastaliq, useUrduNastaliq) || other.useUrduNastaliq == useUrduNastaliq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,appLanguage,useUrduNastaliq);

@override
String toString() {
  return 'LanguagePreferences(userId: $userId, appLanguage: $appLanguage, useUrduNastaliq: $useUrduNastaliq)';
}


}

/// @nodoc
abstract mixin class $LanguagePreferencesCopyWith<$Res>  {
  factory $LanguagePreferencesCopyWith(LanguagePreferences value, $Res Function(LanguagePreferences) _then) = _$LanguagePreferencesCopyWithImpl;
@useResult
$Res call({
 String userId, AppLanguage appLanguage, bool useUrduNastaliq
});




}
/// @nodoc
class _$LanguagePreferencesCopyWithImpl<$Res>
    implements $LanguagePreferencesCopyWith<$Res> {
  _$LanguagePreferencesCopyWithImpl(this._self, this._then);

  final LanguagePreferences _self;
  final $Res Function(LanguagePreferences) _then;

/// Create a copy of LanguagePreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? appLanguage = null,Object? useUrduNastaliq = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,appLanguage: null == appLanguage ? _self.appLanguage : appLanguage // ignore: cast_nullable_to_non_nullable
as AppLanguage,useUrduNastaliq: null == useUrduNastaliq ? _self.useUrduNastaliq : useUrduNastaliq // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LanguagePreferences].
extension LanguagePreferencesPatterns on LanguagePreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanguagePreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanguagePreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanguagePreferences value)  $default,){
final _that = this;
switch (_that) {
case _LanguagePreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanguagePreferences value)?  $default,){
final _that = this;
switch (_that) {
case _LanguagePreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  AppLanguage appLanguage,  bool useUrduNastaliq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanguagePreferences() when $default != null:
return $default(_that.userId,_that.appLanguage,_that.useUrduNastaliq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  AppLanguage appLanguage,  bool useUrduNastaliq)  $default,) {final _that = this;
switch (_that) {
case _LanguagePreferences():
return $default(_that.userId,_that.appLanguage,_that.useUrduNastaliq);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  AppLanguage appLanguage,  bool useUrduNastaliq)?  $default,) {final _that = this;
switch (_that) {
case _LanguagePreferences() when $default != null:
return $default(_that.userId,_that.appLanguage,_that.useUrduNastaliq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanguagePreferences extends LanguagePreferences {
  const _LanguagePreferences({required this.userId, this.appLanguage = AppLanguage.english, this.useUrduNastaliq = false}): super._();
  factory _LanguagePreferences.fromJson(Map<String, dynamic> json) => _$LanguagePreferencesFromJson(json);

@override final  String userId;
@override@JsonKey() final  AppLanguage appLanguage;
@override@JsonKey() final  bool useUrduNastaliq;

/// Create a copy of LanguagePreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguagePreferencesCopyWith<_LanguagePreferences> get copyWith => __$LanguagePreferencesCopyWithImpl<_LanguagePreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguagePreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanguagePreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.appLanguage, appLanguage) || other.appLanguage == appLanguage)&&(identical(other.useUrduNastaliq, useUrduNastaliq) || other.useUrduNastaliq == useUrduNastaliq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,appLanguage,useUrduNastaliq);

@override
String toString() {
  return 'LanguagePreferences(userId: $userId, appLanguage: $appLanguage, useUrduNastaliq: $useUrduNastaliq)';
}


}

/// @nodoc
abstract mixin class _$LanguagePreferencesCopyWith<$Res> implements $LanguagePreferencesCopyWith<$Res> {
  factory _$LanguagePreferencesCopyWith(_LanguagePreferences value, $Res Function(_LanguagePreferences) _then) = __$LanguagePreferencesCopyWithImpl;
@override @useResult
$Res call({
 String userId, AppLanguage appLanguage, bool useUrduNastaliq
});




}
/// @nodoc
class __$LanguagePreferencesCopyWithImpl<$Res>
    implements _$LanguagePreferencesCopyWith<$Res> {
  __$LanguagePreferencesCopyWithImpl(this._self, this._then);

  final _LanguagePreferences _self;
  final $Res Function(_LanguagePreferences) _then;

/// Create a copy of LanguagePreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? appLanguage = null,Object? useUrduNastaliq = null,}) {
  return _then(_LanguagePreferences(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,appLanguage: null == appLanguage ? _self.appLanguage : appLanguage // ignore: cast_nullable_to_non_nullable
as AppLanguage,useUrduNastaliq: null == useUrduNastaliq ? _self.useUrduNastaliq : useUrduNastaliq // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
