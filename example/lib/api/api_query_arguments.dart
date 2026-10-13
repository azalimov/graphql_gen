// ignore_for_file: dangling_library_doc_comments
/// GraphQL Query Arguments
/// Auto-generated from schema.graphql
import 'package:graphql_gen/graphql_gen.dart';
import 'package:graphql_gen_example/api/api.dart';

class ApiQueryArguments {
  /// book
  static GraphQLArgumentBuilder book({
    required String id,
  }) {
    return GraphQLArgumentBuilder()
        .withArgument('id', id);
  }

  /// books
  static GraphQLArgumentBuilder books({
    BookFilter? filter,
    List<BookFilter>? filters,
    int? first,
    String? after,
  }) {
    return GraphQLArgumentBuilder()
        .withArgument('filter', filter?.toJson())
        .withArgument('filters', filters?.map((e) => e.toJson()).toList())
        .withArgument('first', first)
        .withArgument('after', after);
  }

  /// search
  static GraphQLArgumentBuilder search({
    required String text,
  }) {
    return GraphQLArgumentBuilder()
        .withArgument('text', text);
  }

}
