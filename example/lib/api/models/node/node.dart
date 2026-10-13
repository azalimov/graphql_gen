import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen/graphql_gen.dart';

part 'node.freezed.dart';
part 'node.g.dart';
part 'node.fields.g.dart';

@freezed
@GenerateEnumFields()
abstract class Node with _$Node {
  const factory Node({
    String? id,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

  static GraphQLFieldBuilder query({required Iterable<NodeFields> include}) =>
      GraphQLFieldBuilder().withEnumFields(include);
}

typedef NodeJsonKeys = _$NodeJsonKeys;
typedef NodeFields = _NodeFields;

