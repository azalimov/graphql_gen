import 'dart:io';

import 'package:path/path.dart' as p;

import '../codegen/model_template.dart';
import '../codegen/single_file_templates.dart';
import '../codegen/type_mapper.dart';
import '../config.dart';
import '../layout.dart';
import '../schema/schema.dart';

/// What [SchemaSync] does with a file.
enum ChangeKind { create, update, delete }

/// One planned file change, with [path] relative to the package root.
class FileChange {
  FileChange(this.kind, this.path, {this.content, this.reason});

  final ChangeKind kind;
  final String path;
  final String? content;
  final String? reason;

  @override
  String toString() {
    final symbol = switch (kind) {
      ChangeKind.create => '+',
      ChangeKind.update => '~',
      ChangeKind.delete => '-',
    };
    return '$symbol $path${reason == null ? '' : ' ($reason)'}';
  }
}

class SyncResult {
  SyncResult(this.changes, this.warnings);

  final List<FileChange> changes;
  final List<String> warnings;

  int count(ChangeKind kind) => changes.where((c) => c.kind == kind).length;
}

/// Compares the schema with the generated files under
/// [GraphQLGenConfig.output] and plans the changes that bring them in line.
///
/// Without [regenerate], an existing model is rewritten only when its
/// constructor parameters differ from the schema, so hand edits that keep
/// the same fields survive, and enum files are rewritten only when their
/// values change. With [regenerate], every generated file is rewritten and
/// everything else under the managed directories is deleted, except paths
/// matching `preserve`.
class SchemaSync {
  SchemaSync(
    this.config,
    this.schema, {
    this.root = '.',
    this.regenerate = false,
  }) : layout = Layout(config),
       types = TypeMapper(schema, config) {
    models = ModelTemplate(
      config,
      types,
      convertersImport: config.packageImport(
        p.join(config.output, config.fileName(GeneratedFile.enumConverters)),
      ),
    );
    singles = SingleFileTemplates(config, schema, types);
  }

  final GraphQLGenConfig config;
  final GqlSchema schema;
  final String root;
  final bool regenerate;
  final Layout layout;
  final TypeMapper types;
  late final ModelTemplate models;
  late final SingleFileTemplates singles;

  final List<String> _warnings = [];

  String _abs(String relative) => p.join(root, config.output, relative);

  String _pkgPath(String relative) => p.join(config.output, relative);

  /// Computes the changes without touching the file system.
  SyncResult plan() {
    final changes = <FileChange>[];
    final expected = <String>{};

    void put(
      String relative,
      String content, {
      bool Function(String)? isCurrent,
    }) {
      expected.add(relative);
      final file = File(_abs(relative));
      if (!file.existsSync()) {
        changes.add(
          FileChange(ChangeKind.create, _pkgPath(relative), content: content),
        );
        return;
      }
      final existing = file.readAsStringSync();
      if (existing == content) return;
      if (!regenerate && isCurrent != null && isCurrent(existing)) return;
      changes.add(
        FileChange(ChangeKind.update, _pkgPath(relative), content: content),
      );
    }

    for (final type in schema.enums.values) {
      if (config.isSkipped(type.name)) continue;
      put(
        layout.enumFile(type),
        singles.enumFile(type),
        isCurrent: (existing) => _sameEnumValues(existing, type),
      );
    }

    for (final type in schema.types.values) {
      if (schema.rootTypes.contains(type.name) || config.isSkipped(type.name)) {
        continue;
      }
      if (type.fields.isEmpty) {
        _warnings.add('${type.name} has no fields; skipped.');
        continue;
      }
      put(
        layout.modelFile(type),
        models.render(type),
        isCurrent: (existing) => _sameModelFields(existing, type),
      );
    }

    final singleFiles = <GeneratedFile, String?>{
      GeneratedFile.enumConverters: schema.enums.isEmpty
          ? null
          : singles.enumConverters(),
      GeneratedFile.queryOperations: singles.operations(
        schema.query,
        GeneratedFile.queryOperations,
        'Query',
      ),
      GeneratedFile.mutationOperations: singles.operations(
        schema.mutation,
        GeneratedFile.mutationOperations,
        'Mutation',
      ),
      GeneratedFile.subscriptionOperations: singles.operations(
        schema.subscription,
        GeneratedFile.subscriptionOperations,
        'Subscription',
      ),
      GeneratedFile.queryArguments: singles.arguments(
        schema.query,
        GeneratedFile.queryArguments,
        'Query',
      ),
      GeneratedFile.mutationArguments: singles.arguments(
        schema.mutation,
        GeneratedFile.mutationArguments,
        'Mutation',
      ),
      GeneratedFile.subscriptionArguments: singles.arguments(
        schema.subscription,
        GeneratedFile.subscriptionArguments,
        'Subscription',
      ),
    };
    for (final MapEntry(key: file, value: content) in singleFiles.entries) {
      if (content != null) put(layout.singleFile(file), content);
    }

    if (config.barrel case final barrel?) {
      put(barrel, singles.barrel(expected));
    }

    changes.addAll(_staleFiles(expected));

    if (types.unmappedScalars.isNotEmpty) {
      _warnings.add(
        'No Dart type for scalar(s) ${types.unmappedScalars.join(', ')}; '
        'generated as Object. Map them under `scalars:`.',
      );
    }
    return SyncResult(changes, _warnings);
  }

  /// Writes [result] to disk.
  void apply(SyncResult result) {
    for (final change in result.changes) {
      final file = File(p.join(root, change.path));
      switch (change.kind) {
        case ChangeKind.create || ChangeKind.update:
          file.parent.createSync(recursive: true);
          file.writeAsStringSync(change.content!);
        case ChangeKind.delete:
          if (file.existsSync()) file.deleteSync();
      }
    }
    for (final dir in [...layout.modelRoots, layout.enumsDir]) {
      _deleteEmptyDirs(Directory(_abs(dir)));
    }
  }

  /// Files under the managed directories that the schema no longer
  /// produces. A stale model takes its generated parts with it.
  List<FileChange> _staleFiles(Set<String> expected) {
    final stale = <FileChange>[];
    final outputDir = _abs('');

    for (final dir in layout.modelRoots) {
      final directory = Directory(_abs(dir));
      if (!directory.existsSync()) continue;
      final files =
          directory
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .map((f) => p.relative(f.path, from: outputDir))
              .toList()
            ..sort();
      final primaries = files.where((f) => !_isGeneratedPart(f)).toSet();
      final stalePrimaries = primaries
          .where((f) => !expected.contains(f) && !config.isPreserved(f))
          .toSet();

      for (final file in files) {
        if (config.isPreserved(file)) continue;
        final owner = _isGeneratedPart(file) ? _ownerOf(file) : file;
        final ownerIsStale =
            stalePrimaries.contains(owner) ||
            (!primaries.contains(owner) && !expected.contains(owner));
        if (ownerIsStale) {
          stale.add(
            FileChange(
              ChangeKind.delete,
              _pkgPath(file),
              reason: 'not in schema',
            ),
          );
        }
      }
    }

    if (regenerate) {
      final enums = Directory(_abs(layout.enumsDir));
      if (enums.existsSync()) {
        for (final file in enums.listSync().whereType<File>()) {
          final relative = p.relative(file.path, from: outputDir);
          if (!relative.endsWith('.dart') ||
              expected.contains(relative) ||
              config.isPreserved(relative)) {
            continue;
          }
          stale.add(
            FileChange(
              ChangeKind.delete,
              _pkgPath(relative),
              reason: 'not in schema',
            ),
          );
        }
      }
    }
    return stale;
  }

  static final _partSuffix = RegExp(
    r'\.(freezed|g|fields\.g|[a-z_]+\.g)\.dart$',
  );

  bool _isGeneratedPart(String path) => _partSuffix.hasMatch(path);

  String _ownerOf(String part) => part.replaceFirst(_partSuffix, '.dart');

  void _deleteEmptyDirs(Directory dir) {
    if (!dir.existsSync()) return;
    for (final child in dir.listSync().whereType<Directory>()) {
      _deleteEmptyDirs(child);
      if (child.existsSync() && child.listSync().isEmpty) child.deleteSync();
    }
  }

  bool _sameEnumValues(String existing, GqlEnumType type) {
    final match = RegExp(
      'enum\\s+${RegExp.escape(type.name)}\\s*\\{([^}]+)\\}',
    ).firstMatch(existing);
    if (match == null) return false;
    final values = match[1]!
        .split(';')
        .first
        .split(',')
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    return _listEquals(values, type.values);
  }

  bool _sameModelFields(String existing, GqlObjectType type) {
    final actual = parseFactoryFields(existing);
    if (actual == null) return false;
    final expected = {
      for (final field in models.fields(type))
        field.dartName: field.dartType.replaceAll(' ', ''),
    };
    if (actual.length != expected.length) return false;
    return expected.entries.every((e) => actual[e.key] == e.value);
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Parameter name to type (nullable marker kept, `required` dropped) of the
/// first `const factory X({...})` in [source], or `null` if there is none.
Map<String, String>? parseFactoryFields(String source) {
  final match = RegExp(
    r'const\s+factory\s+\w+\s*\(\s*\{(.*?)\}\s*\)\s*=',
    dotAll: true,
  ).firstMatch(source);
  if (match == null) return null;

  final fields = <String, String>{};
  for (var line in match[1]!.split('\n')) {
    line = line
        .trim()
        .replaceAll(RegExp(r"@\w+(\((?:[^()']|'[^']*'|\([^()]*\))*\))?\s*"), '')
        .replaceAll(RegExp(r'\brequired\s+'), '')
        .trim();
    final field = RegExp(r'^(.+?)\s+(\w+),?$').firstMatch(line);
    if (field != null) fields[field[2]!] = field[1]!.replaceAll(' ', '');
  }
  return fields;
}
