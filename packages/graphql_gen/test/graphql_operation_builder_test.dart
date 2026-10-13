import 'package:graphql_gen/graphql_gen.dart';
import 'package:test/test.dart';

void main() {
  final fields = GraphQLFieldBuilder().withFields(['id', 'name']);

  test('query with arguments', () {
    final query = GraphQLQueryBuilder()
        .withOperation(
          operationName: 'user',
          arguments: GraphQLArgumentBuilder().withArgument('id', 1),
          fields: fields,
        )
        .build();
    expect(query, 'query {\n  user(id: 1) {\n  id name\n}\n\n}\n');
  });

  test('empty arguments produce no parentheses', () {
    final query = GraphQLQueryBuilder()
        .withOperation(
          operationName: 'me',
          arguments: GraphQLArgumentBuilder().withArgument('x', null),
          fields: fields,
        )
        .build();
    expect(query, contains('  me {'));
  });

  test('aliases allow the same root field twice', () {
    final query = GraphQLQueryBuilder()
        .withOperation(operationName: 'banners', alias: 'home', fields: fields)
        .withOperation(
          operationName: 'banners',
          alias: 'category',
          fields: fields,
        )
        .build();
    expect(query, contains('home: banners {'));
    expect(query, contains('category: banners {'));
  });

  test('named operations', () {
    final mutation = GraphQLMutationBuilder(
      name: 'CreateUser',
    ).withOperation(operationName: 'createUser', fields: fields).build();
    expect(mutation, startsWith('mutation CreateUser {'));
  });

  test('operation keyword follows the builder type', () {
    String build<T extends GraphQLOperationBuilder<T>>(T builder) =>
        builder.withOperation(operationName: 'x', fields: fields).build();
    expect(build(GraphQLQueryBuilder()), startsWith('query {'));
    expect(build(GraphQLMutationBuilder()), startsWith('mutation {'));
    expect(build(GraphQLSubscriptionBuilder()), startsWith('subscription {'));
  });

  test('chaining keeps the concrete builder type', () {
    final GraphQLQueryBuilder builder = GraphQLQueryBuilder().withOperation(
      operationName: 'x',
      fields: fields,
    );
    expect(builder, isA<GraphQLQueryBuilder>());
  });

  test('building without operations throws', () {
    expect(() => GraphQLQueryBuilder().build(), throwsStateError);
  });
}
