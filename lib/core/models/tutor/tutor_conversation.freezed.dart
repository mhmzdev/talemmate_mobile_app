// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutor_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TutorConversation {

 String get id; String get userId; String get subjectId; int get groundedSourceCount; DateTime get createdAt; DateTime get lastMessageAt; String? get topicId; String? get title; List<TutorMessage> get messages;
/// Create a copy of TutorConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorConversationCopyWith<TutorConversation> get copyWith => _$TutorConversationCopyWithImpl<TutorConversation>(this as TutorConversation, _$identity);

  /// Serializes this TutorConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.groundedSourceCount, groundedSourceCount) || other.groundedSourceCount == groundedSourceCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,subjectId,groundedSourceCount,createdAt,lastMessageAt,topicId,title,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'TutorConversation(id: $id, userId: $userId, subjectId: $subjectId, groundedSourceCount: $groundedSourceCount, createdAt: $createdAt, lastMessageAt: $lastMessageAt, topicId: $topicId, title: $title, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $TutorConversationCopyWith<$Res>  {
  factory $TutorConversationCopyWith(TutorConversation value, $Res Function(TutorConversation) _then) = _$TutorConversationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String subjectId, int groundedSourceCount, DateTime createdAt, DateTime lastMessageAt, String? topicId, String? title, List<TutorMessage> messages
});




}
/// @nodoc
class _$TutorConversationCopyWithImpl<$Res>
    implements $TutorConversationCopyWith<$Res> {
  _$TutorConversationCopyWithImpl(this._self, this._then);

  final TutorConversation _self;
  final $Res Function(TutorConversation) _then;

/// Create a copy of TutorConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? subjectId = null,Object? groundedSourceCount = null,Object? createdAt = null,Object? lastMessageAt = null,Object? topicId = freezed,Object? title = freezed,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,groundedSourceCount: null == groundedSourceCount ? _self.groundedSourceCount : groundedSourceCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<TutorMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [TutorConversation].
extension TutorConversationPatterns on TutorConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TutorConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TutorConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TutorConversation value)  $default,){
final _that = this;
switch (_that) {
case _TutorConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TutorConversation value)?  $default,){
final _that = this;
switch (_that) {
case _TutorConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String subjectId,  int groundedSourceCount,  DateTime createdAt,  DateTime lastMessageAt,  String? topicId,  String? title,  List<TutorMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TutorConversation() when $default != null:
return $default(_that.id,_that.userId,_that.subjectId,_that.groundedSourceCount,_that.createdAt,_that.lastMessageAt,_that.topicId,_that.title,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String subjectId,  int groundedSourceCount,  DateTime createdAt,  DateTime lastMessageAt,  String? topicId,  String? title,  List<TutorMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _TutorConversation():
return $default(_that.id,_that.userId,_that.subjectId,_that.groundedSourceCount,_that.createdAt,_that.lastMessageAt,_that.topicId,_that.title,_that.messages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String subjectId,  int groundedSourceCount,  DateTime createdAt,  DateTime lastMessageAt,  String? topicId,  String? title,  List<TutorMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _TutorConversation() when $default != null:
return $default(_that.id,_that.userId,_that.subjectId,_that.groundedSourceCount,_that.createdAt,_that.lastMessageAt,_that.topicId,_that.title,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TutorConversation extends TutorConversation {
  const _TutorConversation({required this.id, required this.userId, required this.subjectId, required this.groundedSourceCount, required this.createdAt, required this.lastMessageAt, this.topicId, this.title, final  List<TutorMessage> messages = const []}): _messages = messages,super._();
  factory _TutorConversation.fromJson(Map<String, dynamic> json) => _$TutorConversationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String subjectId;
@override final  int groundedSourceCount;
@override final  DateTime createdAt;
@override final  DateTime lastMessageAt;
@override final  String? topicId;
@override final  String? title;
 final  List<TutorMessage> _messages;
@override@JsonKey() List<TutorMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of TutorConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TutorConversationCopyWith<_TutorConversation> get copyWith => __$TutorConversationCopyWithImpl<_TutorConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TutorConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TutorConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.groundedSourceCount, groundedSourceCount) || other.groundedSourceCount == groundedSourceCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,subjectId,groundedSourceCount,createdAt,lastMessageAt,topicId,title,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'TutorConversation(id: $id, userId: $userId, subjectId: $subjectId, groundedSourceCount: $groundedSourceCount, createdAt: $createdAt, lastMessageAt: $lastMessageAt, topicId: $topicId, title: $title, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$TutorConversationCopyWith<$Res> implements $TutorConversationCopyWith<$Res> {
  factory _$TutorConversationCopyWith(_TutorConversation value, $Res Function(_TutorConversation) _then) = __$TutorConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String subjectId, int groundedSourceCount, DateTime createdAt, DateTime lastMessageAt, String? topicId, String? title, List<TutorMessage> messages
});




}
/// @nodoc
class __$TutorConversationCopyWithImpl<$Res>
    implements _$TutorConversationCopyWith<$Res> {
  __$TutorConversationCopyWithImpl(this._self, this._then);

  final _TutorConversation _self;
  final $Res Function(_TutorConversation) _then;

/// Create a copy of TutorConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? subjectId = null,Object? groundedSourceCount = null,Object? createdAt = null,Object? lastMessageAt = null,Object? topicId = freezed,Object? title = freezed,Object? messages = null,}) {
  return _then(_TutorConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,groundedSourceCount: null == groundedSourceCount ? _self.groundedSourceCount : groundedSourceCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<TutorMessage>,
  ));
}


}

// dart format on
