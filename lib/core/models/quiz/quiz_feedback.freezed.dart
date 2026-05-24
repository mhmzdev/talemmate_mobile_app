// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizFeedback {

 String get id; String get attemptId; String get questionId; bool get isCorrect; String get feedbackText; String? get explanation;
/// Create a copy of QuizFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizFeedbackCopyWith<QuizFeedback> get copyWith => _$QuizFeedbackCopyWithImpl<QuizFeedback>(this as QuizFeedback, _$identity);

  /// Serializes this QuizFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.feedbackText, feedbackText) || other.feedbackText == feedbackText)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,attemptId,questionId,isCorrect,feedbackText,explanation);

@override
String toString() {
  return 'QuizFeedback(id: $id, attemptId: $attemptId, questionId: $questionId, isCorrect: $isCorrect, feedbackText: $feedbackText, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $QuizFeedbackCopyWith<$Res>  {
  factory $QuizFeedbackCopyWith(QuizFeedback value, $Res Function(QuizFeedback) _then) = _$QuizFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, String attemptId, String questionId, bool isCorrect, String feedbackText, String? explanation
});




}
/// @nodoc
class _$QuizFeedbackCopyWithImpl<$Res>
    implements $QuizFeedbackCopyWith<$Res> {
  _$QuizFeedbackCopyWithImpl(this._self, this._then);

  final QuizFeedback _self;
  final $Res Function(QuizFeedback) _then;

/// Create a copy of QuizFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? attemptId = null,Object? questionId = null,Object? isCorrect = null,Object? feedbackText = null,Object? explanation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,feedbackText: null == feedbackText ? _self.feedbackText : feedbackText // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizFeedback].
extension QuizFeedbackPatterns on QuizFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizFeedback value)  $default,){
final _that = this;
switch (_that) {
case _QuizFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _QuizFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String attemptId,  String questionId,  bool isCorrect,  String feedbackText,  String? explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizFeedback() when $default != null:
return $default(_that.id,_that.attemptId,_that.questionId,_that.isCorrect,_that.feedbackText,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String attemptId,  String questionId,  bool isCorrect,  String feedbackText,  String? explanation)  $default,) {final _that = this;
switch (_that) {
case _QuizFeedback():
return $default(_that.id,_that.attemptId,_that.questionId,_that.isCorrect,_that.feedbackText,_that.explanation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String attemptId,  String questionId,  bool isCorrect,  String feedbackText,  String? explanation)?  $default,) {final _that = this;
switch (_that) {
case _QuizFeedback() when $default != null:
return $default(_that.id,_that.attemptId,_that.questionId,_that.isCorrect,_that.feedbackText,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizFeedback extends QuizFeedback {
  const _QuizFeedback({required this.id, required this.attemptId, required this.questionId, required this.isCorrect, required this.feedbackText, this.explanation}): super._();
  factory _QuizFeedback.fromJson(Map<String, dynamic> json) => _$QuizFeedbackFromJson(json);

@override final  String id;
@override final  String attemptId;
@override final  String questionId;
@override final  bool isCorrect;
@override final  String feedbackText;
@override final  String? explanation;

/// Create a copy of QuizFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizFeedbackCopyWith<_QuizFeedback> get copyWith => __$QuizFeedbackCopyWithImpl<_QuizFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.feedbackText, feedbackText) || other.feedbackText == feedbackText)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,attemptId,questionId,isCorrect,feedbackText,explanation);

@override
String toString() {
  return 'QuizFeedback(id: $id, attemptId: $attemptId, questionId: $questionId, isCorrect: $isCorrect, feedbackText: $feedbackText, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$QuizFeedbackCopyWith<$Res> implements $QuizFeedbackCopyWith<$Res> {
  factory _$QuizFeedbackCopyWith(_QuizFeedback value, $Res Function(_QuizFeedback) _then) = __$QuizFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, String attemptId, String questionId, bool isCorrect, String feedbackText, String? explanation
});




}
/// @nodoc
class __$QuizFeedbackCopyWithImpl<$Res>
    implements _$QuizFeedbackCopyWith<$Res> {
  __$QuizFeedbackCopyWithImpl(this._self, this._then);

  final _QuizFeedback _self;
  final $Res Function(_QuizFeedback) _then;

/// Create a copy of QuizFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? attemptId = null,Object? questionId = null,Object? isCorrect = null,Object? feedbackText = null,Object? explanation = freezed,}) {
  return _then(_QuizFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,feedbackText: null == feedbackText ? _self.feedbackText : feedbackText // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
