// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'author.dart';

// **************************************************************************
// EnumFieldsGenerator
// **************************************************************************

enum _AuthorFields implements EnumFields {
  id(AuthorJsonKeys.id),
  name(AuthorJsonKeys.name),
  born(AuthorJsonKeys.born);

  final String _fieldName;
  final List<EnumFields>? _nestedFields;
  const _AuthorFields(this._fieldName, {List<EnumFields>? nestedFields})
    : _nestedFields = nestedFields;

  @override
  String get fieldName => _fieldName;

  @override
  List<EnumFields>? get nestedFields => _nestedFields;
}
