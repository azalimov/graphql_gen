// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_book_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBookInput {

 String get title;@JsonKey(toJson: genreToJson) Genre get genre; List<String> get authorIds; BookFilter? get filter;
/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBookInputCopyWith<CreateBookInput> get copyWith => _$CreateBookInputCopyWithImpl<CreateBookInput>(this as CreateBookInput, _$identity);

  /// Serializes this CreateBookInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBookInput&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&const DeepCollectionEquality().equals(other.authorIds, authorIds)&&(identical(other.filter, filter) || other.filter == filter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,genre,const DeepCollectionEquality().hash(authorIds),filter);

@override
String toString() {
  return 'CreateBookInput(title: $title, genre: $genre, authorIds: $authorIds, filter: $filter)';
}


}

/// @nodoc
abstract mixin class $CreateBookInputCopyWith<$Res>  {
  factory $CreateBookInputCopyWith(CreateBookInput value, $Res Function(CreateBookInput) _then) = _$CreateBookInputCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(toJson: genreToJson) Genre genre, List<String> authorIds, BookFilter? filter
});


$BookFilterCopyWith<$Res>? get filter;

}
/// @nodoc
class _$CreateBookInputCopyWithImpl<$Res>
    implements $CreateBookInputCopyWith<$Res> {
  _$CreateBookInputCopyWithImpl(this._self, this._then);

  final CreateBookInput _self;
  final $Res Function(CreateBookInput) _then;

/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? genre = null,Object? authorIds = null,Object? filter = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as Genre,authorIds: null == authorIds ? _self.authorIds : authorIds // ignore: cast_nullable_to_non_nullable
as List<String>,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as BookFilter?,
  ));
}
/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
    return null;
  }

  return $BookFilterCopyWith<$Res>(_self.filter!, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateBookInput].
extension CreateBookInputPatterns on CreateBookInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateBookInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateBookInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateBookInput value)  $default,){
final _that = this;
switch (_that) {
case _CreateBookInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateBookInput value)?  $default,){
final _that = this;
switch (_that) {
case _CreateBookInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(toJson: genreToJson)  Genre genre,  List<String> authorIds,  BookFilter? filter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateBookInput() when $default != null:
return $default(_that.title,_that.genre,_that.authorIds,_that.filter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(toJson: genreToJson)  Genre genre,  List<String> authorIds,  BookFilter? filter)  $default,) {final _that = this;
switch (_that) {
case _CreateBookInput():
return $default(_that.title,_that.genre,_that.authorIds,_that.filter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(toJson: genreToJson)  Genre genre,  List<String> authorIds,  BookFilter? filter)?  $default,) {final _that = this;
switch (_that) {
case _CreateBookInput() when $default != null:
return $default(_that.title,_that.genre,_that.authorIds,_that.filter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateBookInput implements CreateBookInput {
  const _CreateBookInput({required this.title, @JsonKey(toJson: genreToJson) required this.genre, required final  List<String> authorIds, this.filter}): _authorIds = authorIds;
  factory _CreateBookInput.fromJson(Map<String, dynamic> json) => _$CreateBookInputFromJson(json);

@override final  String title;
@override@JsonKey(toJson: genreToJson) final  Genre genre;
 final  List<String> _authorIds;
@override List<String> get authorIds {
  if (_authorIds is EqualUnmodifiableListView) return _authorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authorIds);
}

@override final  BookFilter? filter;

/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBookInputCopyWith<_CreateBookInput> get copyWith => __$CreateBookInputCopyWithImpl<_CreateBookInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBookInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBookInput&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&const DeepCollectionEquality().equals(other._authorIds, _authorIds)&&(identical(other.filter, filter) || other.filter == filter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,genre,const DeepCollectionEquality().hash(_authorIds),filter);

@override
String toString() {
  return 'CreateBookInput(title: $title, genre: $genre, authorIds: $authorIds, filter: $filter)';
}


}

/// @nodoc
abstract mixin class _$CreateBookInputCopyWith<$Res> implements $CreateBookInputCopyWith<$Res> {
  factory _$CreateBookInputCopyWith(_CreateBookInput value, $Res Function(_CreateBookInput) _then) = __$CreateBookInputCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(toJson: genreToJson) Genre genre, List<String> authorIds, BookFilter? filter
});


@override $BookFilterCopyWith<$Res>? get filter;

}
/// @nodoc
class __$CreateBookInputCopyWithImpl<$Res>
    implements _$CreateBookInputCopyWith<$Res> {
  __$CreateBookInputCopyWithImpl(this._self, this._then);

  final _CreateBookInput _self;
  final $Res Function(_CreateBookInput) _then;

/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? genre = null,Object? authorIds = null,Object? filter = freezed,}) {
  return _then(_CreateBookInput(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as Genre,authorIds: null == authorIds ? _self._authorIds : authorIds // ignore: cast_nullable_to_non_nullable
as List<String>,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as BookFilter?,
  ));
}

/// Create a copy of CreateBookInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
    return null;
  }

  return $BookFilterCopyWith<$Res>(_self.filter!, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
