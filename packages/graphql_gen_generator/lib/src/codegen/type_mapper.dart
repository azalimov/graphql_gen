import '../config.dart';
import '../schema/schema.dart';

const _builtInScalars = {
  'String': 'String',
  'ID': 'String',
  'Int': 'int',
  'Float': 'double',
  'Boolean': 'bool',
};

/// Maps GraphQL type references to Dart types.
class TypeMapper {
  TypeMapper(this.schema, this.config);

  final GqlSchema schema;
  final GraphQLGenConfig config;

  /// Custom scalars that have no Dart mapping, collected for warnings.
  final Set<String> unmappedScalars = {};

  bool isEnum(String name) => schema.enums.containsKey(name);

  bool isInput(String name) => schema.types[name]?.isInput ?? false;

  /// Whether [name] maps to a Dart core type that needs no import.
  bool isScalar(String name) =>
      _builtInScalars.containsKey(name) ||
      config.scalars.containsKey(name) ||
      schema.scalars.contains(name);

  /// The Dart type of a named GraphQL type, without nullability.
  String named(String name) {
    if (_builtInScalars[name] case final dart?) return dart;
    if (config.scalars[name] case final dart?) return dart;
    if (schema.scalars.contains(name)) {
      unmappedScalars.add(name);
      return 'Object';
    }
    if (schema.unions.contains(name)) return 'Map<String, dynamic>';
    return name;
  }

  /// The Dart type of [ref] without the outer nullability marker. List
  /// elements keep their own nullability.
  String base(TypeRef ref) => switch (ref) {
    NamedRef(:final name) => named(name),
    ListRef(:final ofType) => 'List<${_element(ofType)}>',
  };

  String _element(TypeRef ref) => ref.isNonNull ? base(ref) : '${base(ref)}?';
}
