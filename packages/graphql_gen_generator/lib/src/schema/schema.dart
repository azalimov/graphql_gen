import 'package:gql/ast.dart';
import 'package:gql/language.dart';

/// A GraphQL type reference such as `[String!]!`.
sealed class TypeRef {
  const TypeRef(this.isNonNull);

  final bool isNonNull;

  /// The innermost named type.
  String get baseName;

  bool get isList => this is ListRef;
}

final class NamedRef extends TypeRef {
  const NamedRef(this.name, {bool isNonNull = false}) : super(isNonNull);

  final String name;

  @override
  String get baseName => name;

  @override
  String toString() => isNonNull ? '$name!' : name;
}

final class ListRef extends TypeRef {
  const ListRef(this.ofType, {bool isNonNull = false}) : super(isNonNull);

  final TypeRef ofType;

  @override
  String get baseName => ofType.baseName;

  @override
  String toString() => isNonNull ? '[$ofType]!' : '[$ofType]';
}

/// A field of an object, interface or input type, or an argument.
class GqlField {
  GqlField({
    required this.name,
    required this.type,
    this.arguments = const [],
    this.hasDefault = false,
    this.deprecationReason,
  });

  final String name;
  final TypeRef type;
  final List<GqlField> arguments;

  /// Whether the schema declares a default value (inputs and arguments).
  final bool hasDefault;

  /// Set when the field carries `@deprecated`.
  final String? deprecationReason;
}

enum GqlTypeKind { object, interface, input }

class GqlObjectType {
  GqlObjectType(this.name, this.kind);

  final String name;
  final GqlTypeKind kind;
  final List<GqlField> fields = [];

  bool get isInput => kind == GqlTypeKind.input;
}

class GqlEnumType {
  GqlEnumType(this.name);

  final String name;
  final List<String> values = [];
}

/// The parts of a GraphQL schema the generator needs, in declaration order.
class GqlSchema {
  GqlSchema._();

  final Map<String, GqlObjectType> types = {};
  final Map<String, GqlEnumType> enums = {};
  final Set<String> scalars = {};
  final Set<String> unions = {};

  String queryType = 'Query';
  String mutationType = 'Mutation';
  String subscriptionType = 'Subscription';

  Set<String> get rootTypes => {queryType, mutationType, subscriptionType};

  GqlObjectType? get query => types[queryType];
  GqlObjectType? get mutation => types[mutationType];
  GqlObjectType? get subscription => types[subscriptionType];

  /// Parses SDL text. Type extensions are merged into their definitions.
  factory GqlSchema.parse(String sdl, {String? url}) {
    final schema = GqlSchema._();
    final document = parseString(sdl, url: url);

    GqlObjectType objectType(String name, GqlTypeKind kind) =>
        schema.types.putIfAbsent(name, () => GqlObjectType(name, kind));
    GqlEnumType enumType(String name) =>
        schema.enums.putIfAbsent(name, () => GqlEnumType(name));

    for (final definition in document.definitions) {
      switch (definition) {
        case SchemaDefinitionNode(:final operationTypes):
          for (final op in operationTypes) {
            final name = op.type.name.value;
            switch (op.operation) {
              case OperationType.query:
                schema.queryType = name;
              case OperationType.mutation:
                schema.mutationType = name;
              case OperationType.subscription:
                schema.subscriptionType = name;
            }
          }
        case ObjectTypeDefinitionNode(:final name, :final fields):
        case ObjectTypeExtensionNode(:final name, :final fields):
          objectType(
            name.value,
            GqlTypeKind.object,
          ).fields.addAll(fields.map(_field));
        case InterfaceTypeDefinitionNode(:final name, :final fields):
        case InterfaceTypeExtensionNode(:final name, :final fields):
          objectType(
            name.value,
            GqlTypeKind.interface,
          ).fields.addAll(fields.map(_field));
        case InputObjectTypeDefinitionNode(:final name, :final fields):
        case InputObjectTypeExtensionNode(:final name, :final fields):
          objectType(
            name.value,
            GqlTypeKind.input,
          ).fields.addAll(fields.map(_inputValue));
        case EnumTypeDefinitionNode(:final name, :final values):
        case EnumTypeExtensionNode(:final name, :final values):
          enumType(name.value).values.addAll(values.map((v) => v.name.value));
        case ScalarTypeDefinitionNode(:final name):
          schema.scalars.add(name.value);
        case UnionTypeDefinitionNode(:final name):
          schema.unions.add(name.value);
        default:
          break;
      }
    }
    return schema;
  }

  static GqlField _field(FieldDefinitionNode node) => GqlField(
    name: node.name.value,
    type: _typeRef(node.type),
    arguments: node.args.map(_inputValue).toList(),
    deprecationReason: _deprecationReason(node.directives),
  );

  static GqlField _inputValue(InputValueDefinitionNode node) => GqlField(
    name: node.name.value,
    type: _typeRef(node.type),
    hasDefault: node.defaultValue != null,
    deprecationReason: _deprecationReason(node.directives),
  );

  static TypeRef _typeRef(TypeNode node) => switch (node) {
    NamedTypeNode(:final name, :final isNonNull) => NamedRef(
      name.value,
      isNonNull: isNonNull,
    ),
    ListTypeNode(:final type, :final isNonNull) => ListRef(
      _typeRef(type),
      isNonNull: isNonNull,
    ),
    _ => throw UnsupportedError('Unknown type node ${node.runtimeType}'),
  };

  static String? _deprecationReason(List<DirectiveNode> directives) {
    for (final directive in directives) {
      if (directive.name.value != 'deprecated') continue;
      for (final argument in directive.arguments) {
        final value = argument.value;
        if (argument.name.value == 'reason' && value is StringValueNode) {
          return value.value;
        }
      }
      return 'No longer supported';
    }
    return null;
  }
}
