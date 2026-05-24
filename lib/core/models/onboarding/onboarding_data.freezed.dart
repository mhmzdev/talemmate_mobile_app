// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingData {

 String get userId; int get step; List<Subject> get subjects; List<Exam> get exams; String? get institution; Schedule? get schedule; List<LibraryItem> get uploadedMaterials;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);

  /// Serializes this OnboardingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.exams, exams)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.uploadedMaterials, uploadedMaterials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,step,const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(exams),institution,schedule,const DeepCollectionEquality().hash(uploadedMaterials));

@override
String toString() {
  return 'OnboardingData(userId: $userId, step: $step, subjects: $subjects, exams: $exams, institution: $institution, schedule: $schedule, uploadedMaterials: $uploadedMaterials)';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 String userId, int step, List<Subject> subjects, List<Exam> exams, String? institution, Schedule? schedule, List<LibraryItem> uploadedMaterials
});


$ScheduleCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? step = null,Object? subjects = null,Object? exams = null,Object? institution = freezed,Object? schedule = freezed,Object? uploadedMaterials = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<Subject>,exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<Exam>,institution: freezed == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Schedule?,uploadedMaterials: null == uploadedMaterials ? _self.uploadedMaterials : uploadedMaterials // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int step,  List<Subject> subjects,  List<Exam> exams,  String? institution,  Schedule? schedule,  List<LibraryItem> uploadedMaterials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.userId,_that.step,_that.subjects,_that.exams,_that.institution,_that.schedule,_that.uploadedMaterials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int step,  List<Subject> subjects,  List<Exam> exams,  String? institution,  Schedule? schedule,  List<LibraryItem> uploadedMaterials)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.userId,_that.step,_that.subjects,_that.exams,_that.institution,_that.schedule,_that.uploadedMaterials);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int step,  List<Subject> subjects,  List<Exam> exams,  String? institution,  Schedule? schedule,  List<LibraryItem> uploadedMaterials)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.userId,_that.step,_that.subjects,_that.exams,_that.institution,_that.schedule,_that.uploadedMaterials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingData extends OnboardingData {
  const _OnboardingData({required this.userId, this.step = 1, final  List<Subject> subjects = const [], final  List<Exam> exams = const [], this.institution, this.schedule, final  List<LibraryItem> uploadedMaterials = const []}): _subjects = subjects,_exams = exams,_uploadedMaterials = uploadedMaterials,super._();
  factory _OnboardingData.fromJson(Map<String, dynamic> json) => _$OnboardingDataFromJson(json);

@override final  String userId;
@override@JsonKey() final  int step;
 final  List<Subject> _subjects;
@override@JsonKey() List<Subject> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

 final  List<Exam> _exams;
@override@JsonKey() List<Exam> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}

@override final  String? institution;
@override final  Schedule? schedule;
 final  List<LibraryItem> _uploadedMaterials;
@override@JsonKey() List<LibraryItem> get uploadedMaterials {
  if (_uploadedMaterials is EqualUnmodifiableListView) return _uploadedMaterials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedMaterials);
}


/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&const DeepCollectionEquality().equals(other._exams, _exams)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other._uploadedMaterials, _uploadedMaterials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,step,const DeepCollectionEquality().hash(_subjects),const DeepCollectionEquality().hash(_exams),institution,schedule,const DeepCollectionEquality().hash(_uploadedMaterials));

@override
String toString() {
  return 'OnboardingData(userId: $userId, step: $step, subjects: $subjects, exams: $exams, institution: $institution, schedule: $schedule, uploadedMaterials: $uploadedMaterials)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 String userId, int step, List<Subject> subjects, List<Exam> exams, String? institution, Schedule? schedule, List<LibraryItem> uploadedMaterials
});


@override $ScheduleCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? step = null,Object? subjects = null,Object? exams = null,Object? institution = freezed,Object? schedule = freezed,Object? uploadedMaterials = null,}) {
  return _then(_OnboardingData(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<Subject>,exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<Exam>,institution: freezed == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Schedule?,uploadedMaterials: null == uploadedMaterials ? _self._uploadedMaterials : uploadedMaterials // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
