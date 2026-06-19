// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizQuestion {

 String get id; String get quizId; int get index; String get text; QuestionType get type; int get markValue; List<String> get options; int? get correctAnswerIndex; int? get timeLimit; String? get explanation; String? get citation;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.index, index) || other.index == index)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&(identical(other.markValue, markValue) || other.markValue == markValue)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctAnswerIndex, correctAnswerIndex) || other.correctAnswerIndex == correctAnswerIndex)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.citation, citation) || other.citation == citation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,quizId,index,text,type,markValue,const DeepCollectionEquality().hash(options),correctAnswerIndex,timeLimit,explanation,citation);

@override
String toString() {
  return 'QuizQuestion(id: $id, quizId: $quizId, index: $index, text: $text, type: $type, markValue: $markValue, options: $options, correctAnswerIndex: $correctAnswerIndex, timeLimit: $timeLimit, explanation: $explanation, citation: $citation)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String quizId, int index, String text, QuestionType type, int markValue, List<String> options, int? correctAnswerIndex, int? timeLimit, String? explanation, String? citation
});




}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? quizId = null,Object? index = null,Object? text = null,Object? type = null,Object? markValue = null,Object? options = null,Object? correctAnswerIndex = freezed,Object? timeLimit = freezed,Object? explanation = freezed,Object? citation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,markValue: null == markValue ? _self.markValue : markValue // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctAnswerIndex: freezed == correctAnswerIndex ? _self.correctAnswerIndex : correctAnswerIndex // ignore: cast_nullable_to_non_nullable
as int?,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int?,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,citation: freezed == citation ? _self.citation : citation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String quizId,  int index,  String text,  QuestionType type,  int markValue,  List<String> options,  int? correctAnswerIndex,  int? timeLimit,  String? explanation,  String? citation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.quizId,_that.index,_that.text,_that.type,_that.markValue,_that.options,_that.correctAnswerIndex,_that.timeLimit,_that.explanation,_that.citation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String quizId,  int index,  String text,  QuestionType type,  int markValue,  List<String> options,  int? correctAnswerIndex,  int? timeLimit,  String? explanation,  String? citation)  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that.id,_that.quizId,_that.index,_that.text,_that.type,_that.markValue,_that.options,_that.correctAnswerIndex,_that.timeLimit,_that.explanation,_that.citation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String quizId,  int index,  String text,  QuestionType type,  int markValue,  List<String> options,  int? correctAnswerIndex,  int? timeLimit,  String? explanation,  String? citation)?  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.quizId,_that.index,_that.text,_that.type,_that.markValue,_that.options,_that.correctAnswerIndex,_that.timeLimit,_that.explanation,_that.citation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizQuestion extends QuizQuestion {
  const _QuizQuestion({required this.id, required this.quizId, required this.index, required this.text, required this.type, required this.markValue, final  List<String> options = const [], this.correctAnswerIndex, this.timeLimit, this.explanation, this.citation}): _options = options,super._();
  factory _QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

@override final  String id;
@override final  String quizId;
@override final  int index;
@override final  String text;
@override final  QuestionType type;
@override final  int markValue;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int? correctAnswerIndex;
@override final  int? timeLimit;
@override final  String? explanation;
@override final  String? citation;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizQuestionCopyWith<_QuizQuestion> get copyWith => __$QuizQuestionCopyWithImpl<_QuizQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.index, index) || other.index == index)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&(identical(other.markValue, markValue) || other.markValue == markValue)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctAnswerIndex, correctAnswerIndex) || other.correctAnswerIndex == correctAnswerIndex)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.citation, citation) || other.citation == citation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,quizId,index,text,type,markValue,const DeepCollectionEquality().hash(_options),correctAnswerIndex,timeLimit,explanation,citation);

@override
String toString() {
  return 'QuizQuestion(id: $id, quizId: $quizId, index: $index, text: $text, type: $type, markValue: $markValue, options: $options, correctAnswerIndex: $correctAnswerIndex, timeLimit: $timeLimit, explanation: $explanation, citation: $citation)';
}


}

/// @nodoc
abstract mixin class _$QuizQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory _$QuizQuestionCopyWith(_QuizQuestion value, $Res Function(_QuizQuestion) _then) = __$QuizQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String quizId, int index, String text, QuestionType type, int markValue, List<String> options, int? correctAnswerIndex, int? timeLimit, String? explanation, String? citation
});




}
/// @nodoc
class __$QuizQuestionCopyWithImpl<$Res>
    implements _$QuizQuestionCopyWith<$Res> {
  __$QuizQuestionCopyWithImpl(this._self, this._then);

  final _QuizQuestion _self;
  final $Res Function(_QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quizId = null,Object? index = null,Object? text = null,Object? type = null,Object? markValue = null,Object? options = null,Object? correctAnswerIndex = freezed,Object? timeLimit = freezed,Object? explanation = freezed,Object? citation = freezed,}) {
  return _then(_QuizQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,markValue: null == markValue ? _self.markValue : markValue // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctAnswerIndex: freezed == correctAnswerIndex ? _self.correctAnswerIndex : correctAnswerIndex // ignore: cast_nullable_to_non_nullable
as int?,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int?,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,citation: freezed == citation ? _self.citation : citation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
