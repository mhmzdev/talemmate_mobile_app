// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyBlock {

 String get id; String get scheduleId; int get dayOfWeek; DateTime get date; String get startTime; int get durationMinutes; String get subjectId; String get title; String get activities; BlockStatus get status; String? get topicId; String? get aiInsight; bool get isAIGenerated;
/// Create a copy of StudyBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyBlockCopyWith<StudyBlock> get copyWith => _$StudyBlockCopyWithImpl<StudyBlock>(this as StudyBlock, _$identity);

  /// Serializes this StudyBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.activities, activities) || other.activities == activities)&&(identical(other.status, status) || other.status == status)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.aiInsight, aiInsight) || other.aiInsight == aiInsight)&&(identical(other.isAIGenerated, isAIGenerated) || other.isAIGenerated == isAIGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,dayOfWeek,date,startTime,durationMinutes,subjectId,title,activities,status,topicId,aiInsight,isAIGenerated);

@override
String toString() {
  return 'StudyBlock(id: $id, scheduleId: $scheduleId, dayOfWeek: $dayOfWeek, date: $date, startTime: $startTime, durationMinutes: $durationMinutes, subjectId: $subjectId, title: $title, activities: $activities, status: $status, topicId: $topicId, aiInsight: $aiInsight, isAIGenerated: $isAIGenerated)';
}


}

/// @nodoc
abstract mixin class $StudyBlockCopyWith<$Res>  {
  factory $StudyBlockCopyWith(StudyBlock value, $Res Function(StudyBlock) _then) = _$StudyBlockCopyWithImpl;
@useResult
$Res call({
 String id, String scheduleId, int dayOfWeek, DateTime date, String startTime, int durationMinutes, String subjectId, String title, String activities, BlockStatus status, String? topicId, String? aiInsight, bool isAIGenerated
});




}
/// @nodoc
class _$StudyBlockCopyWithImpl<$Res>
    implements $StudyBlockCopyWith<$Res> {
  _$StudyBlockCopyWithImpl(this._self, this._then);

  final StudyBlock _self;
  final $Res Function(StudyBlock) _then;

/// Create a copy of StudyBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduleId = null,Object? dayOfWeek = null,Object? date = null,Object? startTime = null,Object? durationMinutes = null,Object? subjectId = null,Object? title = null,Object? activities = null,Object? status = null,Object? topicId = freezed,Object? aiInsight = freezed,Object? isAIGenerated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlockStatus,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,aiInsight: freezed == aiInsight ? _self.aiInsight : aiInsight // ignore: cast_nullable_to_non_nullable
as String?,isAIGenerated: null == isAIGenerated ? _self.isAIGenerated : isAIGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyBlock].
extension StudyBlockPatterns on StudyBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyBlock value)  $default,){
final _that = this;
switch (_that) {
case _StudyBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyBlock value)?  $default,){
final _that = this;
switch (_that) {
case _StudyBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scheduleId,  int dayOfWeek,  DateTime date,  String startTime,  int durationMinutes,  String subjectId,  String title,  String activities,  BlockStatus status,  String? topicId,  String? aiInsight,  bool isAIGenerated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyBlock() when $default != null:
return $default(_that.id,_that.scheduleId,_that.dayOfWeek,_that.date,_that.startTime,_that.durationMinutes,_that.subjectId,_that.title,_that.activities,_that.status,_that.topicId,_that.aiInsight,_that.isAIGenerated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scheduleId,  int dayOfWeek,  DateTime date,  String startTime,  int durationMinutes,  String subjectId,  String title,  String activities,  BlockStatus status,  String? topicId,  String? aiInsight,  bool isAIGenerated)  $default,) {final _that = this;
switch (_that) {
case _StudyBlock():
return $default(_that.id,_that.scheduleId,_that.dayOfWeek,_that.date,_that.startTime,_that.durationMinutes,_that.subjectId,_that.title,_that.activities,_that.status,_that.topicId,_that.aiInsight,_that.isAIGenerated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scheduleId,  int dayOfWeek,  DateTime date,  String startTime,  int durationMinutes,  String subjectId,  String title,  String activities,  BlockStatus status,  String? topicId,  String? aiInsight,  bool isAIGenerated)?  $default,) {final _that = this;
switch (_that) {
case _StudyBlock() when $default != null:
return $default(_that.id,_that.scheduleId,_that.dayOfWeek,_that.date,_that.startTime,_that.durationMinutes,_that.subjectId,_that.title,_that.activities,_that.status,_that.topicId,_that.aiInsight,_that.isAIGenerated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyBlock extends StudyBlock {
  const _StudyBlock({required this.id, required this.scheduleId, required this.dayOfWeek, required this.date, required this.startTime, required this.durationMinutes, required this.subjectId, required this.title, required this.activities, required this.status, this.topicId, this.aiInsight, this.isAIGenerated = false}): super._();
  factory _StudyBlock.fromJson(Map<String, dynamic> json) => _$StudyBlockFromJson(json);

@override final  String id;
@override final  String scheduleId;
@override final  int dayOfWeek;
@override final  DateTime date;
@override final  String startTime;
@override final  int durationMinutes;
@override final  String subjectId;
@override final  String title;
@override final  String activities;
@override final  BlockStatus status;
@override final  String? topicId;
@override final  String? aiInsight;
@override@JsonKey() final  bool isAIGenerated;

/// Create a copy of StudyBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyBlockCopyWith<_StudyBlock> get copyWith => __$StudyBlockCopyWithImpl<_StudyBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.activities, activities) || other.activities == activities)&&(identical(other.status, status) || other.status == status)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.aiInsight, aiInsight) || other.aiInsight == aiInsight)&&(identical(other.isAIGenerated, isAIGenerated) || other.isAIGenerated == isAIGenerated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,dayOfWeek,date,startTime,durationMinutes,subjectId,title,activities,status,topicId,aiInsight,isAIGenerated);

@override
String toString() {
  return 'StudyBlock(id: $id, scheduleId: $scheduleId, dayOfWeek: $dayOfWeek, date: $date, startTime: $startTime, durationMinutes: $durationMinutes, subjectId: $subjectId, title: $title, activities: $activities, status: $status, topicId: $topicId, aiInsight: $aiInsight, isAIGenerated: $isAIGenerated)';
}


}

/// @nodoc
abstract mixin class _$StudyBlockCopyWith<$Res> implements $StudyBlockCopyWith<$Res> {
  factory _$StudyBlockCopyWith(_StudyBlock value, $Res Function(_StudyBlock) _then) = __$StudyBlockCopyWithImpl;
@override @useResult
$Res call({
 String id, String scheduleId, int dayOfWeek, DateTime date, String startTime, int durationMinutes, String subjectId, String title, String activities, BlockStatus status, String? topicId, String? aiInsight, bool isAIGenerated
});




}
/// @nodoc
class __$StudyBlockCopyWithImpl<$Res>
    implements _$StudyBlockCopyWith<$Res> {
  __$StudyBlockCopyWithImpl(this._self, this._then);

  final _StudyBlock _self;
  final $Res Function(_StudyBlock) _then;

/// Create a copy of StudyBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduleId = null,Object? dayOfWeek = null,Object? date = null,Object? startTime = null,Object? durationMinutes = null,Object? subjectId = null,Object? title = null,Object? activities = null,Object? status = null,Object? topicId = freezed,Object? aiInsight = freezed,Object? isAIGenerated = null,}) {
  return _then(_StudyBlock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlockStatus,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,aiInsight: freezed == aiInsight ? _self.aiInsight : aiInsight // ignore: cast_nullable_to_non_nullable
as String?,isAIGenerated: null == isAIGenerated ? _self.isAIGenerated : isAIGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
