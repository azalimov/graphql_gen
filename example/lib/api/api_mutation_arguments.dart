// ignore_for_file: dangling_library_doc_comments
/// GraphQL Mutation Arguments
/// Auto-generated from schema.graphql
import 'package:graphql_gen/graphql_gen.dart';
import 'package:graphql_gen_example/api/api.dart';

class ApiMutationArguments {
  /// createBook
  static GraphQLArgumentBuilder createBook({
    required CreateBookInput input,
  }) {
    return GraphQLArgumentBuilder()
        .withArgument('input', input.toJson());
  }

}
