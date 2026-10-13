# Roadmap and ideas

Ideas that came up while using graphql_gen on a real project. None of them is
scheduled; they are written down so the reasoning is not lost.

## Argument name constants

Hand-written `GraphQLArgumentBuilder().withArgument('pageSize', ...)` calls
still spell argument names as strings. Generate one class per operation with a
constant per argument:

```dart
abstract final class OrdersArguments {
  static const pageSize = 'pageSize';
  static const statuses = 'statuses';
}

GraphQLArgumentBuilder().withArgument(OrdersArguments.pageSize, pageSize);
```

`withArgument(String, Object?)` stays as it is. A renamed or removed argument
becomes a compile error after `sync`. Needs: a configurable suffix, a
`Query`/`Mutation` prefix when two roots share an operation name or the name
clashes with a schema type, and the same keyword escaping as model fields.

Cheap, but it does not stop `OrdersArguments.pageSize` from being passed to
another operation.

## Linking an operation to its arguments

Today the operation name and its arguments are independent:

```dart
GraphQLQueryBuilder().withOperation(
  operationName: ApiQueryOperations.orders,
  arguments: ApiQueryArguments.products(...), // compiles
  fields: ...,
);
```

The generated `ApiQueryArguments.orders(pageSize: ..., statuses: ...)` already
accepts only that operation's arguments with the right types. What is missing is
the link to the operation name.

### Option: one generated call per operation (preferred)

```dart
GraphQLQueryBuilder().withCall(
  ApiQueries.orders(pageSize: 10),
  fields: GraphQLFieldBuilder().withEnumFields(OrderFields.values),
);
```

Name and arguments come from one place, so there is nothing to mismatch and no
generics are needed. The existing `withOperation` API can stay.

A further step types the result: `ApiQueries.orders(...)` returns a
`GraphQLCall<R>` with `R parse(Object? json)`, removing the hand-written
operation name and `fromJson` when reading the response. Generic wrapper types
that are skipped by `skip_types` would need a mapping in the config. Typing
`fields` by the result type (only `OrderFields` accepted) could come after that.

### Option: a type parameter on the builder

```dart
GraphQLArgumentBuilder<OrdersArguments>()
    .add(OrdersArguments.pageSize(10))
    .add(OrdersArguments.statuses([...]));
```

This works only if:

- the type parameter is fixed by the receiver, not inferred from two
  arguments; and
- each value goes through a function with a concrete parameter type.

Dart generics are covariant. With
`withArgument<T, V>(GraphQLArgument<T, V> arg, V value)`, the call
`withArgument(OrdersArguments.pageSize, 'abc')` compiles with `V = Object`.
Likewise `withOperation<T>(GraphQLOperation<T>, GraphQLArgumentBuilder<T>)`
accepts mismatched operations with `T = Object`.

Done right, it gives the same guarantees as the generated
`ApiQueryArguments.orders(...)` methods with more code, so the one-call option
above is the better way to add the operation link.
