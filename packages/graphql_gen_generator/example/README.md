# Example

A complete project — schema, `graphql_gen.yaml`, generated sources and tests —
lives in the repository:
<https://github.com/azalimov/graphql_gen/tree/main/example>

```bash
dart run graphql_gen_generator init     # writes graphql_gen.yaml
dart run graphql_gen_generator sync     # schema -> models, enums, builders
dart run build_runner build             # freezed, json_serializable, field enums
```

```dart
final query = GraphQLQueryBuilder()
    .withOperation(
      operationName: ApiQueryOperations.books,
      arguments: ApiQueryArguments.books(first: 10),
      fields: GraphQLFieldBuilder().withEnumFields(BookFields.values),
    )
    .build();

final books = (response['books'] as List)
    .map((json) => Book.fromJson(json as Map<String, dynamic>));
```
