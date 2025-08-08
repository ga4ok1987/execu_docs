// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'executor_office_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExecutorOfficeEntity {

 int get id; String get name; String get address; bool get isPrimary; int get regionId;
/// Create a copy of ExecutorOfficeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExecutorOfficeEntityCopyWith<ExecutorOfficeEntity> get copyWith => _$ExecutorOfficeEntityCopyWithImpl<ExecutorOfficeEntity>(this as ExecutorOfficeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExecutorOfficeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.regionId, regionId) || other.regionId == regionId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,isPrimary,regionId);

@override
String toString() {
  return 'ExecutorOfficeEntity(id: $id, name: $name, address: $address, isPrimary: $isPrimary, regionId: $regionId)';
}


}

/// @nodoc
abstract mixin class $ExecutorOfficeEntityCopyWith<$Res>  {
  factory $ExecutorOfficeEntityCopyWith(ExecutorOfficeEntity value, $Res Function(ExecutorOfficeEntity) _then) = _$ExecutorOfficeEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address, bool isPrimary, int regionId
});




}
/// @nodoc
class _$ExecutorOfficeEntityCopyWithImpl<$Res>
    implements $ExecutorOfficeEntityCopyWith<$Res> {
  _$ExecutorOfficeEntityCopyWithImpl(this._self, this._then);

  final ExecutorOfficeEntity _self;
  final $Res Function(ExecutorOfficeEntity) _then;

/// Create a copy of ExecutorOfficeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? isPrimary = null,Object? regionId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,regionId: null == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExecutorOfficeEntity].
extension ExecutorOfficeEntityPatterns on ExecutorOfficeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExecutorOfficeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExecutorOfficeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExecutorOfficeEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExecutorOfficeEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExecutorOfficeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExecutorOfficeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String address,  bool isPrimary,  int regionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExecutorOfficeEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.isPrimary,_that.regionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String address,  bool isPrimary,  int regionId)  $default,) {final _that = this;
switch (_that) {
case _ExecutorOfficeEntity():
return $default(_that.id,_that.name,_that.address,_that.isPrimary,_that.regionId);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String address,  bool isPrimary,  int regionId)?  $default,) {final _that = this;
switch (_that) {
case _ExecutorOfficeEntity() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.isPrimary,_that.regionId);case _:
  return null;

}
}

}

/// @nodoc


class _ExecutorOfficeEntity implements ExecutorOfficeEntity {
  const _ExecutorOfficeEntity({required this.id, required this.name, required this.address, this.isPrimary = false, required this.regionId});
  

@override final  int id;
@override final  String name;
@override final  String address;
@override@JsonKey() final  bool isPrimary;
@override final  int regionId;

/// Create a copy of ExecutorOfficeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExecutorOfficeEntityCopyWith<_ExecutorOfficeEntity> get copyWith => __$ExecutorOfficeEntityCopyWithImpl<_ExecutorOfficeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExecutorOfficeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.regionId, regionId) || other.regionId == regionId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,isPrimary,regionId);

@override
String toString() {
  return 'ExecutorOfficeEntity(id: $id, name: $name, address: $address, isPrimary: $isPrimary, regionId: $regionId)';
}


}

/// @nodoc
abstract mixin class _$ExecutorOfficeEntityCopyWith<$Res> implements $ExecutorOfficeEntityCopyWith<$Res> {
  factory _$ExecutorOfficeEntityCopyWith(_ExecutorOfficeEntity value, $Res Function(_ExecutorOfficeEntity) _then) = __$ExecutorOfficeEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address, bool isPrimary, int regionId
});




}
/// @nodoc
class __$ExecutorOfficeEntityCopyWithImpl<$Res>
    implements _$ExecutorOfficeEntityCopyWith<$Res> {
  __$ExecutorOfficeEntityCopyWithImpl(this._self, this._then);

  final _ExecutorOfficeEntity _self;
  final $Res Function(_ExecutorOfficeEntity) _then;

/// Create a copy of ExecutorOfficeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? isPrimary = null,Object? regionId = null,}) {
  return _then(_ExecutorOfficeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,regionId: null == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
