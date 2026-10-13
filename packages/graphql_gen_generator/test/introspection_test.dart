import 'package:graphql_gen_generator/cli.dart';
import 'package:test/test.dart';

Map<String, dynamic> named(String kind, String name) => {
  'kind': kind,
  'name': name,
  'ofType': null,
};

Map<String, dynamic> nonNull(Map<String, dynamic> of) => {
  'kind': 'NON_NULL',
  'name': null,
  'ofType': of,
};

Map<String, dynamic> list(Map<String, dynamic> of) => {
  'kind': 'LIST',
  'name': null,
  'ofType': of,
};

void main() {
  test('converts introspection JSON to SDL the parser accepts', () {
    final sdl = introspectionToSdl({
      'data': {
        '__schema': {
          'queryType': {'name': 'Query'},
          'mutationType': null,
          'subscriptionType': null,
          'types': [
            {
              'kind': 'OBJECT',
              'name': 'Query',
              'interfaces': <Object>[],
              'fields': [
                {
                  'name': 'books',
                  'args': [
                    {
                      'name': 'first',
                      'type': named('SCALAR', 'Int'),
                      'defaultValue': '10',
                    },
                  ],
                  'type': nonNull(list(nonNull(named('OBJECT', 'Book')))),
                  'isDeprecated': false,
                  'deprecationReason': null,
                },
              ],
            },
            {
              'kind': 'OBJECT',
              'name': 'Book',
              'interfaces': <Object>[],
              'fields': [
                {
                  'name': 'old',
                  'args': <Object>[],
                  'type': named('SCALAR', 'String'),
                  'isDeprecated': true,
                  'deprecationReason': 'Use "new"',
                },
                {
                  'name': 'genre',
                  'args': <Object>[],
                  'type': named('ENUM', 'Genre'),
                  'isDeprecated': false,
                  'deprecationReason': null,
                },
              ],
            },
            {
              'kind': 'ENUM',
              'name': 'Genre',
              'enumValues': [
                {'name': 'FICTION'},
              ],
            },
            {'kind': 'SCALAR', 'name': 'String'},
            {'kind': 'SCALAR', 'name': 'DateTime'},
            {'kind': 'OBJECT', 'name': '__Type', 'fields': <Object>[]},
          ],
        },
      },
    });

    final schema = GqlSchema.parse(sdl);
    expect(schema.query!.fields.single.type.toString(), '[Book!]!');
    expect(schema.query!.fields.single.arguments.single.hasDefault, isTrue);
    expect(schema.types['Book']!.fields.first.deprecationReason, 'Use "new"');
    expect(schema.enums['Genre']!.values, ['FICTION']);
    expect(schema.scalars, {'DateTime'});
    expect(schema.types.containsKey('__Type'), isFalse);
  });

  test('expandEnvironment', () {
    expect(expandEnvironment(r'Bearer ${T}', {'T': 'abc'}), 'Bearer abc');
    expect(() => expandEnvironment(r'${MISSING}', {}), throwsStateError);
  });
}
