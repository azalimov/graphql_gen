import 'package:graphql_gen/graphql_gen.dart';
import 'package:graphql_gen_example/api/api.dart';
import 'package:test/test.dart';

void main() {
  test('builds a query from generated field enums and arguments', () {
    final query = GraphQLQueryBuilder(name: 'Books')
        .withOperation(
          operationName: ApiQueryOperations.books,
          arguments: ApiQueryArguments.books(
            filter: const BookFilter(
              genre: Genre.FICTION,
              genres: [Genre.FACT],
              requiredGenres: [Genre.FICTION],
            ),
            first: 5,
          ),
          fields: Book.query(include: [BookFields.id, BookFields.title])
              .withField(
                BookFields.author.fieldName,
                nestedField: Author.query(include: [AuthorFields.name]),
              ),
        )
        .build();

    expect(query, startsWith('query Books {'));
    expect(
      query,
      contains(
        'books(filter: { genre: FICTION, genres: [FACT], '
        'requiredGenres: [FICTION], title: null, limit: null, new: null }, '
        'first: 5)',
      ),
    );
    expect(query, contains('id title author { name }'));
  });

  test('nested enum fields select everything below', () {
    final fields = Book.query(include: [BookFields.coAuthors]).build();
    expect(fields, 'coAuthors { id name born }');
  });

  test('parses a response into Freezed models', () {
    final book = Book.fromJson({
      'id': '1',
      'title': 'Dune',
      'genres': ['FICTION'],
      'author': {'id': '2', 'name': 'Frank', 'born': '1920-10-08T00:00:00Z'},
      'default': 'x',
    });

    expect(book.title, 'Dune');
    expect(book.genres, [Genre.FICTION]);
    expect(book.author?.born, DateTime.utc(1920, 10, 8));
    expect(book.defaultValue, 'x');
    expect(book.coAuthors, isEmpty);
  });

  test('input toJson keeps enums as Dart enums for unquoted output', () {
    final json = const CreateBookInput(
      title: 'Dune',
      genre: Genre.FICTION,
      authorIds: ['2'],
    ).toJson();

    expect(json['genre'], Genre.FICTION);
    expect(
      formatGraphQLValue(json),
      '{ title: "Dune", genre: FICTION, authorIds: ["2"], filter: null }',
    );
  });
}
