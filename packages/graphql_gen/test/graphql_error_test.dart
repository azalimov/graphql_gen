import 'package:graphql_gen/graphql_gen.dart';
import 'package:test/test.dart';

void main() {
  test('parses a GraphQL error response', () {
    final response = GraphQLErrorResponse.fromJson({
      'errors': [
        {
          'message': 'Not found',
          'locations': [
            {'line': 1, 'column': 3},
          ],
          'path': ['user', 0],
          'extensions': {'code': 'NOT_FOUND', 'statusCode': 404},
        },
      ],
      'data': null,
    });

    expect(response.hasErrors, isTrue);
    expect(response.firstErrorMessage, 'Not found');
    expect(response.firstErrorCode, 'NOT_FOUND');
    expect(response.errors.single.path, ['user', '0']);
    expect(response.errors.single.extensions?.statusCode, '404');
    expect(response.errors.single.locations?.single.column, 3);
  });

  test('missing errors gives an empty list', () {
    expect(GraphQLErrorResponse.fromJson({'data': {}}).hasErrors, isFalse);
  });
}
