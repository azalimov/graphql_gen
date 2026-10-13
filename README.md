# graphql_gen

Schema-first GraphQL for Dart and Flutter: Freezed models for every schema
type, generated field enums, and a type-safe runtime query builder.

| Package | |
|---|---|
| [graphql_gen](packages/graphql_gen) | Runtime builders, annotations, error models |
| [graphql_gen_generator](packages/graphql_gen_generator) | Schema sync CLI and `build_runner` field-enum generator |
| [example](example) | End-to-end project generated from `example/schema.graphql` |

Ideas for later versions: [docs/roadmap.md](docs/roadmap.md).

## Development

```bash
dart pub get
dart analyze
dart test packages/graphql_gen packages/graphql_gen_generator
```

Releases are published from GitHub Actions when a tag
`<package>-v<version>` is pushed, e.g. `graphql_gen-v0.1.0`.
