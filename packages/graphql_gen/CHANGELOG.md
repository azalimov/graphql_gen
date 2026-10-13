## 0.1.1

- No API changes; released together with `graphql_gen_generator` 0.1.1.

## 0.1.0

- Initial release.
- `GraphQLQueryBuilder`, `GraphQLMutationBuilder`, `GraphQLSubscriptionBuilder`
  sharing one `GraphQLOperationBuilder`, with optional operation names.
- `GraphQLFieldBuilder` with `withEnumFields` for generated field enums.
- `GraphQLArgumentBuilder` with spec-compliant string escaping and
  `GraphQLEnumValue` for raw enum literals.
- `GraphQLError` / `GraphQLErrorResponse` models.
