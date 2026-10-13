## 0.1.1

- Generated field enums no longer trigger `prefer_initializing_formals`.
- Enum files with non-lowerCamelCase values ignore `constant_identifier_names`.
- README: exclude generated files from analysis.

Run `sync --regenerate` and `build_runner build` to pick up the changes.

## 0.1.0

- Initial release.
- `graphql_gen_generator` CLI with `init`, `fetch` and `sync`
  (`--fetch`, `--dry-run`, `--regenerate`).
- Schema parsing with `package:gql`: interfaces, unions, type extensions,
  descriptions, multi-line arguments, `@deprecated`.
- Schema download as SDL or through introspection, with headers from the
  environment.
- Freezed models, enums, enum converters, operation names, typed argument
  builders and a barrel, configured in `graphql_gen.yaml`.
- `enum_fields` build_runner builder for `@GenerateEnumFields()`.
