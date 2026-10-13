import 'dart:io';

import 'package:graphql_gen_generator/src/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  final schema = GqlSchema.parse(
    File('test/fixtures/library.graphql').readAsStringSync(),
  );

  test('custom root type names', () {
    expect(schema.query?.name, 'RootQuery');
    expect(schema.mutation?.name, 'RootMutation');
    expect(schema.subscription, isNull);
  });

  test('extensions are merged', () {
    expect(schema.enums['Genre']!.values, ['FICTION', 'NON_FICTION', 'FACT']);
    expect(schema.types['Book']!.fields.last.name, 'pages');
  });

  test('kinds, scalars and unions', () {
    expect(schema.types['Node']!.kind, GqlTypeKind.interface);
    expect(schema.types['BookFilter']!.isInput, isTrue);
    expect(schema.scalars, {'DateTime', 'JSON'});
    expect(schema.unions, {'SearchResult'});
  });

  test('multi-line arguments, defaults and type refs', () {
    final books = schema.query!.fields.first;
    expect(books.name, 'books');
    expect(books.arguments.map((a) => a.name), [
      'filter',
      'filters',
      'first',
      'after',
    ]);
    expect(books.arguments[2].hasDefault, isTrue);
    expect(books.type.toString(), '[Book!]!');

    final matrix = schema.types['Book']!.fields.firstWhere(
      (f) => f.name == 'matrix',
    );
    expect(matrix.type.toString(), '[[Int!]!]');
    expect(matrix.type.baseName, 'Int');
  });

  test('deprecation reasons', () {
    final legacy = schema.types['Book']!.fields.firstWhere(
      (f) => f.name == 'legacyCode',
    );
    expect(legacy.deprecationReason, "Use 'code' instead");
  });
}
