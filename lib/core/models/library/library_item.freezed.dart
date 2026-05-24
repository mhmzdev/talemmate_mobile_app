// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItem {

 String get id; String get userId; String get name; ItemKind get kind; int get fileSize; DateTime get uploadedAt; ProcessingStatus get processingStatus; String? get subjectId; String? get metadata; String? get colorHex; int? get indexedPageCount;
/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<LibraryItem> get copyWith => _$LibraryItemCopyWithImpl<LibraryItem>(this as LibraryItem, _$identity);

  /// Serializes this LibraryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.indexedPageCount, indexedPageCount) || other.indexedPageCount == indexedPageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,kind,fileSize,uploadedAt,processingStatus,subjectId,metadata,colorHex,indexedPageCount);

@override
String toString() {
  return 'LibraryItem(id: $id, userId: $userId, name: $name, kind: $kind, fileSize: $fileSize, uploadedAt: $uploadedAt, processingStatus: $processingStatus, subjectId: $subjectId, metadata: $metadata, colorHex: $colorHex, indexedPageCount: $indexedPageCount)';
}


}

/// @nodoc
abstract mixin class $LibraryItemCopyWith<$Res>  {
  factory $LibraryItemCopyWith(LibraryItem value, $Res Function(LibraryItem) _then) = _$LibraryItemCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, ItemKind kind, int fileSize, DateTime uploadedAt, ProcessingStatus processingStatus, String? subjectId, String? metadata, String? colorHex, int? indexedPageCount
});




}
/// @nodoc
class _$LibraryItemCopyWithImpl<$Res>
    implements $LibraryItemCopyWith<$Res> {
  _$LibraryItemCopyWithImpl(this._self, this._then);

  final LibraryItem _self;
  final $Res Function(LibraryItem) _then;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? kind = null,Object? fileSize = null,Object? uploadedAt = null,Object? processingStatus = null,Object? subjectId = freezed,Object? metadata = freezed,Object? colorHex = freezed,Object? indexedPageCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,indexedPageCount: freezed == indexedPageCount ? _self.indexedPageCount : indexedPageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItem].
extension LibraryItemPatterns on LibraryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItem value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItem value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  ItemKind kind,  int fileSize,  DateTime uploadedAt,  ProcessingStatus processingStatus,  String? subjectId,  String? metadata,  String? colorHex,  int? indexedPageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItem() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.fileSize,_that.uploadedAt,_that.processingStatus,_that.subjectId,_that.metadata,_that.colorHex,_that.indexedPageCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  ItemKind kind,  int fileSize,  DateTime uploadedAt,  ProcessingStatus processingStatus,  String? subjectId,  String? metadata,  String? colorHex,  int? indexedPageCount)  $default,) {final _that = this;
switch (_that) {
case _LibraryItem():
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.fileSize,_that.uploadedAt,_that.processingStatus,_that.subjectId,_that.metadata,_that.colorHex,_that.indexedPageCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  ItemKind kind,  int fileSize,  DateTime uploadedAt,  ProcessingStatus processingStatus,  String? subjectId,  String? metadata,  String? colorHex,  int? indexedPageCount)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItem() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.fileSize,_that.uploadedAt,_that.processingStatus,_that.subjectId,_that.metadata,_that.colorHex,_that.indexedPageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryItem extends LibraryItem {
  const _LibraryItem({required this.id, required this.userId, required this.name, required this.kind, required this.fileSize, required this.uploadedAt, required this.processingStatus, this.subjectId, this.metadata, this.colorHex, this.indexedPageCount}): super._();
  factory _LibraryItem.fromJson(Map<String, dynamic> json) => _$LibraryItemFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  ItemKind kind;
@override final  int fileSize;
@override final  DateTime uploadedAt;
@override final  ProcessingStatus processingStatus;
@override final  String? subjectId;
@override final  String? metadata;
@override final  String? colorHex;
@override final  int? indexedPageCount;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemCopyWith<_LibraryItem> get copyWith => __$LibraryItemCopyWithImpl<_LibraryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.indexedPageCount, indexedPageCount) || other.indexedPageCount == indexedPageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,kind,fileSize,uploadedAt,processingStatus,subjectId,metadata,colorHex,indexedPageCount);

@override
String toString() {
  return 'LibraryItem(id: $id, userId: $userId, name: $name, kind: $kind, fileSize: $fileSize, uploadedAt: $uploadedAt, processingStatus: $processingStatus, subjectId: $subjectId, metadata: $metadata, colorHex: $colorHex, indexedPageCount: $indexedPageCount)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemCopyWith<$Res> implements $LibraryItemCopyWith<$Res> {
  factory _$LibraryItemCopyWith(_LibraryItem value, $Res Function(_LibraryItem) _then) = __$LibraryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, ItemKind kind, int fileSize, DateTime uploadedAt, ProcessingStatus processingStatus, String? subjectId, String? metadata, String? colorHex, int? indexedPageCount
});




}
/// @nodoc
class __$LibraryItemCopyWithImpl<$Res>
    implements _$LibraryItemCopyWith<$Res> {
  __$LibraryItemCopyWithImpl(this._self, this._then);

  final _LibraryItem _self;
  final $Res Function(_LibraryItem) _then;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? kind = null,Object? fileSize = null,Object? uploadedAt = null,Object? processingStatus = null,Object? subjectId = freezed,Object? metadata = freezed,Object? colorHex = freezed,Object? indexedPageCount = freezed,}) {
  return _then(_LibraryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,indexedPageCount: freezed == indexedPageCount ? _self.indexedPageCount : indexedPageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
