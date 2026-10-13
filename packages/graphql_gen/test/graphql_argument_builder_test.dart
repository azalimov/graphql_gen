import 'package:graphql_gen/graphql_gen.dart';
import 'package:test/test.dart';

enum Status { active, archived }

void main() {
  group('GraphQLArgumentBuilder', () {
    test('skips null arguments', () {
      final args = GraphQLArgumentBuilder()
          .withArgument('id', 1)
          .withArgument('name', null);
      expect(args.build(), 'id: 1');
    });

    test('replaces an argument added twice', () {
      final args = GraphQLArgumentBuilder()
          .withArgument('id', 1)
          .withArgument('id', 2);
      expect(args.build(), 'id: 2');
    });

    test('isEmpty ignores null values', () {
      expect(GraphQLArgumentBuilder().withArgument('a', null).isEmpty, isTrue);
      expect(GraphQLArgumentBuilder().withArgument('a', 0).isEmpty, isFalse);
    });
  });

  group('formatGraphQLValue', () {
    test('scalars', () {
      expect(formatGraphQLValue(42), '42');
      expect(formatGraphQLValue(1.5), '1.5');
      expect(formatGraphQLValue(true), 'true');
      expect(formatGraphQLValue(null), 'null');
    });

    test('enums are unquoted', () {
      expect(formatGraphQLValue(Status.active), 'active');
      expect(formatGraphQLValue(const GraphQLEnumValue('ACTIVE')), 'ACTIVE');
    });

    test('DateTime is a UTC ISO-8601 string', () {
      final date = DateTime.utc(2026, 1, 2, 3, 4, 5);
      expect(formatGraphQLValue(date), '"2026-01-02T03:04:05.000Z"');
    });

    test('strings escape quotes, backslashes and control characters', () {
      expect(formatGraphQLValue('plain'), '"plain"');
      expect(formatGraphQLValue('say "hi"'), r'"say \"hi\""');
      expect(formatGraphQLValue(r'C:\path'), r'"C:\\path"');
      expect(formatGraphQLValue('a\nb\r\tc'), r'"a\nb\r\tc"');
      expect(formatGraphQLValue('\u0001'), r'"\u0001"');
      expect(formatGraphQLValue('emoji 🎉'), '"emoji 🎉"');
    });

    test('lists and nested maps', () {
      expect(
        formatGraphQLValue([1, 'two', Status.archived]),
        '[1, "two", archived]',
      );
      expect(
        formatGraphQLValue({
          'name': 'x',
          'tags': ['a'],
          'nested': {'n': 1},
        }),
        '{ name: "x", tags: ["a"], nested: { n: 1 } }',
      );
      expect(formatGraphQLValue(<String, String>{'k': 'v'}), '{ k: "v" }');
    });

    test('unsupported types throw', () {
      expect(() => formatGraphQLValue(Object()), throwsArgumentError);
    });
  });
}
