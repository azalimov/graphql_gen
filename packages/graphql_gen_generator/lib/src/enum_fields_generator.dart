import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:graphql_gen/graphql_gen.dart';
import 'package:source_gen/source_gen.dart';

/// Names that would clash with members every Dart enum already has.
const _reservedEnumMembers = {'values', 'index', 'hashCode', 'runtimeType'};

const _annotationChecker = TypeChecker.typeNamed(
  GenerateEnumFields,
  inPackage: 'graphql_gen',
);

/// Generates a private `_<Class>Fields` enum implementing [EnumFields] for
/// each class annotated with [GenerateEnumFields].
///
/// Fields are read from, in order of preference: public instance fields,
/// public abstract getters, or the first factory constructor's parameters
/// (the Freezed case). A field whose type, or list element type, is itself
/// annotated gets `nestedFields: <Type>Fields.values`.
class EnumFieldsGenerator extends GeneratorForAnnotation<GenerateEnumFields> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@GenerateEnumFields can only be applied to classes.',
        element: element,
      );
    }

    final className = element.displayName;
    final enumName = '_${className}Fields';
    final entries = [
      for (final (name, type) in _collectFields(element))
        _entry(className, name, type),
    ];

    if (entries.isEmpty) {
      throw InvalidGenerationSourceError(
        'No public fields, abstract getters or factory constructor parameters '
        'found in "$className".',
        element: element,
      );
    }

    return '''
enum $enumName implements EnumFields {
${entries.join(',\n')}
;

  final String _fieldName;
  final List<EnumFields>? _nestedFields;
  const $enumName(this._fieldName, {List<EnumFields>? nestedFields})
      : _nestedFields = nestedFields;

  @override
  String get fieldName => _fieldName;

  @override
  List<EnumFields>? get nestedFields => _nestedFields;
}
''';
  }

  Iterable<(String, DartType)> _collectFields(ClassElement element) {
    final fields = element.fields.where((f) => !f.isStatic && !f.isPrivate);
    if (fields.isNotEmpty) {
      return fields.map((f) => (f.displayName, f.type));
    }

    final getters = element.getters.where(
      (g) => !g.isStatic && !g.isPrivate && g.isAbstract,
    );
    if (getters.isNotEmpty) {
      return getters.map((g) => (g.displayName, g.returnType));
    }

    final factory = element.constructors
        .where((c) => c.isFactory && c.formalParameters.isNotEmpty)
        .firstOrNull;
    if (factory == null) return const [];
    return factory.formalParameters
        .where((p) => p.name != null && !p.name!.startsWith('_'))
        .map((p) => (p.name!, p.type));
  }

  String _entry(String className, String fieldName, DartType type) {
    final nestedType = _nestedAnnotatedType(type);
    final nested = nestedType == null
        ? ''
        : ', nestedFields: ${nestedType}Fields.values';
    final memberName = _reservedEnumMembers.contains(fieldName)
        ? '${fieldName}_'
        : fieldName;
    return '  $memberName(${className}JsonKeys.$fieldName$nested)';
  }

  /// The annotated class name behind [type] or `List<type>`, if any.
  String? _nestedAnnotatedType(DartType type) {
    final element = type.element;
    if (element is ClassElement &&
        _annotationChecker.hasAnnotationOf(element)) {
      return element.displayName;
    }
    if (type is ParameterizedType &&
        type.isDartCoreList &&
        type.typeArguments.isNotEmpty) {
      return _nestedAnnotatedType(type.typeArguments.first);
    }
    return null;
  }
}
