import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'naming.dart';

/// Where generated models are placed under [GraphQLGenConfig.output].
enum ModelLayout {
  /// `enums/<name>.dart`, `models/<name>/<name>.dart`,
  /// `inputs/<name>/<name>.dart`.
  byKind,

  /// HotChocolate-style DTO naming: `*ResponseDto` in `model/response/`,
  /// `Create*/Update*RequestDtoInput` in `model/request/<entity>/`, other
  /// inputs in `model/shared/<base>/request/`, everything else in
  /// `model/shared/<base>/response/`.
  hotchocolateDto,
}

/// The generated single-file outputs, used as keys under `names:`/`files:`.
enum GeneratedFile {
  queryOperations('QueryOperations'),
  mutationOperations('MutationOperations'),
  subscriptionOperations('SubscriptionOperations'),
  queryArguments('QueryArguments'),
  mutationArguments('MutationArguments'),
  subscriptionArguments('SubscriptionArguments'),
  enumConverters('EnumConverters');

  const GeneratedFile(this.suffix);

  final String suffix;

  String get yamlKey => toSnakeCase(name);
}

/// Where the schema comes from: the `schema` section of `graphql_gen.yaml`.
class SchemaSource {
  SchemaSource({
    required this.file,
    this.url,
    this.introspection = false,
    this.headers = const {},
  });

  /// Local SDL file read by `sync` and written by `fetch`.
  final String file;

  /// Endpoint `fetch` downloads from.
  final String? url;

  /// When true, `fetch` POSTs an introspection query to [url] and converts
  /// the result to SDL. Otherwise [url] must return SDL text.
  final bool introspection;

  /// Request headers; `${NAME}` is replaced with the environment variable.
  final Map<String, String> headers;
}

/// Settings read from `graphql_gen.yaml`.
class GraphQLGenConfig {
  GraphQLGenConfig({
    required this.packageName,
    required this.schema,
    required this.output,
    this.layout = ModelLayout.byKind,
    this.classPrefix = 'Api',
    this.barrel = 'api.dart',
    String? modelsImport,
    this.runtimeImport = 'package:graphql_gen/graphql_gen.dart',
    this.scalars = const {},
    this.skipTypes = const [],
    this.preserve = const [],
    this.inputDefaultsRequired = false,
    this.classNames = const {},
    this.fileNames = const {},
  }) : _modelsImport = modelsImport;

  static const defaultPath = 'graphql_gen.yaml';

  final String packageName;
  final SchemaSource schema;

  /// Directory, relative to the package root, that receives all output.
  final String output;
  final ModelLayout layout;
  final String classPrefix;

  /// Barrel file name inside [output], or `null` to skip it.
  final String? barrel;
  final String? _modelsImport;

  /// Import that gives generated code `GraphQLFieldBuilder`,
  /// `GenerateEnumFields` and `GraphQLArgumentBuilder`.
  final String runtimeImport;

  /// Custom scalar name to Dart type, e.g. `DateTime: DateTime`.
  final Map<String, String> scalars;

  /// Regular expressions of type names that get no model.
  final List<RegExp> skipTypes;

  /// Paths relative to [output] (with `*` wildcards) that `--regenerate`
  /// never deletes.
  final List<String> preserve;

  /// When true, a non-null input field with a default value is still a
  /// `required` constructor parameter.
  final bool inputDefaultsRequired;

  final Map<GeneratedFile, String> classNames;
  final Map<GeneratedFile, String> fileNames;

  /// Import every generated file uses to see the other generated types.
  String get modelsImport {
    if (_modelsImport != null) return _modelsImport;
    if (barrel == null) {
      throw StateError('Set `models_import` when `barrel` is disabled.');
    }
    return packageImport(p.join(output, barrel!));
  }

  String className(GeneratedFile file) =>
      classNames[file] ?? '$classPrefix${file.suffix}';

  String fileName(GeneratedFile file) =>
      fileNames[file] ?? '${toSnakeCase(className(file))}.dart';

  /// `package:` URI for [path] relative to the package root (under `lib/`).
  String packageImport(String path) {
    final normalized = p.posix.normalize(path.replaceAll(r'\', '/'));
    if (!normalized.startsWith('lib/')) {
      throw StateError('$path must be inside lib/ to be importable.');
    }
    return 'package:$packageName/${normalized.substring(4)}';
  }

  bool isSkipped(String typeName) =>
      skipTypes.any((pattern) => pattern.hasMatch(typeName));

  bool isPreserved(String relativePath) => preserve.any((glob) {
    final pattern = RegExp(
      '^${glob.split('*').map(RegExp.escape).join('[^/]*')}\$',
    );
    return pattern.hasMatch(relativePath);
  });

  /// Loads [configPath] from [root]; [root]/pubspec.yaml supplies the
  /// package name.
  static GraphQLGenConfig load({
    String root = '.',
    String configPath = defaultPath,
  }) {
    final pubspec = File(p.join(root, 'pubspec.yaml'));
    if (!pubspec.existsSync()) {
      throw StateError('No pubspec.yaml in ${p.absolute(root)}.');
    }
    final packageName =
        (loadYaml(pubspec.readAsStringSync()) as YamlMap)['name'] as String;

    final file = File(p.join(root, configPath));
    if (!file.existsSync()) {
      throw StateError('No $configPath found. Run `init` to create one.');
    }
    final yaml = loadYaml(file.readAsStringSync());
    return fromYaml(
      yaml is YamlMap ? yaml : YamlMap(),
      packageName: packageName,
    );
  }

  static GraphQLGenConfig fromYaml(
    Map<dynamic, dynamic> yaml, {
    required String packageName,
  }) {
    final schema = _map(yaml['schema']);
    final barrel = yaml['barrel'];

    return GraphQLGenConfig(
      packageName: packageName,
      schema: SchemaSource(
        file: schema['file'] as String? ?? 'schema.graphql',
        url: schema['url'] as String?,
        introspection: schema['introspection'] as bool? ?? false,
        headers: _stringMap(schema['headers']),
      ),
      output: yaml['output'] as String? ?? 'lib/api',
      layout: switch (yaml['layout']) {
        null || 'by_kind' => ModelLayout.byKind,
        'hotchocolate_dto' => ModelLayout.hotchocolateDto,
        final other => throw FormatException('Unknown layout "$other".'),
      },
      classPrefix: yaml['class_prefix'] as String? ?? 'Api',
      barrel: barrel == false ? null : barrel as String? ?? 'api.dart',
      modelsImport: yaml['models_import'] as String?,
      runtimeImport:
          yaml['runtime_import'] as String? ??
          'package:graphql_gen/graphql_gen.dart',
      scalars: _stringMap(yaml['scalars']),
      skipTypes: _stringList(yaml['skip_types']).map(RegExp.new).toList(),
      preserve: _stringList(yaml['preserve']),
      inputDefaultsRequired: yaml['input_defaults_required'] as bool? ?? false,
      classNames: _generatedFileMap(yaml['names']),
      fileNames: _generatedFileMap(yaml['files']),
    );
  }

  static Map<dynamic, dynamic> _map(Object? value) =>
      value is Map ? value : const {};

  static Map<String, String> _stringMap(Object? value) => {
    for (final entry in _map(value).entries) '${entry.key}': '${entry.value}',
  };

  static List<String> _stringList(Object? value) =>
      value is List ? [for (final item in value) '$item'] : const [];

  static Map<GeneratedFile, String> _generatedFileMap(Object? value) {
    final raw = _stringMap(value);
    return {for (final file in GeneratedFile.values) file: ?raw[file.yamlKey]};
  }
}
