// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'book.dart';

// **************************************************************************
// EnumFieldsGenerator
// **************************************************************************

enum _BookFields implements EnumFields {
  id(BookJsonKeys.id),
  title(BookJsonKeys.title),
  author(BookJsonKeys.author, nestedFields: AuthorFields.values),
  coAuthors(BookJsonKeys.coAuthors, nestedFields: AuthorFields.values),
  genres(BookJsonKeys.genres),
  tags(BookJsonKeys.tags),
  ratings(BookJsonKeys.ratings),
  matrix(BookJsonKeys.matrix),
  metadata(BookJsonKeys.metadata),
  defaultValue(BookJsonKeys.defaultValue),
  legacyCode(BookJsonKeys.legacyCode),
  result(BookJsonKeys.result),
  pages(BookJsonKeys.pages);

  final String _fieldName;
  final List<EnumFields>? _nestedFields;
  const _BookFields(this._fieldName, {List<EnumFields>? nestedFields})
    : _nestedFields = nestedFields;

  @override
  String get fieldName => _fieldName;

  @override
  List<EnumFields>? get nestedFields => _nestedFields;
}
