// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutor_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TutorMessage {

 String get id; String get conversationId; MessageSender get sender; String get text; DateTime get timestamp; List<FollowUpPoint> get followUpPoints; List<Citation> get citations; String? get kickerQuestion;
/// Create a copy of TutorMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorMessageCopyWith<TutorMessage> get copyWith => _$TutorMessageCopyWithImpl<TutorMessage>(this as TutorMessage, _$identity);

  /// Serializes this TutorMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.followUpPoints, followUpPoints)&&const DeepCollectionEquality().equals(other.citations, citations)&&(identical(other.kickerQuestion, kickerQuestion) || other.kickerQuestion == kickerQuestion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,sender,text,timestamp,const DeepCollectionEquality().hash(followUpPoints),const DeepCollectionEquality().hash(citations),kickerQuestion);

@override
String toString() {
  return 'TutorMessage(id: $id, conversationId: $conversationId, sender: $sender, text: $text, timestamp: $timestamp, followUpPoints: $followUpPoints, citations: $citations, kickerQuestion: $kickerQuestion)';
}


}

/// @nodoc
abstract mixin class $TutorMessageCopyWith<$Res>  {
  factory $TutorMessageCopyWith(TutorMessage value, $Res Function(TutorMessage) _then) = _$TutorMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, MessageSender sender, String text, DateTime timestamp, List<FollowUpPoint> followUpPoints, List<Citation> citations, String? kickerQuestion
});




}
/// @nodoc
class _$TutorMessageCopyWithImpl<$Res>
    implements $TutorMessageCopyWith<$Res> {
  _$TutorMessageCopyWithImpl(this._self, this._then);

  final TutorMessage _self;
  final $Res Function(TutorMessage) _then;

/// Create a copy of TutorMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? sender = null,Object? text = null,Object? timestamp = null,Object? followUpPoints = null,Object? citations = null,Object? kickerQuestion = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,followUpPoints: null == followUpPoints ? _self.followUpPoints : followUpPoints // ignore: cast_nullable_to_non_nullable
as List<FollowUpPoint>,citations: null == citations ? _self.citations : citations // ignore: cast_nullable_to_non_nullable
as List<Citation>,kickerQuestion: freezed == kickerQuestion ? _self.kickerQuestion : kickerQuestion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TutorMessage].
extension TutorMessagePatterns on TutorMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TutorMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TutorMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TutorMessage value)  $default,){
final _that = this;
switch (_that) {
case _TutorMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TutorMessage value)?  $default,){
final _that = this;
switch (_that) {
case _TutorMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  MessageSender sender,  String text,  DateTime timestamp,  List<FollowUpPoint> followUpPoints,  List<Citation> citations,  String? kickerQuestion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TutorMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.sender,_that.text,_that.timestamp,_that.followUpPoints,_that.citations,_that.kickerQuestion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  MessageSender sender,  String text,  DateTime timestamp,  List<FollowUpPoint> followUpPoints,  List<Citation> citations,  String? kickerQuestion)  $default,) {final _that = this;
switch (_that) {
case _TutorMessage():
return $default(_that.id,_that.conversationId,_that.sender,_that.text,_that.timestamp,_that.followUpPoints,_that.citations,_that.kickerQuestion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  MessageSender sender,  String text,  DateTime timestamp,  List<FollowUpPoint> followUpPoints,  List<Citation> citations,  String? kickerQuestion)?  $default,) {final _that = this;
switch (_that) {
case _TutorMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.sender,_that.text,_that.timestamp,_that.followUpPoints,_that.citations,_that.kickerQuestion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TutorMessage extends TutorMessage {
  const _TutorMessage({required this.id, required this.conversationId, required this.sender, required this.text, required this.timestamp, final  List<FollowUpPoint> followUpPoints = const [], final  List<Citation> citations = const [], this.kickerQuestion}): _followUpPoints = followUpPoints,_citations = citations,super._();
  factory _TutorMessage.fromJson(Map<String, dynamic> json) => _$TutorMessageFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  MessageSender sender;
@override final  String text;
@override final  DateTime timestamp;
 final  List<FollowUpPoint> _followUpPoints;
@override@JsonKey() List<FollowUpPoint> get followUpPoints {
  if (_followUpPoints is EqualUnmodifiableListView) return _followUpPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followUpPoints);
}

 final  List<Citation> _citations;
@override@JsonKey() List<Citation> get citations {
  if (_citations is EqualUnmodifiableListView) return _citations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_citations);
}

@override final  String? kickerQuestion;

/// Create a copy of TutorMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TutorMessageCopyWith<_TutorMessage> get copyWith => __$TutorMessageCopyWithImpl<_TutorMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TutorMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TutorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._followUpPoints, _followUpPoints)&&const DeepCollectionEquality().equals(other._citations, _citations)&&(identical(other.kickerQuestion, kickerQuestion) || other.kickerQuestion == kickerQuestion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,sender,text,timestamp,const DeepCollectionEquality().hash(_followUpPoints),const DeepCollectionEquality().hash(_citations),kickerQuestion);

@override
String toString() {
  return 'TutorMessage(id: $id, conversationId: $conversationId, sender: $sender, text: $text, timestamp: $timestamp, followUpPoints: $followUpPoints, citations: $citations, kickerQuestion: $kickerQuestion)';
}


}

/// @nodoc
abstract mixin class _$TutorMessageCopyWith<$Res> implements $TutorMessageCopyWith<$Res> {
  factory _$TutorMessageCopyWith(_TutorMessage value, $Res Function(_TutorMessage) _then) = __$TutorMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, MessageSender sender, String text, DateTime timestamp, List<FollowUpPoint> followUpPoints, List<Citation> citations, String? kickerQuestion
});




}
/// @nodoc
class __$TutorMessageCopyWithImpl<$Res>
    implements _$TutorMessageCopyWith<$Res> {
  __$TutorMessageCopyWithImpl(this._self, this._then);

  final _TutorMessage _self;
  final $Res Function(_TutorMessage) _then;

/// Create a copy of TutorMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? sender = null,Object? text = null,Object? timestamp = null,Object? followUpPoints = null,Object? citations = null,Object? kickerQuestion = freezed,}) {
  return _then(_TutorMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,followUpPoints: null == followUpPoints ? _self._followUpPoints : followUpPoints // ignore: cast_nullable_to_non_nullable
as List<FollowUpPoint>,citations: null == citations ? _self._citations : citations // ignore: cast_nullable_to_non_nullable
as List<Citation>,kickerQuestion: freezed == kickerQuestion ? _self.kickerQuestion : kickerQuestion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
