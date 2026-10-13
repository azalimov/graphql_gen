import 'dart:io';

import 'package:graphql_gen_generator/cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory root;
  final sdl = File('test/fixtures/library.graphql').readAsStringSync();

  GraphQLGenConfig config({Map<String, Object?> extra = const {}}) =>
      GraphQLGenConfig.fromYaml({
        'output': 'lib/api',
        'scalars': {'DateTime': 'DateTime', 'JSON': 'Map<String, dynamic>'},
        ...extra,
      }, packageName: 'library_app');

  SchemaSync sync({
    GraphQLGenConfig? cfg,
    String? schema,
    bool regen = false,
  }) => SchemaSync(
    cfg ?? config(),
    GqlSchema.parse(schema ?? sdl),
    root: root.path,
    regenerate: regen,
  );

  SyncResult run({GraphQLGenConfig? cfg, String? schema, bool regen = false}) {
    final s = sync(cfg: cfg, schema: schema, regen: regen);
    final result = s.plan();
    s.apply(result);
    return result;
  }

  String read(String path) => File(p.join(root.path, path)).readAsStringSync();
  bool exists(String path) => File(p.join(root.path, path)).existsSync();

  setUp(() => root = Directory.systemTemp.createTempSync('graphql_gen_'));
  tearDown(() => root.deleteSync(recursive: true));

  test('first run creates every file, second run is a no-op', () {
    final first = run();
    expect(first.count(ChangeKind.create), greaterThan(10));
    expect(first.count(ChangeKind.update), 0);
    expect(run().changes, isEmpty);
  });

  test('layout and single files', () {
    run();
    for (final path in [
      'lib/api/enums/genre.dart',
      'lib/api/models/book/book.dart',
      'lib/api/models/node/node.dart',
      'lib/api/inputs/book_filter/book_filter.dart',
      'lib/api/api_query_operations.dart',
      'lib/api/api_query_arguments.dart',
      'lib/api/api_mutation_operations.dart',
      'lib/api/api_mutation_arguments.dart',
      'lib/api/api_enum_converters.dart',
      'lib/api/api.dart',
    ]) {
      expect(exists(path), isTrue, reason: path);
    }
    expect(exists('lib/api/models/root_query/root_query.dart'), isFalse);
    expect(exists('lib/api/models/search_result/search_result.dart'), isFalse);
    expect(exists('lib/api/api_subscription_operations.dart'), isFalse);
  });

  test('response model', () {
    run();
    final book = read('lib/api/models/book/book.dart');
    expect(book, contains("import 'package:library_app/api/api.dart';"));
    expect(book, contains("import 'package:graphql_gen/graphql_gen.dart';"));
    expect(book, contains("part 'book.fields.g.dart';"));
    expect(book, contains('@GenerateEnumFields()'));
    expect(book, contains('    String? id,'));
    expect(book, contains('    String? title,'));
    expect(book, contains('    @Default([]) List<Author>? coAuthors,'));
    expect(book, contains('    List<Genre>? genres,'));
    expect(book, contains('    @Default([]) List<String?>? tags,'));
    expect(book, contains('    @Default([]) List<List<int>>? matrix,'));
    expect(book, contains('    Map<String, dynamic>? metadata,'));
    expect(
      book,
      contains("    @JsonKey(name: 'default') String? defaultValue,"),
    );
    expect(
      book,
      contains(r"    @Deprecated('Use \'code\' instead') String? legacyCode,"),
    );
    expect(book, contains('    Map<String, dynamic>? result,'));
    expect(book, contains('    int? pages,'));
    expect(book, contains('typedef BookFields = _BookFields;'));
    expect(book, contains('typedef BookJsonKeys = _\$BookJsonKeys;'));
  });

  test('input model with enum converters and defaults', () {
    run();
    final filter = read('lib/api/inputs/book_filter/book_filter.dart');
    // The barrel import already brings the converters in.
    expect(filter, contains("import 'package:library_app/api/api.dart';"));
    expect(filter, isNot(contains('api_enum_converters.dart')));
    expect(filter, isNot(contains('GenerateEnumFields')));
    expect(
      filter,
      contains('    @JsonKey(toJson: nullableGenreToJson) Genre? genre,'),
    );
    expect(
      filter,
      contains(
        '    @Default([]) @JsonKey(toJson: _bookFilterListOfGenreToJson) '
        'List<Genre>? genres,',
      ),
    );
    expect(
      filter,
      contains(
        '    @JsonKey(toJson: _bookFilterListOfGenreToJson) '
        'required List<Genre> requiredGenres,',
      ),
    );
    // A nullable and a required list share one converter: the nullable one.
    expect(filter, contains('List<Object>? _bookFilterListOfGenreToJson('));
    expect('_bookFilterListOfGenreToJson('.allMatches(filter).length, 1);
    // Non-null with a default is optional by default.
    expect(filter, contains('    int? limit,'));
    expect(filter, contains("    @JsonKey(name: 'new') bool? newItem,"));

    final create = read(
      'lib/api/inputs/create_book_input/create_book_input.dart',
    );
    expect(
      create,
      contains('    @JsonKey(toJson: genreToJson) required Genre genre,'),
    );
    expect(create, contains('    required List<String> authorIds,'));
  });

  test('a custom models_import also imports the converters', () {
    run(
      cfg: config(extra: {'models_import': 'package:library_app/models.dart'}),
    );
    expect(
      read('lib/api/inputs/book_filter/book_filter.dart'),
      contains("import 'package:library_app/api/api_enum_converters.dart';"),
    );
  });

  test('input_defaults_required keeps defaults required', () {
    run(cfg: config(extra: {'input_defaults_required': true}));
    expect(
      read('lib/api/inputs/book_filter/book_filter.dart'),
      contains('    required int limit,'),
    );
  });

  test('argument builders', () {
    run();
    final args = read('lib/api/api_query_arguments.dart');
    expect(args, contains('class ApiQueryArguments {'));
    expect(args, isNot(contains('static GraphQLArgumentBuilder me(')));
    expect(
      args,
      contains('''
  static GraphQLArgumentBuilder books({
    BookFilter? filter,
    List<BookFilter>? filters,
    int? first,
    String? after,
  }) {
    return GraphQLArgumentBuilder()
        .withArgument('filter', filter?.toJson())
        .withArgument('filters', filters?.map((e) => e.toJson()).toList())
        .withArgument('first', first)
        .withArgument('after', after);
  }'''),
    );
    expect(
      read('lib/api/api_mutation_arguments.dart'),
      contains(".withArgument('input', input.toJson());"),
    );
    expect(
      read('lib/api/api_query_operations.dart'),
      contains("  static const String books = 'books';"),
    );
  });

  test('barrel exports every generated file', () {
    run();
    final barrel = read('lib/api/api.dart');
    expect(barrel, contains("export 'enums/genre.dart';"));
    expect(barrel, contains("export 'models/book/book.dart';"));
    expect(barrel, contains("export 'api_query_arguments.dart';"));
    expect(barrel, isNot(contains("export 'api.dart';")));
  });

  test(
    'a new field rewrites the model; hand edits with same fields survive',
    () {
      run();
      final authorPath = 'lib/api/models/author/author.dart';
      final edited = '${read(authorPath)}\n// hand edit\n';
      File(p.join(root.path, authorPath)).writeAsStringSync(edited);

      expect(run().changes, isEmpty);
      expect(read(authorPath), edited);

      final changed = run(
        schema: sdl.replaceFirst(
          '  born: DateTime',
          '  born: DateTime\n  bio: String',
        ),
      );
      expect(changed.changes.single.path, authorPath);
      expect(read(authorPath), contains('String? bio,'));
      expect(read(authorPath), isNot(contains('hand edit')));
    },
  );

  test('removed types are deleted with their generated parts', () {
    run();
    final dir = p.join(root.path, 'lib/api/models/author');
    File(p.join(dir, 'author.g.dart')).writeAsStringSync('// generated');
    File(p.join(dir, 'author.freezed.dart')).writeAsStringSync('// generated');

    final schema = sdl
        .replaceFirst(RegExp(r'type Author implements Node \{[^}]*\}'), '')
        .replaceAll('Author', 'Book');
    final result = run(schema: schema);

    expect(result.count(ChangeKind.delete), 3);
    expect(Directory(dir).existsSync(), isFalse);
  });

  test('regenerate deletes unknown enums except preserved ones', () {
    run();
    File(
      p.join(root.path, 'lib/api/enums/old_enum.dart'),
    ).writeAsStringSync('enum OldEnum { a }');
    File(
      p.join(root.path, 'lib/api/enums/kept_enum.dart'),
    ).writeAsStringSync('enum KeptEnum { a }');

    expect(run().changes, isEmpty, reason: 'plain sync leaves unknown enums');

    final result = run(
      regen: true,
      cfg: config(
        extra: {
          'preserve': ['enums/kept_*'],
        },
      ),
    );
    expect(result.changes.map((c) => c.path), ['lib/api/enums/old_enum.dart']);
    expect(exists('lib/api/enums/kept_enum.dart'), isTrue);
  });

  test('changed enum values rewrite the enum file', () {
    run();
    final result = run(
      schema: sdl.replaceFirst('  FACT\n', '  FACT\n  POETRY\n'),
    );
    expect(
      result.changes.map((c) => c.path),
      containsAll(['lib/api/enums/genre.dart']),
    );
    expect(read('lib/api/enums/genre.dart'), contains('POETRY'));
  });

  test('only SCREAMING_CASE enums ignore constant_identifier_names', () {
    run(
      schema:
          '${sdl}\nenum SortOrder { asc desc }\n'
          'type Sorted { order: SortOrder }\n',
    );
    expect(
      read('lib/api/enums/genre.dart'),
      startsWith(
        '// ignore_for_file: constant_identifier_names\n\nenum Genre {',
      ),
    );
    expect(
      read('lib/api/enums/sort_order.dart'),
      startsWith('enum SortOrder {'),
    );
  });

  test('unmapped custom scalars become Object with a warning', () {
    final result = run(
      cfg: config(
        extra: {
          'scalars': {'DateTime': 'DateTime'},
        },
      ),
    );
    expect(result.warnings.single, contains('JSON'));
    expect(
      read('lib/api/models/book/book.dart'),
      contains('Object? metadata,'),
    );
  });

  test('hotchocolate_dto layout', () {
    const schema = '''
type Query { order(id: String!): OrderResponseDto }
type OrderResponseDto { id: String address: AddressDto }
type AddressDto { city: String }
input CreateOrderRequestDtoInput { note: String }
input AddressDtoInput { city: String }
''';
    run(
      cfg: config(extra: {'layout': 'hotchocolate_dto'}),
      schema: schema,
    );
    expect(
      exists(
        'lib/api/model/response/order_response_dto/order_response_dto.dart',
      ),
      isTrue,
    );
    expect(
      exists('lib/api/model/shared/address/response/address_dto.dart'),
      isTrue,
    );
    expect(
      exists(
        'lib/api/model/request/order/create_order_request_dto_input/'
        'create_order_request_dto_input.dart',
      ),
      isTrue,
    );
    expect(
      exists('lib/api/model/shared/address/request/address_dto_input.dart'),
      isTrue,
    );
  });

  test('parseFactoryFields', () {
    expect(
      parseFactoryFields('''
  const factory X({
    @Deprecated('a (b)') String? a,
    @Default([]) @JsonKey(toJson: f) List<Genre>? b,
    required Map<String, dynamic> c,
  }) = _X;
'''),
      {'a': 'String?', 'b': 'List<Genre>?', 'c': 'Map<String,dynamic>'},
    );
  });
}
