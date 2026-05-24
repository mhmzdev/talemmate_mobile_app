// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {

 String get id; String get userId; double get dailyTargetHours; List<String> get enabledWindowIds; DateTime? get weekStartDate; bool get isAIGenerated;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyTargetHours, dailyTargetHours) || other.dailyTargetHours == dailyTargetHours)&&const DeepCollectionEquality().equals(other.enabledWindowIds, enabledWindowIds)&&(identical(other.weekStartDate, weekStartDate) || other.weekStartDate == weekStartDate)&&(identical(other.isAIGenerated, isAIGenerated) || other.isAIGenerated == isAIGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyTargetHours,const DeepCollectionEquality().hash(enabledWindowIds),weekStartDate,isAIGenerated);

@override
String toString() {
  return 'Schedule(id: $id, userId: $userId, dailyTargetHours: $dailyTargetHours, enabledWindowIds: $enabledWindowIds, weekStartDate: $weekStartDate, isAIGenerated: $isAIGenerated)';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String userId, double dailyTargetHours, List<String> enabledWindowIds, DateTime? weekStartDate, bool isAIGenerated
});




}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? dailyTargetHours = null,Object? enabledWindowIds = null,Object? weekStartDate = freezed,Object? isAIGenerated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyTargetHours: null == dailyTargetHours ? _self.dailyTargetHours : dailyTargetHours // ignore: cast_nullable_to_non_nullable
as double,enabledWindowIds: null == enabledWindowIds ? _self.enabledWindowIds : enabledWindowIds // ignore: cast_nullable_to_non_nullable
as List<String>,weekStartDate: freezed == weekStartDate ? _self.weekStartDate : weekStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isAIGenerated: null == isAIGenerated ? _self.isAIGenerated : isAIGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  double dailyTargetHours,  List<String> enabledWindowIds,  DateTime? weekStartDate,  bool isAIGenerated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.userId,_that.dailyTargetHours,_that.enabledWindowIds,_that.weekStartDate,_that.isAIGenerated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  double dailyTargetHours,  List<String> enabledWindowIds,  DateTime? weekStartDate,  bool isAIGenerated)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.id,_that.userId,_that.dailyTargetHours,_that.enabledWindowIds,_that.weekStartDate,_that.isAIGenerated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  double dailyTargetHours,  List<String> enabledWindowIds,  DateTime? weekStartDate,  bool isAIGenerated)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.userId,_that.dailyTargetHours,_that.enabledWindowIds,_that.weekStartDate,_that.isAIGenerated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Schedule extends Schedule {
  const _Schedule({required this.id, required this.userId, required this.dailyTargetHours, final  List<String> enabledWindowIds = const [], this.weekStartDate, this.isAIGenerated = true}): _enabledWindowIds = enabledWindowIds,super._();
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

@override final  String id;
@override final  String userId;
@override final  double dailyTargetHours;
 final  List<String> _enabledWindowIds;
@override@JsonKey() List<String> get enabledWindowIds {
  if (_enabledWindowIds is EqualUnmodifiableListView) return _enabledWindowIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_enabledWindowIds);
}

@override final  DateTime? weekStartDate;
@override@JsonKey() final  bool isAIGenerated;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyTargetHours, dailyTargetHours) || other.dailyTargetHours == dailyTargetHours)&&const DeepCollectionEquality().equals(other._enabledWindowIds, _enabledWindowIds)&&(identical(other.weekStartDate, weekStartDate) || other.weekStartDate == weekStartDate)&&(identical(other.isAIGenerated, isAIGenerated) || other.isAIGenerated == isAIGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyTargetHours,const DeepCollectionEquality().hash(_enabledWindowIds),weekStartDate,isAIGenerated);

@override
String toString() {
  return 'Schedule(id: $id, userId: $userId, dailyTargetHours: $dailyTargetHours, enabledWindowIds: $enabledWindowIds, weekStartDate: $weekStartDate, isAIGenerated: $isAIGenerated)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, double dailyTargetHours, List<String> enabledWindowIds, DateTime? weekStartDate, bool isAIGenerated
});




}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? dailyTargetHours = null,Object? enabledWindowIds = null,Object? weekStartDate = freezed,Object? isAIGenerated = null,}) {
  return _then(_Schedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyTargetHours: null == dailyTargetHours ? _self.dailyTargetHours : dailyTargetHours // ignore: cast_nullable_to_non_nullable
as double,enabledWindowIds: null == enabledWindowIds ? _self._enabledWindowIds : enabledWindowIds // ignore: cast_nullable_to_non_nullable
as List<String>,weekStartDate: freezed == weekStartDate ? _self.weekStartDate : weekStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isAIGenerated: null == isAIGenerated ? _self.isAIGenerated : isAIGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
