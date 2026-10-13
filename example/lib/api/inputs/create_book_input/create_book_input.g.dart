// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_book_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateBookInput _$CreateBookInputFromJson(Map<String, dynamic> json) =>
    _CreateBookInput(
      title: json['title'] as String,
      genre: $enumDecode(_$GenreEnumMap, json['genre']),
      authorIds: (json['authorIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      filter: json['filter'] == null
          ? null
          : BookFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

abstract final class _$CreateBookInputJsonKeys {
  static const String title = 'title';
  static const String genre = 'genre';
  static const String authorIds = 'authorIds';
  static const String filter = 'filter';
}

Map<String, dynamic> _$CreateBookInputToJson(_CreateBookInput instance) =>
    <String, dynamic>{
      'title': instance.title,
      'genre': genreToJson(instance.genre),
      'authorIds': instance.authorIds,
      'filter': instance.filter?.toJson(),
    };

const _$GenreEnumMap = {
  Genre.FICTION: 'FICTION',
  Genre.NON_FICTION: 'NON_FICTION',
  Genre.FACT: 'FACT',
};
