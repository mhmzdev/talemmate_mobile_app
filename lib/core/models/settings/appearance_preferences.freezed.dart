// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appearance_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppearancePreferences {

 String get userId; ThemeSetting get theme; bool get showDuaCard; bool get showHijriDate; String? get dailyDuaText;
/// Create a copy of AppearancePreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppearancePreferencesCopyWith<AppearancePreferences> get copyWith => _$AppearancePreferencesCopyWithImpl<AppearancePreferences>(this as AppearancePreferences, _$identity);

  /// Serializes this AppearancePreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppearancePreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.showDuaCard, showDuaCard) || other.showDuaCard == showDuaCard)&&(identical(other.showHijriDate, showHijriDate) || other.showHijriDate == showHijriDate)&&(identical(other.dailyDuaText, dailyDuaText) || other.dailyDuaText == dailyDuaText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,theme,showDuaCard,showHijriDate,dailyDuaText);

@override
String toString() {
  return 'AppearancePreferences(userId: $userId, theme: $theme, showDuaCard: $showDuaCard, showHijriDate: $showHijriDate, dailyDuaText: $dailyDuaText)';
}


}

/// @nodoc
abstract mixin class $AppearancePreferencesCopyWith<$Res>  {
  factory $AppearancePreferencesCopyWith(AppearancePreferences value, $Res Function(AppearancePreferences) _then) = _$AppearancePreferencesCopyWithImpl;
@useResult
$Res call({
 String userId, ThemeSetting theme, bool showDuaCard, bool showHijriDate, String? dailyDuaText
});




}
/// @nodoc
class _$AppearancePreferencesCopyWithImpl<$Res>
    implements $AppearancePreferencesCopyWith<$Res> {
  _$AppearancePreferencesCopyWithImpl(this._self, this._then);

  final AppearancePreferences _self;
  final $Res Function(AppearancePreferences) _then;

/// Create a copy of AppearancePreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? theme = null,Object? showDuaCard = null,Object? showHijriDate = null,Object? dailyDuaText = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeSetting,showDuaCard: null == showDuaCard ? _self.showDuaCard : showDuaCard // ignore: cast_nullable_to_non_nullable
as bool,showHijriDate: null == showHijriDate ? _self.showHijriDate : showHijriDate // ignore: cast_nullable_to_non_nullable
as bool,dailyDuaText: freezed == dailyDuaText ? _self.dailyDuaText : dailyDuaText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppearancePreferences].
extension AppearancePreferencesPatterns on AppearancePreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppearancePreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppearancePreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppearancePreferences value)  $default,){
final _that = this;
switch (_that) {
case _AppearancePreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppearancePreferences value)?  $default,){
final _that = this;
switch (_that) {
case _AppearancePreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  ThemeSetting theme,  bool showDuaCard,  bool showHijriDate,  String? dailyDuaText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppearancePreferences() when $default != null:
return $default(_that.userId,_that.theme,_that.showDuaCard,_that.showHijriDate,_that.dailyDuaText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  ThemeSetting theme,  bool showDuaCard,  bool showHijriDate,  String? dailyDuaText)  $default,) {final _that = this;
switch (_that) {
case _AppearancePreferences():
return $default(_that.userId,_that.theme,_that.showDuaCard,_that.showHijriDate,_that.dailyDuaText);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  ThemeSetting theme,  bool showDuaCard,  bool showHijriDate,  String? dailyDuaText)?  $default,) {final _that = this;
switch (_that) {
case _AppearancePreferences() when $default != null:
return $default(_that.userId,_that.theme,_that.showDuaCard,_that.showHijriDate,_that.dailyDuaText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppearancePreferences extends AppearancePreferences {
  const _AppearancePreferences({required this.userId, this.theme = ThemeSetting.auto, this.showDuaCard = true, this.showHijriDate = true, this.dailyDuaText}): super._();
  factory _AppearancePreferences.fromJson(Map<String, dynamic> json) => _$AppearancePreferencesFromJson(json);

@override final  String userId;
@override@JsonKey() final  ThemeSetting theme;
@override@JsonKey() final  bool showDuaCard;
@override@JsonKey() final  bool showHijriDate;
@override final  String? dailyDuaText;

/// Create a copy of AppearancePreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppearancePreferencesCopyWith<_AppearancePreferences> get copyWith => __$AppearancePreferencesCopyWithImpl<_AppearancePreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppearancePreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppearancePreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.showDuaCard, showDuaCard) || other.showDuaCard == showDuaCard)&&(identical(other.showHijriDate, showHijriDate) || other.showHijriDate == showHijriDate)&&(identical(other.dailyDuaText, dailyDuaText) || other.dailyDuaText == dailyDuaText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,theme,showDuaCard,showHijriDate,dailyDuaText);

@override
String toString() {
  return 'AppearancePreferences(userId: $userId, theme: $theme, showDuaCard: $showDuaCard, showHijriDate: $showHijriDate, dailyDuaText: $dailyDuaText)';
}


}

/// @nodoc
abstract mixin class _$AppearancePreferencesCopyWith<$Res> implements $AppearancePreferencesCopyWith<$Res> {
  factory _$AppearancePreferencesCopyWith(_AppearancePreferences value, $Res Function(_AppearancePreferences) _then) = __$AppearancePreferencesCopyWithImpl;
@override @useResult
$Res call({
 String userId, ThemeSetting theme, bool showDuaCard, bool showHijriDate, String? dailyDuaText
});




}
/// @nodoc
class __$AppearancePreferencesCopyWithImpl<$Res>
    implements _$AppearancePreferencesCopyWith<$Res> {
  __$AppearancePreferencesCopyWithImpl(this._self, this._then);

  final _AppearancePreferences _self;
  final $Res Function(_AppearancePreferences) _then;

/// Create a copy of AppearancePreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? theme = null,Object? showDuaCard = null,Object? showHijriDate = null,Object? dailyDuaText = freezed,}) {
  return _then(_AppearancePreferences(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeSetting,showDuaCard: null == showDuaCard ? _self.showDuaCard : showDuaCard // ignore: cast_nullable_to_non_nullable
as bool,showHijriDate: null == showHijriDate ? _self.showHijriDate : showHijriDate // ignore: cast_nullable_to_non_nullable
as bool,dailyDuaText: freezed == dailyDuaText ? _self.dailyDuaText : dailyDuaText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
