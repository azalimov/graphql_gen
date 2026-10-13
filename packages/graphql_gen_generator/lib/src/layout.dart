import 'config.dart';
import 'naming.dart';
import 'schema/schema.dart';

/// Paths of generated files, relative to [GraphQLGenConfig.output].
class Layout {
  Layout(this.config);

  final GraphQLGenConfig config;

  String get enumsDir => switch (config.layout) {
    ModelLayout.byKind => 'enums',
    ModelLayout.hotchocolateDto => 'enums',
  };

  /// Directories that hold only generated models; stale ones are removed.
  List<String> get modelRoots => switch (config.layout) {
    ModelLayout.byKind => ['models', 'inputs'],
    ModelLayout.hotchocolateDto => [
      'model/response',
      'model/request',
      'model/shared',
    ],
  };

  String enumFile(GqlEnumType type) =>
      '$enumsDir/${toSnakeCase(type.name)}.dart';

  String modelFile(GqlObjectType type) {
    final file = toSnakeCase(type.name);
    return '${_modelDir(type)}/$file.dart';
  }

  String _modelDir(GqlObjectType type) {
    final name = type.name;
    final snake = toSnakeCase(name);
    switch (config.layout) {
      case ModelLayout.byKind:
        return type.isInput ? 'inputs/$snake' : 'models/$snake';
      case ModelLayout.hotchocolateDto:
        if (name.endsWith('ResponseDto')) return 'model/response/$snake';
        if (name.contains('RequestDtoInput')) {
          final entity = name
              .replaceFirst(RegExp(r'^(Create|Update)'), '')
              .replaceFirst(RegExp(r'RequestDtoInput$'), '');
          return 'model/request/${toSnakeCase(entity)}/$snake';
        }
        if (name.endsWith('Input')) {
          final base = name.replaceFirst(RegExp(r'(Dto)?Input$'), '');
          return 'model/shared/${toSnakeCase(base)}/request';
        }
        final base = name.replaceFirst(RegExp(r'Dto$'), '');
        return 'model/shared/${toSnakeCase(base)}/response';
    }
  }

  String singleFile(GeneratedFile file) => config.fileName(file);
}
