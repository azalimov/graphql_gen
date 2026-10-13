# graphql_gen

Type-safe GraphQL query building for Dart. Select fields with generated
enums instead of writing `.graphql` documents, and get one Freezed model per
schema type instead of one class per query.

> Status: early release (`0.1.x`). The API may still change before 1.0.

## Generate everything from your schema

```bash
dart run graphql_gen_generator init    # creates graphql_gen.yaml
dart run graphql_gen_generator sync    # Freezed models, enums, argument builders
dart run build_runner build
```

```dart
final query = GraphQLQueryBuilder(name: 'Books')
    .withOperation(
      operationName: ApiQueryOperations.books,
      arguments: ApiQueryArguments.books(first: 5),
      fields: Book.query(include: [BookFields.id, BookFields.title]),
    )
    .build();

final books = (response['books'] as List)
    .map((json) => Book.fromJson(json as Map<String, dynamic>));
```

See [graphql_gen_generator](https://pub.dev/packages/graphql_gen_generator)
for the configuration reference, or the `example/` folder for a complete
project. The rest of this page shows the runtime API, which also works with
hand-written models.

## Install

```yaml
dependencies:
  graphql_gen: ^0.1.0
  freezed_annotation: ^3.1.0
  json_annotation: ^4.12.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^3.2.0
  json_serializable: ^6.9.0
  graphql_gen_generator: ^0.1.0
```

Field enums read GraphQL names from json_serializable's `JsonKeys`, so enable
them in `build.yaml`:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          create_json_keys: true
          explicit_to_json: true
```

## Annotate models by hand

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen/graphql_gen.dart';

part 'book.freezed.dart';
part 'book.g.dart';
part 'book.fields.g.dart';

typedef BookFields = _BookFields;

@freezed
@GenerateEnumFields()
abstract class Book with _$Book {
  const factory Book({String? id, String? title, Author? author}) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
```

`dart run build_runner build` generates `BookFields.id`, `BookFields.title`
and `BookFields.author` (which carries `AuthorFields.values` as its nested
selection when `Author` is annotated too).

## Build queries

```dart
final query = GraphQLQueryBuilder(name: 'GetBook')
    .withOperation(
      operationName: 'book',
      arguments: GraphQLArgumentBuilder().withArgument('id', '42'),
      fields: GraphQLFieldBuilder()
          .withEnumFields([BookFields.id, BookFields.title])
          .withField(
            BookFields.author.fieldName,
            nestedField: GraphQLFieldBuilder().withEnumFields([AuthorFields.name]),
          ),
    )
    .build();
// query GetBook {
//   book(id: "42") { id title author { name } }
// }
```

Renaming or removing a field in the schema becomes a compile error at every
place that selects it.

`GraphQLMutationBuilder` and `GraphQLSubscriptionBuilder` work the same way.
Use `alias:` to request the same root field more than once in one document.

Argument values: `String`, `num`, `bool`, Dart `Enum` (written as its name),
`GraphQLEnumValue('RAW')`, `DateTime` (UTC ISO-8601), lists and maps.
`null` arguments are omitted.

The builders produce a document string, so they work with any transport:
`http`, `dio`, `package:graphql`, or your own client.

## Trade-off

Models are shared across all queries, so fields are nullable: a field you did
not select is `null`. If you need exact per-query types, look at
[graphql_codegen](https://pub.dev/packages/graphql_codegen) or
[ferry](https://pub.dev/packages/ferry).
