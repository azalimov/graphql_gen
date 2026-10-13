import 'graphql_argument_builder.dart';
import 'graphql_field_builder.dart';

/// The kind of a GraphQL operation.
enum GraphQLOperationType { query, mutation, subscription }

/// Builds a GraphQL document with one or more root fields.
///
/// Use [GraphQLQueryBuilder], [GraphQLMutationBuilder] or
/// [GraphQLSubscriptionBuilder] rather than extending this class.
abstract class GraphQLOperationBuilder<T extends GraphQLOperationBuilder<T>> {
  GraphQLOperationBuilder(this.type, {this.name});

  /// Whether this document is a query, mutation or subscription.
  final GraphQLOperationType type;

  /// Optional operation name, written as `query GetUser { ... }`.
  ///
  /// Named operations are easier to find in server logs and tracing tools.
  final String? name;

  final List<_RootField> _rootFields = [];

  /// Adds the root field [operationName] selecting [fields].
  ///
  /// Use [alias] to request the same root field more than once:
  ///
  /// ```dart
  /// GraphQLQueryBuilder()
  ///     .withOperation(operationName: 'banners', alias: 'home', fields: f)
  ///     .withOperation(operationName: 'banners', alias: 'category', fields: f);
  /// ```
  T withOperation({
    required String operationName,
    String? alias,
    GraphQLArgumentBuilder? arguments,
    required GraphQLFieldBuilder fields,
  }) {
    _rootFields.add(
      _RootField(
        name: operationName,
        alias: alias,
        arguments: arguments?.build(),
        fields: fields.build(),
      ),
    );
    return this as T;
  }

  /// Returns the complete GraphQL document.
  ///
  /// Throws a [StateError] if no root field was added.
  ///
  /// ```dart
  /// GraphQLQueryBuilder()
  ///     .withOperation(
  ///       operationName: 'user',
  ///       arguments: GraphQLArgumentBuilder().withArgument('id', 1),
  ///       fields: GraphQLFieldBuilder().withFields(['id', 'name']),
  ///     )
  ///     .build();
  /// // query {
  /// //   user(id: 1) {
  /// //   id name
  /// // }
  /// // }
  /// ```
  String build() {
    if (_rootFields.isEmpty) {
      throw StateError('At least one operation must be added.');
    }
    final header = name == null ? type.name : '${type.name} $name';
    final body = _rootFields.map((field) => field.build()).join('\n  ');
    return '''
$header {
  $body
}
''';
  }
}

/// Builds a GraphQL `query` document.
class GraphQLQueryBuilder extends GraphQLOperationBuilder<GraphQLQueryBuilder> {
  GraphQLQueryBuilder({super.name}) : super(GraphQLOperationType.query);
}

/// Builds a GraphQL `mutation` document.
class GraphQLMutationBuilder
    extends GraphQLOperationBuilder<GraphQLMutationBuilder> {
  GraphQLMutationBuilder({super.name}) : super(GraphQLOperationType.mutation);
}

/// Builds a GraphQL `subscription` document.
class GraphQLSubscriptionBuilder
    extends GraphQLOperationBuilder<GraphQLSubscriptionBuilder> {
  GraphQLSubscriptionBuilder({super.name})
    : super(GraphQLOperationType.subscription);
}

class _RootField {
  _RootField({
    required this.name,
    required this.alias,
    required this.arguments,
    required this.fields,
  });

  final String name;
  final String? alias;
  final String? arguments;
  final String fields;

  String build() {
    final args = (arguments != null && arguments!.isNotEmpty)
        ? '($arguments)'
        : '';
    final aliasPrefix = alias != null ? '$alias: ' : '';
    return '''
$aliasPrefix$name$args {
  $fields
}
''';
  }
}
