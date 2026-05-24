// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeekPlan {

 String get id; String get scheduleId; DateTime get startDate; DateTime get endDate; List<DayPlan> get days; String? get aiReasoning;
/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekPlanCopyWith<WeekPlan> get copyWith => _$WeekPlanCopyWithImpl<WeekPlan>(this as WeekPlan, _$identity);

  /// Serializes this WeekPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.aiReasoning, aiReasoning) || other.aiReasoning == aiReasoning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,startDate,endDate,const DeepCollectionEquality().hash(days),aiReasoning);

@override
String toString() {
  return 'WeekPlan(id: $id, scheduleId: $scheduleId, startDate: $startDate, endDate: $endDate, days: $days, aiReasoning: $aiReasoning)';
}


}

/// @nodoc
abstract mixin class $WeekPlanCopyWith<$Res>  {
  factory $WeekPlanCopyWith(WeekPlan value, $Res Function(WeekPlan) _then) = _$WeekPlanCopyWithImpl;
@useResult
$Res call({
 String id, String scheduleId, DateTime startDate, DateTime endDate, List<DayPlan> days, String? aiReasoning
});




}
/// @nodoc
class _$WeekPlanCopyWithImpl<$Res>
    implements $WeekPlanCopyWith<$Res> {
  _$WeekPlanCopyWithImpl(this._self, this._then);

  final WeekPlan _self;
  final $Res Function(WeekPlan) _then;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduleId = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? aiReasoning = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DayPlan>,aiReasoning: freezed == aiReasoning ? _self.aiReasoning : aiReasoning // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekPlan].
extension WeekPlanPatterns on WeekPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekPlan value)  $default,){
final _that = this;
switch (_that) {
case _WeekPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekPlan value)?  $default,){
final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scheduleId,  DateTime startDate,  DateTime endDate,  List<DayPlan> days,  String? aiReasoning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
return $default(_that.id,_that.scheduleId,_that.startDate,_that.endDate,_that.days,_that.aiReasoning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scheduleId,  DateTime startDate,  DateTime endDate,  List<DayPlan> days,  String? aiReasoning)  $default,) {final _that = this;
switch (_that) {
case _WeekPlan():
return $default(_that.id,_that.scheduleId,_that.startDate,_that.endDate,_that.days,_that.aiReasoning);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scheduleId,  DateTime startDate,  DateTime endDate,  List<DayPlan> days,  String? aiReasoning)?  $default,) {final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
return $default(_that.id,_that.scheduleId,_that.startDate,_that.endDate,_that.days,_that.aiReasoning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekPlan extends WeekPlan {
  const _WeekPlan({required this.id, required this.scheduleId, required this.startDate, required this.endDate, final  List<DayPlan> days = const [], this.aiReasoning}): _days = days,super._();
  factory _WeekPlan.fromJson(Map<String, dynamic> json) => _$WeekPlanFromJson(json);

@override final  String id;
@override final  String scheduleId;
@override final  DateTime startDate;
@override final  DateTime endDate;
 final  List<DayPlan> _days;
@override@JsonKey() List<DayPlan> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  String? aiReasoning;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekPlanCopyWith<_WeekPlan> get copyWith => __$WeekPlanCopyWithImpl<_WeekPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.aiReasoning, aiReasoning) || other.aiReasoning == aiReasoning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,startDate,endDate,const DeepCollectionEquality().hash(_days),aiReasoning);

@override
String toString() {
  return 'WeekPlan(id: $id, scheduleId: $scheduleId, startDate: $startDate, endDate: $endDate, days: $days, aiReasoning: $aiReasoning)';
}


}

/// @nodoc
abstract mixin class _$WeekPlanCopyWith<$Res> implements $WeekPlanCopyWith<$Res> {
  factory _$WeekPlanCopyWith(_WeekPlan value, $Res Function(_WeekPlan) _then) = __$WeekPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, String scheduleId, DateTime startDate, DateTime endDate, List<DayPlan> days, String? aiReasoning
});




}
/// @nodoc
class __$WeekPlanCopyWithImpl<$Res>
    implements _$WeekPlanCopyWith<$Res> {
  __$WeekPlanCopyWithImpl(this._self, this._then);

  final _WeekPlan _self;
  final $Res Function(_WeekPlan) _then;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduleId = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? aiReasoning = freezed,}) {
  return _then(_WeekPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DayPlan>,aiReasoning: freezed == aiReasoning ? _self.aiReasoning : aiReasoning // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
