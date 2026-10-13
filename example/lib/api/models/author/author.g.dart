// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  id: json['id'] as String?,
  name: json['name'] as String?,
  born: json['born'] == null ? null : DateTime.parse(json['born'] as String),
);

abstract final class _$AuthorJsonKeys {
  static const String id = 'id';
  static const String name = 'name';
  static const String born = 'born';
}

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'born': instance.born?.toIso8601String(),
};
