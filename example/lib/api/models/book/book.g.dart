// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String?,
  title: json['title'] as String?,
  author: json['author'] == null
      ? null
      : Author.fromJson(json['author'] as Map<String, dynamic>),
  coAuthors:
      (json['coAuthors'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$GenreEnumMap, e))
      .toList(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String?).toList() ??
      const [],
  ratings:
      (json['ratings'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  matrix:
      (json['matrix'] as List<dynamic>?)
          ?.map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
          )
          .toList() ??
      const [],
  metadata: json['metadata'] as Map<String, dynamic>?,
  defaultValue: json['default'] as String?,
  legacyCode: json['legacyCode'] as String?,
  result: json['result'] as Map<String, dynamic>?,
  pages: (json['pages'] as num?)?.toInt(),
);

abstract final class _$BookJsonKeys {
  static const String id = 'id';
  static const String title = 'title';
  static const String author = 'author';
  static const String coAuthors = 'coAuthors';
  static const String genres = 'genres';
  static const String tags = 'tags';
  static const String ratings = 'ratings';
  static const String matrix = 'matrix';
  static const String metadata = 'metadata';
  static const String defaultValue = 'default';
  static const String legacyCode = 'legacyCode';
  static const String result = 'result';
  static const String pages = 'pages';
}

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author?.toJson(),
  'coAuthors': instance.coAuthors?.map((e) => e.toJson()).toList(),
  'genres': instance.genres?.map((e) => _$GenreEnumMap[e]!).toList(),
  'tags': instance.tags,
  'ratings': instance.ratings,
  'matrix': instance.matrix,
  'metadata': instance.metadata,
  'default': instance.defaultValue,
  'legacyCode': instance.legacyCode,
  'result': instance.result,
  'pages': instance.pages,
};

const _$GenreEnumMap = {
  Genre.FICTION: 'FICTION',
  Genre.NON_FICTION: 'NON_FICTION',
  Genre.FACT: 'FACT',
};
