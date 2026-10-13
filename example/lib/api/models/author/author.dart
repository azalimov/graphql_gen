import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen/graphql_gen.dart';

part 'author.freezed.dart';
part 'author.g.dart';
part 'author.fields.g.dart';

@freezed
@GenerateEnumFields()
abstract class Author with _$Author {
  const factory Author({
    String? id,
    String? name,
    DateTime? born,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  static GraphQLFieldBuilder query({required Iterable<AuthorFields> include}) =>
      GraphQLFieldBuilder().withEnumFields(include);
}

typedef AuthorJsonKeys = _$AuthorJsonKeys;
typedef AuthorFields = _AuthorFields;

