import 'package:graphql_gen/graphql_gen.dart';
import 'package:test/test.dart';

enum AuthorFields implements EnumFields {
  id('id'),
  name('name');

  const AuthorFields(this.fieldName);

  @override
  final String fieldName;

  @override
  List<EnumFields>? get nestedFields => null;
}

enum BookFields implements EnumFields {
  id('id'),
  title('title'),
  author('author', nestedFields: AuthorFields.values);

  const BookFields(this.fieldName, {this.nestedFields});

  @override
  final String fieldName;

  @override
  final List<EnumFields>? nestedFields;
}

void main() {
  test('flat fields', () {
    expect(GraphQLFieldBuilder().withFields(['id', 'name']).build(), 'id name');
  });

  test('nested builder', () {
    final fields = GraphQLFieldBuilder()
        .withField('id')
        .withField(
          'author',
          nestedField: GraphQLFieldBuilder().withField('name'),
        );
    expect(fields.build(), 'id author { name }');
  });

  test('empty nested builder is written as a plain field', () {
    final fields = GraphQLFieldBuilder().withField(
      'id',
      nestedField: GraphQLFieldBuilder(),
    );
    expect(fields.build(), 'id');
  });

  test('enum fields select nested enums recursively', () {
    expect(
      GraphQLFieldBuilder().withEnumFields(BookFields.values).build(),
      'id title author { id name }',
    );
  });

  test('enum fields can be mixed with a narrower nested selection', () {
    final fields = GraphQLFieldBuilder()
        .withEnumFields([BookFields.id])
        .withField(
          BookFields.author.fieldName,
          nestedField: GraphQLFieldBuilder().withEnumFields([
            AuthorFields.name,
          ]),
        );
    expect(fields.build(), 'id author { name }');
  });
}
