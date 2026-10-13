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

  const _BookFields(this.fieldName, {this.nestedFields});

  @override
  final String fieldName;

  @override
  final List<EnumFields>? nestedFields;
}
