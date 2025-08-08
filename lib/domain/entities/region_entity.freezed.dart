// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegionEntity {

 int get id; String get name; List<ExecutorOfficeEntity> get executorOffices;
/// Create a copy of RegionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionEntityCopyWith<RegionEntity> get copyWith => _$RegionEntityCopyWithImpl<RegionEntity>(this as RegionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.executorOffices, executorOffices));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(executorOffices));

@override
String toString() {
  return 'RegionEntity(id: $id, name: $name, executorOffices: $executorOffices)';
}


}

/// @nodoc
abstract mixin class $RegionEntityCopyWith<$Res>  {
  factory $RegionEntityCopyWith(RegionEntity value, $Res Function(RegionEntity) _then) = _$RegionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<ExecutorOfficeEntity> executorOffices
});




}
/// @nodoc
class _$RegionEntityCopyWithImpl<$Res>
    implements $RegionEntityCopyWith<$Res> {
  _$RegionEntityCopyWithImpl(this._self, this._then);

  final RegionEntity _self;
  final $Res Function(RegionEntity) _then;

/// Create a copy of RegionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? executorOffices = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,executorOffices: null == executorOffices ? _self.executorOffices : executorOffices // ignore: cast_nullable_to_non_nullable
as List<ExecutorOfficeEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [RegionEntity].
extension RegionEntityPatterns on RegionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegionEntity value)  $default,){
final _that = this;
switch (_that) {
case _RegionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RegionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<ExecutorOfficeEntity> executorOffices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegionEntity() when $default != null:
return $default(_that.id,_that.name,_that.executorOffices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<ExecutorOfficeEntity> executorOffices)  $default,) {final _that = this;
switch (_that) {
case _RegionEntity():
return $default(_that.id,_that.name,_that.executorOffices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<ExecutorOfficeEntity> executorOffices)?  $default,) {final _that = this;
switch (_that) {
case _RegionEntity() when $default != null:
return $default(_that.id,_that.name,_that.executorOffices);case _:
  return null;

}
}

}

/// @nodoc


class _RegionEntity implements RegionEntity {
  const _RegionEntity({required this.id, required this.name, final  List<ExecutorOfficeEntity> executorOffices = const []}): _executorOffices = executorOffices;
  

@override final  int id;
@override final  String name;
 final  List<ExecutorOfficeEntity> _executorOffices;
@override@JsonKey() List<ExecutorOfficeEntity> get executorOffices {
  if (_executorOffices is EqualUnmodifiableListView) return _executorOffices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_executorOffices);
}


/// Create a copy of RegionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionEntityCopyWith<_RegionEntity> get copyWith => __$RegionEntityCopyWithImpl<_RegionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._executorOffices, _executorOffices));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_executorOffices));

@override
String toString() {
  return 'RegionEntity(id: $id, name: $name, executorOffices: $executorOffices)';
}


}

/// @nodoc
abstract mixin class _$RegionEntityCopyWith<$Res> implements $RegionEntityCopyWith<$Res> {
  factory _$RegionEntityCopyWith(_RegionEntity value, $Res Function(_RegionEntity) _then) = __$RegionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<ExecutorOfficeEntity> executorOffices
});




}
/// @nodoc
class __$RegionEntityCopyWithImpl<$Res>
    implements _$RegionEntityCopyWith<$Res> {
  __$RegionEntityCopyWithImpl(this._self, this._then);

  final _RegionEntity _self;
  final $Res Function(_RegionEntity) _then;

/// Create a copy of RegionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? executorOffices = null,}) {
  return _then(_RegionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,executorOffices: null == executorOffices ? _self._executorOffices : executorOffices // ignore: cast_nullable_to_non_nullable
as List<ExecutorOfficeEntity>,
  ));
}


}

// dart format on
