// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookFilter _$BookFilterFromJson(Map<String, dynamic> json) => _BookFilter(
  genre: $enumDecodeNullable(_$GenreEnumMap, json['genre']),
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$GenreEnumMap, e))
          .toList() ??
      const [],
  requiredGenres: (json['requiredGenres'] as List<dynamic>)
      .map((e) => $enumDecode(_$GenreEnumMap, e))
      .toList(),
  title: json['title'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  newItem: json['new'] as bool?,
);

abstract final class _$BookFilterJsonKeys {
  static const String genre = 'genre';
  static const String genres = 'genres';
  static const String requiredGenres = 'requiredGenres';
  static const String title = 'title';
  static const String limit = 'limit';
  static const String newItem = 'new';
}

Map<String, dynamic> _$BookFilterToJson(_BookFilter instance) =>
    <String, dynamic>{
      'genre': nullableGenreToJson(instance.genre),
      'genres': _bookFilterListOfGenreToJson(instance.genres),
      'requiredGenres': _bookFilterListOfGenreToJson(instance.requiredGenres),
      'title': instance.title,
      'limit': instance.limit,
      'new': instance.newItem,
    };

const _$GenreEnumMap = {
  Genre.FICTION: 'FICTION',
  Genre.NON_FICTION: 'NON_FICTION',
  Genre.FACT: 'FACT',
};
