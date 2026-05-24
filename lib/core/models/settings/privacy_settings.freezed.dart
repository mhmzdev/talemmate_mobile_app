// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacySettings {

 String get userId; bool get onDeviceProcessing; bool get cloudBackupEnabled; DateTime? get cloudBackupLastSync;
/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacySettingsCopyWith<PrivacySettings> get copyWith => _$PrivacySettingsCopyWithImpl<PrivacySettings>(this as PrivacySettings, _$identity);

  /// Serializes this PrivacySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacySettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onDeviceProcessing, onDeviceProcessing) || other.onDeviceProcessing == onDeviceProcessing)&&(identical(other.cloudBackupEnabled, cloudBackupEnabled) || other.cloudBackupEnabled == cloudBackupEnabled)&&(identical(other.cloudBackupLastSync, cloudBackupLastSync) || other.cloudBackupLastSync == cloudBackupLastSync));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,onDeviceProcessing,cloudBackupEnabled,cloudBackupLastSync);

@override
String toString() {
  return 'PrivacySettings(userId: $userId, onDeviceProcessing: $onDeviceProcessing, cloudBackupEnabled: $cloudBackupEnabled, cloudBackupLastSync: $cloudBackupLastSync)';
}


}

/// @nodoc
abstract mixin class $PrivacySettingsCopyWith<$Res>  {
  factory $PrivacySettingsCopyWith(PrivacySettings value, $Res Function(PrivacySettings) _then) = _$PrivacySettingsCopyWithImpl;
@useResult
$Res call({
 String userId, bool onDeviceProcessing, bool cloudBackupEnabled, DateTime? cloudBackupLastSync
});




}
/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._self, this._then);

  final PrivacySettings _self;
  final $Res Function(PrivacySettings) _then;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? onDeviceProcessing = null,Object? cloudBackupEnabled = null,Object? cloudBackupLastSync = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onDeviceProcessing: null == onDeviceProcessing ? _self.onDeviceProcessing : onDeviceProcessing // ignore: cast_nullable_to_non_nullable
as bool,cloudBackupEnabled: null == cloudBackupEnabled ? _self.cloudBackupEnabled : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
as bool,cloudBackupLastSync: freezed == cloudBackupLastSync ? _self.cloudBackupLastSync : cloudBackupLastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacySettings].
extension PrivacySettingsPatterns on PrivacySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacySettings value)  $default,){
final _that = this;
switch (_that) {
case _PrivacySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacySettings value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool onDeviceProcessing,  bool cloudBackupEnabled,  DateTime? cloudBackupLastSync)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
return $default(_that.userId,_that.onDeviceProcessing,_that.cloudBackupEnabled,_that.cloudBackupLastSync);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool onDeviceProcessing,  bool cloudBackupEnabled,  DateTime? cloudBackupLastSync)  $default,) {final _that = this;
switch (_that) {
case _PrivacySettings():
return $default(_that.userId,_that.onDeviceProcessing,_that.cloudBackupEnabled,_that.cloudBackupLastSync);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool onDeviceProcessing,  bool cloudBackupEnabled,  DateTime? cloudBackupLastSync)?  $default,) {final _that = this;
switch (_that) {
case _PrivacySettings() when $default != null:
return $default(_that.userId,_that.onDeviceProcessing,_that.cloudBackupEnabled,_that.cloudBackupLastSync);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivacySettings extends PrivacySettings {
  const _PrivacySettings({required this.userId, this.onDeviceProcessing = false, this.cloudBackupEnabled = false, this.cloudBackupLastSync}): super._();
  factory _PrivacySettings.fromJson(Map<String, dynamic> json) => _$PrivacySettingsFromJson(json);

@override final  String userId;
@override@JsonKey() final  bool onDeviceProcessing;
@override@JsonKey() final  bool cloudBackupEnabled;
@override final  DateTime? cloudBackupLastSync;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacySettingsCopyWith<_PrivacySettings> get copyWith => __$PrivacySettingsCopyWithImpl<_PrivacySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivacySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacySettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onDeviceProcessing, onDeviceProcessing) || other.onDeviceProcessing == onDeviceProcessing)&&(identical(other.cloudBackupEnabled, cloudBackupEnabled) || other.cloudBackupEnabled == cloudBackupEnabled)&&(identical(other.cloudBackupLastSync, cloudBackupLastSync) || other.cloudBackupLastSync == cloudBackupLastSync));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,onDeviceProcessing,cloudBackupEnabled,cloudBackupLastSync);

@override
String toString() {
  return 'PrivacySettings(userId: $userId, onDeviceProcessing: $onDeviceProcessing, cloudBackupEnabled: $cloudBackupEnabled, cloudBackupLastSync: $cloudBackupLastSync)';
}


}

/// @nodoc
abstract mixin class _$PrivacySettingsCopyWith<$Res> implements $PrivacySettingsCopyWith<$Res> {
  factory _$PrivacySettingsCopyWith(_PrivacySettings value, $Res Function(_PrivacySettings) _then) = __$PrivacySettingsCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool onDeviceProcessing, bool cloudBackupEnabled, DateTime? cloudBackupLastSync
});




}
/// @nodoc
class __$PrivacySettingsCopyWithImpl<$Res>
    implements _$PrivacySettingsCopyWith<$Res> {
  __$PrivacySettingsCopyWithImpl(this._self, this._then);

  final _PrivacySettings _self;
  final $Res Function(_PrivacySettings) _then;

/// Create a copy of PrivacySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? onDeviceProcessing = null,Object? cloudBackupEnabled = null,Object? cloudBackupLastSync = freezed,}) {
  return _then(_PrivacySettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onDeviceProcessing: null == onDeviceProcessing ? _self.onDeviceProcessing : onDeviceProcessing // ignore: cast_nullable_to_non_nullable
as bool,cloudBackupEnabled: null == cloudBackupEnabled ? _self.cloudBackupEnabled : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
as bool,cloudBackupLastSync: freezed == cloudBackupLastSync ? _self.cloudBackupLastSync : cloudBackupLastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
