import '../config.dart';
import '../naming.dart';
import '../schema/schema.dart';
import 'type_mapper.dart';

/// A constructor parameter of a generated model.
class ModelField {
  ModelField({
    required this.graphqlName,
    required this.dartName,
    required this.dartType,
    required this.isRequired,
    required this.source,
  });

  final String graphqlName;
  final String dartName;

  /// Type without `required`, with `?` when not required.
  final String dartType;
  final bool isRequired;
  final GqlField source;
}

/// Renders Freezed models for object, interface and input types.
class ModelTemplate {
  ModelTemplate(this.config, this.types, {required this.convertersImport});

  final GraphQLGenConfig config;
  final TypeMapper types;
  final String convertersImport;

  /// Constructor parameters of [type] as the generator writes them.
  List<ModelField> fields(GqlObjectType type) => [
    for (final field in type.fields) _field(type, field),
  ];

  ModelField _field(GqlObjectType type, GqlField field) {
    final isRequired =
        type.isInput &&
        field.type.isNonNull &&
        (!field.hasDefault || config.inputDefaultsRequired);
    final base = types.base(field.type);
    return ModelField(
      graphqlName: field.name,
      dartName: safeFieldName(field.name),
      dartType: isRequired ? base : '$base?',
      isRequired: isRequired,
      source: field,
    );
  }

  String render(GqlObjectType type) {
    final className = type.name;
    final isInput = type.isInput;
    final fileName = toSnakeCase(className);
    final modelFields = fields(type);

    final listConverters = <String, String>{};
    var usesConverters = false;
    var needsModelsImport = false;
    final lines = <String>[];

    for (final field in modelFields) {
      final ref = field.source.type;
      if (!types.isScalar(ref.baseName)) needsModelsImport = true;

      final annotations = <String>[];
      if (field.source.deprecationReason case final reason?) {
        annotations.add("@Deprecated('${escapeDartString(reason)}')");
      }
      if (ref is ListRef && !ref.isNonNull) {
        annotations.add('@Default([])');
      }

      final jsonKey = <String>[];
      if (field.dartName != field.graphqlName) {
        jsonKey.add("name: '${field.graphqlName}'");
      }
      if (isInput && types.isEnum(ref.baseName)) {
        final converter = _enumConverter(className, field, listConverters);
        if (converter != null) {
          jsonKey.add('toJson: $converter');
          usesConverters = true;
        }
      }
      if (jsonKey.isNotEmpty) {
        annotations.add('@JsonKey(${jsonKey.join(', ')})');
      }

      final prefix = annotations.isEmpty ? '' : '${annotations.join(' ')} ';
      final required = field.isRequired ? 'required ' : '';
      lines.add('    $prefix$required${field.dartType} ${field.dartName},');
    }

    final b = StringBuffer()
      ..writeln("import 'package:freezed_annotation/freezed_annotation.dart';");
    if (needsModelsImport) b.writeln("import '${config.modelsImport}';");
    if (usesConverters && !(needsModelsImport && config.modelsImportIsBarrel)) {
      b.writeln("import '$convertersImport';");
    }
    if (!isInput) b.writeln("import '${config.runtimeImport}';");
    b
      ..writeln()
      ..writeln("part '$fileName.freezed.dart';")
      ..writeln("part '$fileName.g.dart';");
    if (!isInput) b.writeln("part '$fileName.fields.g.dart';");
    b
      ..writeln()
      ..writeln('@freezed');
    if (!isInput) b.writeln('@GenerateEnumFields()');
    b
      ..writeln('abstract class $className with _\$$className {')
      ..writeln('  const factory $className({');
    lines.forEach(b.writeln);
    b
      ..writeln('  }) = _$className;')
      ..writeln()
      ..writeln(
        '  factory $className.fromJson(Map<String, dynamic> json) => '
        '_\$${className}FromJson(json);',
      );
    if (!isInput) {
      b
        ..writeln()
        ..writeln(
          '  static GraphQLFieldBuilder query({required '
          'Iterable<${className}Fields> include}) =>',
        )
        ..writeln('      GraphQLFieldBuilder().withEnumFields(include);');
    }
    b
      ..writeln('}')
      ..writeln();
    if (listConverters.isNotEmpty) {
      listConverters.values.forEach(b.writeln);
      b.writeln();
    }
    b.writeln('typedef ${className}JsonKeys = _\$${className}JsonKeys;');
    if (!isInput) {
      b.writeln('typedef ${className}Fields = _${className}Fields;');
    }
    b.writeln();
    return b.toString();
  }

  /// Name of the `toJson` converter for an enum-typed input field. List
  /// converters are added to [listConverters]; nested lists get none.
  String? _enumConverter(
    String className,
    ModelField field,
    Map<String, String> listConverters,
  ) {
    final ref = field.source.type;
    final enumName = ref.baseName;
    final single = '${lowerFirst(enumName)}ToJson';

    if (ref is NamedRef) {
      return field.isRequired ? single : 'nullable${enumName}ToJson';
    }
    if (ref is ListRef && ref.ofType is NamedRef) {
      final name = '_${lowerFirst(className)}ListOf${enumName}ToJson';
      final nullable = !field.isRequired || !ref.ofType.isNonNull;
      final element = ref.ofType.isNonNull ? enumName : '$enumName?';
      final mapper = ref.ofType.isNonNull
          ? '$single(e)'
          : 'e == null ? null : $single(e)';
      final objectType = ref.ofType.isNonNull ? 'Object' : 'Object?';
      // A nullable converter also accepts a non-null list, so it wins when
      // two fields of the same class need one.
      if (nullable || !listConverters.containsKey(name)) {
        listConverters[name] = nullable
            ? '''
List<$objectType>? $name(List<$element>? list) =>
    list?.map((e) => $mapper).toList();
'''
            : '''
List<$objectType> $name(List<$element> list) =>
    list.map((e) => $mapper).toList();
''';
      }
      return name;
    }
    return null;
  }
}
