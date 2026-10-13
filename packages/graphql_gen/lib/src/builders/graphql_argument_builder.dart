/// Builds a GraphQL argument list such as `id: 1, filter: { name: "x" }`.
///
/// Arguments whose value is `null` are omitted.
class GraphQLArgumentBuilder {
  final Map<String, Object?> _arguments = {};

  /// Adds the argument [name], replacing any previous value.
  ///
  /// Supported values: [String], [num], [bool], [Enum] (written as its
  /// `name`), [DateTime] (written as a UTC ISO-8601 string), [List], [Map]
  /// with string keys, and [GraphQLEnumValue].
  GraphQLArgumentBuilder withArgument(String name, Object? value) {
    _arguments[name] = value;
    return this;
  }

  /// Whether no non-null argument has been added.
  bool get isEmpty => _arguments.values.every((value) => value == null);

  /// Returns the arguments formatted for use between parentheses.
  ///
  /// ```dart
  /// GraphQLArgumentBuilder()
  ///     .withArgument('id', 123)
  ///     .withArgument('name', 'John Doe')
  ///     .build(); // id: 123, name: "John Doe"
  /// ```
  String build() {
    return _arguments.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}: ${formatGraphQLValue(entry.value)}')
        .join(', ');
  }
}

/// A raw GraphQL enum literal, written without quotes.
///
/// Use it for enum values that are not Dart [Enum]s, for example values
/// coming from JSON.
final class GraphQLEnumValue {
  const GraphQLEnumValue(this.value);

  /// The enum literal, for example `ACTIVE`.
  final String value;

  @override
  bool operator ==(Object other) =>
      other is GraphQLEnumValue && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// Formats [value] as a GraphQL input literal.
String formatGraphQLValue(Object? value) {
  return switch (value) {
    null => 'null',
    String() => _formatString(value),
    num() || bool() => value.toString(),
    Enum() => value.name,
    GraphQLEnumValue() => value.value,
    DateTime() => '"${value.toUtc().toIso8601String()}"',
    Iterable<Object?>() => '[${value.map(formatGraphQLValue).join(', ')}]',
    Map<Object?, Object?>() =>
      '{ ${value.entries.map((e) => '${e.key}: ${formatGraphQLValue(e.value)}').join(', ')} }',
    _ => throw ArgumentError.value(
      value,
      'value',
      'Unsupported GraphQL argument type ${value.runtimeType}',
    ),
  };
}

String _formatString(String value) {
  final buffer = StringBuffer('"');
  for (final rune in value.runes) {
    switch (rune) {
      case 0x22:
        buffer.write(r'\"');
      case 0x5C:
        buffer.write(r'\\');
      case 0x0A:
        buffer.write(r'\n');
      case 0x0D:
        buffer.write(r'\r');
      case 0x09:
        buffer.write(r'\t');
      case 0x08:
        buffer.write(r'\b');
      case 0x0C:
        buffer.write(r'\f');
      default:
        if (rune < 0x20) {
          buffer.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
        } else {
          buffer.writeCharCode(rune);
        }
    }
  }
  buffer.write('"');
  return buffer.toString();
}
