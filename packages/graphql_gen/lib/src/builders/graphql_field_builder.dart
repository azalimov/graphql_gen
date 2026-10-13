import '../enum_fields.dart';

/// Builds a GraphQL selection set such as `id name author { id }`.
class GraphQLFieldBuilder {
  final Map<String, GraphQLFieldBuilder?> _fields = {};

  GraphQLFieldBuilder();

  /// Adds [fieldName], optionally selecting [nestedField] inside it.
  ///
  /// ```dart
  /// GraphQLFieldBuilder()
  ///     .withField('user', nestedField: GraphQLFieldBuilder()
  ///         .withField('id')
  ///         .withField('name'));
  /// ```
  GraphQLFieldBuilder withField(
    String fieldName, {
    GraphQLFieldBuilder? nestedField,
  }) {
    _fields[fieldName] = nestedField;
    return this;
  }

  /// Adds scalar fields by name.
  GraphQLFieldBuilder withFields(Iterable<String> fieldNames) {
    for (final name in fieldNames) {
      _fields[name] = null;
    }
    return this;
  }

  /// Adds fields from generated enums.
  ///
  /// Object fields select all of their nested fields recursively. To select
  /// only some nested fields, use [withField] with a nested builder instead.
  GraphQLFieldBuilder withEnumFields(Iterable<EnumFields> enums) {
    for (final e in enums) {
      final nested = e.nestedFields;
      _fields[e.fieldName] = nested == null
          ? null
          : GraphQLFieldBuilder().withEnumFields(nested);
    }
    return this;
  }

  /// Whether no field has been added.
  bool get isEmpty => _fields.isEmpty;

  /// Returns the selection set without the surrounding braces.
  ///
  /// ```dart
  /// GraphQLFieldBuilder()
  ///     .withField('user', nestedField: GraphQLFieldBuilder()
  ///         .withField('id')
  ///         .withField('name'))
  ///     .build(); // user { id name }
  /// ```
  String build() {
    return _fields.entries
        .map((entry) {
          final nested = entry.value?.build();
          if (nested != null && nested.isNotEmpty) {
            return '${entry.key} { $nested }';
          }
          return entry.key;
        })
        .join(' ');
  }
}
