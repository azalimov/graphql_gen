/// Command-line interface of `graphql_gen_generator`.
library;

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import 'src/config.dart';
import 'src/schema/fetch.dart';
import 'src/schema/schema.dart';
import 'src/sync/schema_sync.dart';

export 'src/config.dart';
export 'src/schema/fetch.dart' show expandEnvironment, fetchSchema;
export 'src/schema/introspection.dart' show introspectionToSdl;
export 'src/schema/schema.dart' show GqlSchema;
export 'src/sync/schema_sync.dart'
    show ChangeKind, FileChange, SchemaSync, SyncResult, parseFactoryFields;

/// The `graphql_gen_generator` command line: `init`, `fetch` and `sync`.
///
/// `run` returns the process exit code.
class GraphQLGenCommandRunner extends CommandRunner<int> {
  GraphQLGenCommandRunner()
    : super(
        'graphql_gen_generator',
        'Generates Freezed models, field enums and typed argument builders '
            'from a GraphQL schema.',
      ) {
    argParser.addOption(
      'config',
      abbr: 'c',
      defaultsTo: GraphQLGenConfig.defaultPath,
      help: 'Path to the config file.',
    );
    addCommand(_InitCommand());
    addCommand(_FetchCommand());
    addCommand(_SyncCommand());
  }
}

String _configPath(Command<int> command) =>
    command.globalResults!.option('config')!;

class _InitCommand extends Command<int> {
  @override
  String get name => 'init';

  @override
  String get description => 'Creates a starter graphql_gen.yaml.';

  @override
  int run() {
    final file = File(_configPath(this));
    if (file.existsSync()) {
      stderr.writeln('${file.path} already exists.');
      return 1;
    }
    file.writeAsStringSync(_starterConfig);
    stdout.writeln('Created ${file.path}.');
    return 0;
  }
}

class _FetchCommand extends Command<int> {
  @override
  String get name => 'fetch';

  @override
  String get description =>
      'Downloads the schema from schema.url into schema.file.';

  @override
  Future<int> run() async {
    final config = GraphQLGenConfig.load(configPath: _configPath(this));
    final sdl = await fetchSchema(config.schema);
    GqlSchema.parse(sdl, url: config.schema.url);
    File(config.schema.file).writeAsStringSync(sdl);
    stdout.writeln('Wrote ${config.schema.file}.');
    return 0;
  }
}

class _SyncCommand extends Command<int> {
  _SyncCommand() {
    argParser
      ..addFlag('fetch', help: 'Run fetch first.', negatable: false)
      ..addFlag(
        'regenerate',
        help:
            'Rewrite every generated file and delete files the schema no '
            'longer produces, including enums.',
        negatable: false,
      )
      ..addFlag(
        'dry-run',
        help: 'Print the changes without writing them.',
        negatable: false,
      );
  }

  @override
  String get name => 'sync';

  @override
  String get description => 'Brings generated sources in line with the schema.';

  @override
  Future<int> run() async {
    final config = GraphQLGenConfig.load(configPath: _configPath(this));
    final results = argResults!;

    if (results.flag('fetch')) {
      final sdl = await fetchSchema(config.schema);
      File(config.schema.file).writeAsStringSync(sdl);
      stdout.writeln('Fetched ${config.schema.file}.');
    }

    final schemaFile = File(config.schema.file);
    if (!schemaFile.existsSync()) {
      throw StateError('${config.schema.file} not found. Run `fetch` first.');
    }
    final schema = GqlSchema.parse(
      schemaFile.readAsStringSync(),
      url: p.absolute(schemaFile.path),
    );
    final sync = SchemaSync(
      config,
      schema,
      regenerate: results.flag('regenerate'),
    );
    final result = sync.plan();

    for (final warning in result.warnings) {
      stderr.writeln('warning: $warning');
    }
    for (final change in result.changes) {
      stdout.writeln(change);
    }

    final summary =
        '${result.count(ChangeKind.create)} created, '
        '${result.count(ChangeKind.update)} updated, '
        '${result.count(ChangeKind.delete)} deleted';
    if (results.flag('dry-run')) {
      stdout.writeln('Dry run: $summary.');
      return 0;
    }
    sync.apply(result);
    stdout.writeln(result.changes.isEmpty ? 'Up to date.' : 'Done: $summary.');
    if (result.changes.isNotEmpty) {
      stdout.writeln('Next: dart run build_runner build');
    }
    return 0;
  }
}

const _starterConfig = '''
# graphql_gen configuration. See https://pub.dev/packages/graphql_gen_generator

schema:
  file: schema.graphql
  # url: https://api.example.com/graphql
  # introspection: true          # POST an introspection query instead of GET SDL
  # headers:
  #   Authorization: Bearer \${API_TOKEN}

output: lib/api                  # every generated file goes here
barrel: api.dart                 # exports all generated files
class_prefix: Api                # ApiQueryOperations, ApiQueryArguments, ...

scalars:                         # custom scalar -> Dart type
  DateTime: DateTime
  # JSON: Map<String, dynamic>

# skip_types: ['^Paginated.*']   # regular expressions
''';
