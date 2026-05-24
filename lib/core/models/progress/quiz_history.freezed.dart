// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizHistory {

 String get userId; int get totalQuizzesAttempted; int get totalQuestionsAnswered; List<QuizAttempt> get attempts; List<DailyScore> get scoreHistory;
/// Create a copy of QuizHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizHistoryCopyWith<QuizHistory> get copyWith => _$QuizHistoryCopyWithImpl<QuizHistory>(this as QuizHistory, _$identity);

  /// Serializes this QuizHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizHistory&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.totalQuizzesAttempted, totalQuizzesAttempted) || other.totalQuizzesAttempted == totalQuizzesAttempted)&&(identical(other.totalQuestionsAnswered, totalQuestionsAnswered) || other.totalQuestionsAnswered == totalQuestionsAnswered)&&const DeepCollectionEquality().equals(other.attempts, attempts)&&const DeepCollectionEquality().equals(other.scoreHistory, scoreHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,totalQuizzesAttempted,totalQuestionsAnswered,const DeepCollectionEquality().hash(attempts),const DeepCollectionEquality().hash(scoreHistory));

@override
String toString() {
  return 'QuizHistory(userId: $userId, totalQuizzesAttempted: $totalQuizzesAttempted, totalQuestionsAnswered: $totalQuestionsAnswered, attempts: $attempts, scoreHistory: $scoreHistory)';
}


}

/// @nodoc
abstract mixin class $QuizHistoryCopyWith<$Res>  {
  factory $QuizHistoryCopyWith(QuizHistory value, $Res Function(QuizHistory) _then) = _$QuizHistoryCopyWithImpl;
@useResult
$Res call({
 String userId, int totalQuizzesAttempted, int totalQuestionsAnswered, List<QuizAttempt> attempts, List<DailyScore> scoreHistory
});




}
/// @nodoc
class _$QuizHistoryCopyWithImpl<$Res>
    implements $QuizHistoryCopyWith<$Res> {
  _$QuizHistoryCopyWithImpl(this._self, this._then);

  final QuizHistory _self;
  final $Res Function(QuizHistory) _then;

/// Create a copy of QuizHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? totalQuizzesAttempted = null,Object? totalQuestionsAnswered = null,Object? attempts = null,Object? scoreHistory = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,totalQuizzesAttempted: null == totalQuizzesAttempted ? _self.totalQuizzesAttempted : totalQuizzesAttempted // ignore: cast_nullable_to_non_nullable
as int,totalQuestionsAnswered: null == totalQuestionsAnswered ? _self.totalQuestionsAnswered : totalQuestionsAnswered // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<QuizAttempt>,scoreHistory: null == scoreHistory ? _self.scoreHistory : scoreHistory // ignore: cast_nullable_to_non_nullable
as List<DailyScore>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizHistory].
extension QuizHistoryPatterns on QuizHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizHistory value)  $default,){
final _that = this;
switch (_that) {
case _QuizHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizHistory value)?  $default,){
final _that = this;
switch (_that) {
case _QuizHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int totalQuizzesAttempted,  int totalQuestionsAnswered,  List<QuizAttempt> attempts,  List<DailyScore> scoreHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizHistory() when $default != null:
return $default(_that.userId,_that.totalQuizzesAttempted,_that.totalQuestionsAnswered,_that.attempts,_that.scoreHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int totalQuizzesAttempted,  int totalQuestionsAnswered,  List<QuizAttempt> attempts,  List<DailyScore> scoreHistory)  $default,) {final _that = this;
switch (_that) {
case _QuizHistory():
return $default(_that.userId,_that.totalQuizzesAttempted,_that.totalQuestionsAnswered,_that.attempts,_that.scoreHistory);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int totalQuizzesAttempted,  int totalQuestionsAnswered,  List<QuizAttempt> attempts,  List<DailyScore> scoreHistory)?  $default,) {final _that = this;
switch (_that) {
case _QuizHistory() when $default != null:
return $default(_that.userId,_that.totalQuizzesAttempted,_that.totalQuestionsAnswered,_that.attempts,_that.scoreHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizHistory extends QuizHistory {
  const _QuizHistory({required this.userId, required this.totalQuizzesAttempted, required this.totalQuestionsAnswered, final  List<QuizAttempt> attempts = const [], final  List<DailyScore> scoreHistory = const []}): _attempts = attempts,_scoreHistory = scoreHistory,super._();
  factory _QuizHistory.fromJson(Map<String, dynamic> json) => _$QuizHistoryFromJson(json);

@override final  String userId;
@override final  int totalQuizzesAttempted;
@override final  int totalQuestionsAnswered;
 final  List<QuizAttempt> _attempts;
@override@JsonKey() List<QuizAttempt> get attempts {
  if (_attempts is EqualUnmodifiableListView) return _attempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attempts);
}

 final  List<DailyScore> _scoreHistory;
@override@JsonKey() List<DailyScore> get scoreHistory {
  if (_scoreHistory is EqualUnmodifiableListView) return _scoreHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scoreHistory);
}


/// Create a copy of QuizHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizHistoryCopyWith<_QuizHistory> get copyWith => __$QuizHistoryCopyWithImpl<_QuizHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizHistory&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.totalQuizzesAttempted, totalQuizzesAttempted) || other.totalQuizzesAttempted == totalQuizzesAttempted)&&(identical(other.totalQuestionsAnswered, totalQuestionsAnswered) || other.totalQuestionsAnswered == totalQuestionsAnswered)&&const DeepCollectionEquality().equals(other._attempts, _attempts)&&const DeepCollectionEquality().equals(other._scoreHistory, _scoreHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,totalQuizzesAttempted,totalQuestionsAnswered,const DeepCollectionEquality().hash(_attempts),const DeepCollectionEquality().hash(_scoreHistory));

@override
String toString() {
  return 'QuizHistory(userId: $userId, totalQuizzesAttempted: $totalQuizzesAttempted, totalQuestionsAnswered: $totalQuestionsAnswered, attempts: $attempts, scoreHistory: $scoreHistory)';
}


}

/// @nodoc
abstract mixin class _$QuizHistoryCopyWith<$Res> implements $QuizHistoryCopyWith<$Res> {
  factory _$QuizHistoryCopyWith(_QuizHistory value, $Res Function(_QuizHistory) _then) = __$QuizHistoryCopyWithImpl;
@override @useResult
$Res call({
 String userId, int totalQuizzesAttempted, int totalQuestionsAnswered, List<QuizAttempt> attempts, List<DailyScore> scoreHistory
});




}
/// @nodoc
class __$QuizHistoryCopyWithImpl<$Res>
    implements _$QuizHistoryCopyWith<$Res> {
  __$QuizHistoryCopyWithImpl(this._self, this._then);

  final _QuizHistory _self;
  final $Res Function(_QuizHistory) _then;

/// Create a copy of QuizHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? totalQuizzesAttempted = null,Object? totalQuestionsAnswered = null,Object? attempts = null,Object? scoreHistory = null,}) {
  return _then(_QuizHistory(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,totalQuizzesAttempted: null == totalQuizzesAttempted ? _self.totalQuizzesAttempted : totalQuizzesAttempted // ignore: cast_nullable_to_non_nullable
as int,totalQuestionsAnswered: null == totalQuestionsAnswered ? _self.totalQuestionsAnswered : totalQuestionsAnswered // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self._attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<QuizAttempt>,scoreHistory: null == scoreHistory ? _self._scoreHistory : scoreHistory // ignore: cast_nullable_to_non_nullable
as List<DailyScore>,
  ));
}


}

// dart format on
