// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookFilter {

@JsonKey(toJson: nullableGenreToJson) Genre? get genre;@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre>? get genres;@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre> get requiredGenres; String? get title; int? get limit;@JsonKey(name: 'new') bool? get newItem;
/// Create a copy of BookFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookFilterCopyWith<BookFilter> get copyWith => _$BookFilterCopyWithImpl<BookFilter>(this as BookFilter, _$identity);

  /// Serializes this BookFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookFilter&&(identical(other.genre, genre) || other.genre == genre)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.requiredGenres, requiredGenres)&&(identical(other.title, title) || other.title == title)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.newItem, newItem) || other.newItem == newItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(requiredGenres),title,limit,newItem);

@override
String toString() {
  return 'BookFilter(genre: $genre, genres: $genres, requiredGenres: $requiredGenres, title: $title, limit: $limit, newItem: $newItem)';
}


}

/// @nodoc
abstract mixin class $BookFilterCopyWith<$Res>  {
  factory $BookFilterCopyWith(BookFilter value, $Res Function(BookFilter) _then) = _$BookFilterCopyWithImpl;
@useResult
$Res call({
@JsonKey(toJson: nullableGenreToJson) Genre? genre,@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre>? genres,@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre> requiredGenres, String? title, int? limit,@JsonKey(name: 'new') bool? newItem
});




}
/// @nodoc
class _$BookFilterCopyWithImpl<$Res>
    implements $BookFilterCopyWith<$Res> {
  _$BookFilterCopyWithImpl(this._self, this._then);

  final BookFilter _self;
  final $Res Function(BookFilter) _then;

/// Create a copy of BookFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genre = freezed,Object? genres = freezed,Object? requiredGenres = null,Object? title = freezed,Object? limit = freezed,Object? newItem = freezed,}) {
  return _then(_self.copyWith(
genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as Genre?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,requiredGenres: null == requiredGenres ? _self.requiredGenres : requiredGenres // ignore: cast_nullable_to_non_nullable
as List<Genre>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,newItem: freezed == newItem ? _self.newItem : newItem // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookFilter].
extension BookFilterPatterns on BookFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookFilter value)  $default,){
final _that = this;
switch (_that) {
case _BookFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookFilter value)?  $default,){
final _that = this;
switch (_that) {
case _BookFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(toJson: nullableGenreToJson)  Genre? genre, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre>? genres, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre> requiredGenres,  String? title,  int? limit, @JsonKey(name: 'new')  bool? newItem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookFilter() when $default != null:
return $default(_that.genre,_that.genres,_that.requiredGenres,_that.title,_that.limit,_that.newItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(toJson: nullableGenreToJson)  Genre? genre, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre>? genres, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre> requiredGenres,  String? title,  int? limit, @JsonKey(name: 'new')  bool? newItem)  $default,) {final _that = this;
switch (_that) {
case _BookFilter():
return $default(_that.genre,_that.genres,_that.requiredGenres,_that.title,_that.limit,_that.newItem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(toJson: nullableGenreToJson)  Genre? genre, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre>? genres, @JsonKey(toJson: _bookFilterListOfGenreToJson)  List<Genre> requiredGenres,  String? title,  int? limit, @JsonKey(name: 'new')  bool? newItem)?  $default,) {final _that = this;
switch (_that) {
case _BookFilter() when $default != null:
return $default(_that.genre,_that.genres,_that.requiredGenres,_that.title,_that.limit,_that.newItem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookFilter implements BookFilter {
  const _BookFilter({@JsonKey(toJson: nullableGenreToJson) this.genre, @JsonKey(toJson: _bookFilterListOfGenreToJson) final  List<Genre>? genres = const [], @JsonKey(toJson: _bookFilterListOfGenreToJson) required final  List<Genre> requiredGenres, this.title, this.limit, @JsonKey(name: 'new') this.newItem}): _genres = genres,_requiredGenres = requiredGenres;
  factory _BookFilter.fromJson(Map<String, dynamic> json) => _$BookFilterFromJson(json);

@override@JsonKey(toJson: nullableGenreToJson) final  Genre? genre;
 final  List<Genre>? _genres;
@override@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Genre> _requiredGenres;
@override@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre> get requiredGenres {
  if (_requiredGenres is EqualUnmodifiableListView) return _requiredGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredGenres);
}

@override final  String? title;
@override final  int? limit;
@override@JsonKey(name: 'new') final  bool? newItem;

/// Create a copy of BookFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookFilterCopyWith<_BookFilter> get copyWith => __$BookFilterCopyWithImpl<_BookFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookFilter&&(identical(other.genre, genre) || other.genre == genre)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._requiredGenres, _requiredGenres)&&(identical(other.title, title) || other.title == title)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.newItem, newItem) || other.newItem == newItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_requiredGenres),title,limit,newItem);

@override
String toString() {
  return 'BookFilter(genre: $genre, genres: $genres, requiredGenres: $requiredGenres, title: $title, limit: $limit, newItem: $newItem)';
}


}

/// @nodoc
abstract mixin class _$BookFilterCopyWith<$Res> implements $BookFilterCopyWith<$Res> {
  factory _$BookFilterCopyWith(_BookFilter value, $Res Function(_BookFilter) _then) = __$BookFilterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(toJson: nullableGenreToJson) Genre? genre,@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre>? genres,@JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre> requiredGenres, String? title, int? limit,@JsonKey(name: 'new') bool? newItem
});




}
/// @nodoc
class __$BookFilterCopyWithImpl<$Res>
    implements _$BookFilterCopyWith<$Res> {
  __$BookFilterCopyWithImpl(this._self, this._then);

  final _BookFilter _self;
  final $Res Function(_BookFilter) _then;

/// Create a copy of BookFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genre = freezed,Object? genres = freezed,Object? requiredGenres = null,Object? title = freezed,Object? limit = freezed,Object? newItem = freezed,}) {
  return _then(_BookFilter(
genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as Genre?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,requiredGenres: null == requiredGenres ? _self._requiredGenres : requiredGenres // ignore: cast_nullable_to_non_nullable
as List<Genre>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,newItem: freezed == newItem ? _self.newItem : newItem // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
