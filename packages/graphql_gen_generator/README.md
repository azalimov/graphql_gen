# graphql_gen_generator

Code generation for [graphql_gen](https://pub.dev/packages/graphql_gen):

- a **CLI** that turns a GraphQL schema into Freezed models, Dart enums,
  operation-name constants and typed argument builders;
- a **build_runner builder** that generates field enums for every class
  annotated with `@GenerateEnumFields()`.

## Setup

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^3.2.0
  json_serializable: ^6.9.0
  graphql_gen_generator: ^0.1.0
```

`build.yaml` — field enums read GraphQL names from json_serializable's
`JsonKeys`, and nested inputs need `explicit_to_json`:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          create_json_keys: true
          explicit_to_json: true
```

## Usage

```bash
dart run graphql_gen_generator init     # writes graphql_gen.yaml
dart run graphql_gen_generator fetch    # downloads the schema (optional)
dart run graphql_gen_generator sync     # generates sources
dart run build_runner build             # freezed, json_serializable, field enums
```

`sync` options:

| Flag | |
|---|---|
| `--fetch` | Download the schema first |
| `--dry-run` | Print planned changes only |
| `--regenerate` | Rewrite every generated file and delete files the schema no longer produces, including enums. Run it after upgrading this package so template changes apply. |

Without `--regenerate`, an existing model is rewritten only when its
constructor parameters no longer match the schema, so hand edits that keep
the same fields survive. Models of removed types are deleted together with
their generated parts.

## What gets generated

For `output: lib/api` and `class_prefix: Api`:

| Schema | File |
|---|---|
| `enum Genre` | `enums/genre.dart` |
| `type Book`, `interface Node` | `models/book/book.dart` — Freezed, `@GenerateEnumFields()`, `Book.query(include: [...])` |
| `input BookFilter` | `inputs/book_filter/book_filter.dart` — Freezed with enum `toJson` converters |
| Root fields | `api_query_operations.dart`, `api_mutation_operations.dart`, `api_subscription_operations.dart` |
| Root field arguments | `api_query_arguments.dart`, … — `ApiQueryArguments.books(filter: ..., first: 5)` |
| Enum converters | `api_enum_converters.dart` |
| Everything | `api.dart` barrel |

Type rules:

- Response model fields are always nullable: a field you did not select is
  `null`.
- Input fields follow the schema. A non-null input field with a default value
  is optional unless `input_defaults_required: true`.
- Optional lists get `@Default([])`.
- Fields named like Dart keywords are renamed (`default` → `defaultValue`)
  with `@JsonKey(name: ...)`.
- `@deprecated` becomes `@Deprecated`.
- Unions become `Map<String, dynamic>`. Custom scalars without a mapping become
  `Object` with a warning.

GraphQL enum values keep their schema spelling; enum files that need it get
`// ignore_for_file: constant_identifier_names`.

json_serializable's `JsonKeys` classes of input types are never read, which
shows up as `unused_field` warnings. Exclude generated files from analysis:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

## Configuration

```yaml
schema:
  file: schema.graphql              # read by sync, written by fetch
  url: https://api.example.com/graphql
  introspection: true               # POST an introspection query; false = GET SDL
  headers:
    Authorization: Bearer ${API_TOKEN}   # ${VAR} reads the environment

output: lib/api
layout: by_kind                     # or hotchocolate_dto
barrel: api.dart                    # false to disable
class_prefix: Api
models_import: package:my_app/api/api.dart          # default: the barrel
runtime_import: package:graphql_gen/graphql_gen.dart

scalars:
  DateTime: DateTime
  JSON: Map<String, dynamic>

skip_types: ['^PaginatedResponseOf']   # regular expressions
preserve: ['enums/legacy_*']           # never deleted by --regenerate
input_defaults_required: false

names:                              # override generated class names
  mutation_operations: MyMutations
files:                              # override generated file names
  mutation_operations: my_mutations.dart
```

Keys under `names:` / `files:`: `query_operations`, `mutation_operations`,
`subscription_operations`, `query_arguments`, `mutation_arguments`,
`subscription_arguments`, `enum_converters`.

## Field enums without the CLI

The builder also works on hand-written classes. Fields come from public
instance fields, abstract getters, or the first factory constructor's
parameters (so Freezed classes work); see the
[graphql_gen README](https://pub.dev/packages/graphql_gen).
