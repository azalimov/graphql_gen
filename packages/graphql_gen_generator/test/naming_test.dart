import 'package:graphql_gen_generator/src/naming.dart';
import 'package:test/test.dart';

void main() {
  test('toSnakeCase', () {
    expect(toSnakeCase('BookDto'), 'book_dto');
    expect(toSnakeCase('HTMLParser'), 'html_parser');
    expect(toSnakeCase('Int32Value'), 'int32_value');
    expect(toSnakeCase('KeyValuePairOfAAndB'), 'key_value_pair_of_a_and_b');
    expect(toSnakeCase('already_snake'), 'already_snake');
  });

  test('safeFieldName renames reserved words', () {
    expect(safeFieldName('default'), 'defaultValue');
    expect(safeFieldName('new'), 'newItem');
    expect(safeFieldName('is'), 'isValue');
    expect(safeFieldName('title'), 'title');
  });

  test('escapeDartString', () {
    expect(escapeDartString(r"it's $x"), r"it\'s \$x");
  });
}
