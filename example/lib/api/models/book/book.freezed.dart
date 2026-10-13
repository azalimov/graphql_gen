// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Book {

 String? get id; String? get title; Author? get author; List<Author>? get coAuthors; List<Genre>? get genres; List<String?>? get tags; List<int>? get ratings; List<List<int>>? get matrix; Map<String, dynamic>? get metadata;@JsonKey(name: 'default') String? get defaultValue;@Deprecated('Use \'code\' instead') String? get legacyCode; Map<String, dynamic>? get result; int? get pages;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.coAuthors, coAuthors)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.ratings, ratings)&&const DeepCollectionEquality().equals(other.matrix, matrix)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.legacyCode, legacyCode) || other.legacyCode == legacyCode)&&const DeepCollectionEquality().equals(other.result, result)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,const DeepCollectionEquality().hash(coAuthors),const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(ratings),const DeepCollectionEquality().hash(matrix),const DeepCollectionEquality().hash(metadata),defaultValue,legacyCode,const DeepCollectionEquality().hash(result),pages);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coAuthors: $coAuthors, genres: $genres, tags: $tags, ratings: $ratings, matrix: $matrix, metadata: $metadata, defaultValue: $defaultValue, legacyCode: $legacyCode, result: $result, pages: $pages)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String? id, String? title, Author? author, List<Author>? coAuthors, List<Genre>? genres, List<String?>? tags, List<int>? ratings, List<List<int>>? matrix, Map<String, dynamic>? metadata,@JsonKey(name: 'default') String? defaultValue,@Deprecated('Use \'code\' instead') String? legacyCode, Map<String, dynamic>? result, int? pages
});


$AuthorCopyWith<$Res>? get author;

}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? author = freezed,Object? coAuthors = freezed,Object? genres = freezed,Object? tags = freezed,Object? ratings = freezed,Object? matrix = freezed,Object? metadata = freezed,Object? defaultValue = freezed,Object? legacyCode = freezed,Object? result = freezed,Object? pages = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author?,coAuthors: freezed == coAuthors ? _self.coAuthors : coAuthors // ignore: cast_nullable_to_non_nullable
as List<Author>?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String?>?,ratings: freezed == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<int>?,matrix: freezed == matrix ? _self.matrix : matrix // ignore: cast_nullable_to_non_nullable
as List<List<int>>?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,legacyCode: freezed == legacyCode ? _self.legacyCode : legacyCode // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pages: freezed == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? title,  Author? author,  List<Author>? coAuthors,  List<Genre>? genres,  List<String?>? tags,  List<int>? ratings,  List<List<int>>? matrix,  Map<String, dynamic>? metadata, @JsonKey(name: 'default')  String? defaultValue, @Deprecated('Use \'code\' instead')  String? legacyCode,  Map<String, dynamic>? result,  int? pages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coAuthors,_that.genres,_that.tags,_that.ratings,_that.matrix,_that.metadata,_that.defaultValue,_that.legacyCode,_that.result,_that.pages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? title,  Author? author,  List<Author>? coAuthors,  List<Genre>? genres,  List<String?>? tags,  List<int>? ratings,  List<List<int>>? matrix,  Map<String, dynamic>? metadata, @JsonKey(name: 'default')  String? defaultValue, @Deprecated('Use \'code\' instead')  String? legacyCode,  Map<String, dynamic>? result,  int? pages)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.author,_that.coAuthors,_that.genres,_that.tags,_that.ratings,_that.matrix,_that.metadata,_that.defaultValue,_that.legacyCode,_that.result,_that.pages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? title,  Author? author,  List<Author>? coAuthors,  List<Genre>? genres,  List<String?>? tags,  List<int>? ratings,  List<List<int>>? matrix,  Map<String, dynamic>? metadata, @JsonKey(name: 'default')  String? defaultValue, @Deprecated('Use \'code\' instead')  String? legacyCode,  Map<String, dynamic>? result,  int? pages)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coAuthors,_that.genres,_that.tags,_that.ratings,_that.matrix,_that.metadata,_that.defaultValue,_that.legacyCode,_that.result,_that.pages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book implements Book {
  const _Book({this.id, this.title, this.author, final  List<Author>? coAuthors = const [], final  List<Genre>? genres, final  List<String?>? tags = const [], final  List<int>? ratings = const [], final  List<List<int>>? matrix = const [], final  Map<String, dynamic>? metadata, @JsonKey(name: 'default') this.defaultValue, @Deprecated('Use \'code\' instead') this.legacyCode, final  Map<String, dynamic>? result, this.pages}): _coAuthors = coAuthors,_genres = genres,_tags = tags,_ratings = ratings,_matrix = matrix,_metadata = metadata,_result = result;
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override final  String? id;
@override final  String? title;
@override final  Author? author;
 final  List<Author>? _coAuthors;
@override@JsonKey() List<Author>? get coAuthors {
  final value = _coAuthors;
  if (value == null) return null;
  if (_coAuthors is EqualUnmodifiableListView) return _coAuthors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Genre>? _genres;
@override List<Genre>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String?>? _tags;
@override@JsonKey() List<String?>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _ratings;
@override@JsonKey() List<int>? get ratings {
  final value = _ratings;
  if (value == null) return null;
  if (_ratings is EqualUnmodifiableListView) return _ratings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<List<int>>? _matrix;
@override@JsonKey() List<List<int>>? get matrix {
  final value = _matrix;
  if (value == null) return null;
  if (_matrix is EqualUnmodifiableListView) return _matrix;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'default') final  String? defaultValue;
@override@Deprecated('Use \'code\' instead') final  String? legacyCode;
 final  Map<String, dynamic>? _result;
@override Map<String, dynamic>? get result {
  final value = _result;
  if (value == null) return null;
  if (_result is EqualUnmodifiableMapView) return _result;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? pages;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._coAuthors, _coAuthors)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._ratings, _ratings)&&const DeepCollectionEquality().equals(other._matrix, _matrix)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.legacyCode, legacyCode) || other.legacyCode == legacyCode)&&const DeepCollectionEquality().equals(other._result, _result)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,const DeepCollectionEquality().hash(_coAuthors),const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_ratings),const DeepCollectionEquality().hash(_matrix),const DeepCollectionEquality().hash(_metadata),defaultValue,legacyCode,const DeepCollectionEquality().hash(_result),pages);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coAuthors: $coAuthors, genres: $genres, tags: $tags, ratings: $ratings, matrix: $matrix, metadata: $metadata, defaultValue: $defaultValue, legacyCode: $legacyCode, result: $result, pages: $pages)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? title, Author? author, List<Author>? coAuthors, List<Genre>? genres, List<String?>? tags, List<int>? ratings, List<List<int>>? matrix, Map<String, dynamic>? metadata,@JsonKey(name: 'default') String? defaultValue,@Deprecated('Use \'code\' instead') String? legacyCode, Map<String, dynamic>? result, int? pages
});


@override $AuthorCopyWith<$Res>? get author;

}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? author = freezed,Object? coAuthors = freezed,Object? genres = freezed,Object? tags = freezed,Object? ratings = freezed,Object? matrix = freezed,Object? metadata = freezed,Object? defaultValue = freezed,Object? legacyCode = freezed,Object? result = freezed,Object? pages = freezed,}) {
  return _then(_Book(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author?,coAuthors: freezed == coAuthors ? _self._coAuthors : coAuthors // ignore: cast_nullable_to_non_nullable
as List<Author>?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<Genre>?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String?>?,ratings: freezed == ratings ? _self._ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<int>?,matrix: freezed == matrix ? _self._matrix : matrix // ignore: cast_nullable_to_non_nullable
as List<List<int>>?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,legacyCode: freezed == legacyCode ? _self.legacyCode : legacyCode // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self._result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pages: freezed == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $AuthorCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
