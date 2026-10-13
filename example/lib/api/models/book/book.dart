import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen_example/api/api.dart';
import 'package:graphql_gen/graphql_gen.dart';

part 'book.freezed.dart';
part 'book.g.dart';
part 'book.fields.g.dart';

@freezed
@GenerateEnumFields()
abstract class Book with _$Book {
  const factory Book({
    String? id,
    String? title,
    Author? author,
    @Default([]) List<Author>? coAuthors,
    List<Genre>? genres,
    @Default([]) List<String?>? tags,
    @Default([]) List<int>? ratings,
    @Default([]) List<List<int>>? matrix,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'default') String? defaultValue,
    @Deprecated('Use \'code\' instead') String? legacyCode,
    Map<String, dynamic>? result,
    int? pages,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  static GraphQLFieldBuilder query({required Iterable<BookFields> include}) =>
      GraphQLFieldBuilder().withEnumFields(include);
}

typedef BookJsonKeys = _$BookJsonKeys;
typedef BookFields = _BookFields;

