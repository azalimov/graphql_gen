import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:graphql_gen_generator/builder.dart';
import 'package:test/test.dart';

void main() {
  Future<TestBuilderResult> run(String source) async {
    final readerWriter = TestReaderWriter(
      rootPackage: 'a',
      flattenOutput: true,
    );
    await readerWriter.testing.loadIsolateSources();
    return testBuilder(
      enumFieldsBuilder(BuilderOptions.empty),
      {'a|lib/dto.dart': source},
      rootPackage: 'a',
      readerWriter: readerWriter,
      flattenOutput: true,
    );
  }

  Future<String> generate(String source) async {
    final result = await run(source);
    expect(result.succeeded, isTrue);
    final output = AssetId('a', 'lib/dto.fields.g.dart');
    return result.readerWriter.testing.readString(output);
  }

  test('freezed-style factory parameters with nested and list types', () async {
    final output = await generate(r'''
import 'package:graphql_gen/graphql_gen.dart';

part 'dto.fields.g.dart';

@GenerateEnumFields()
class AuthorDto {
  final String? id;
  AuthorDto(this.id);
}

@GenerateEnumFields()
abstract class BookDto {
  factory BookDto({
    String? id,
    AuthorDto? author,
    List<AuthorDto>? coAuthors,
    List<String>? values,
  }) = _BookDto;
}

class _BookDto implements BookDto {
  _BookDto({id, author, coAuthors, values});
}
''');

    expect(output, contains('enum _AuthorDtoFields implements EnumFields {'));
    expect(output, contains('  id(AuthorDtoJsonKeys.id)'));
    expect(output, contains('enum _BookDtoFields implements EnumFields {'));
    expect(
      output,
      contains(
        '  author(BookDtoJsonKeys.author, nestedFields: AuthorDtoFields.values)',
      ),
    );
    expect(
      output,
      contains(
        '  coAuthors(BookDtoJsonKeys.coAuthors, nestedFields: AuthorDtoFields.values)',
      ),
    );
    expect(output, contains('  values_(BookDtoJsonKeys.values)'));
    expect(output, contains('  final String fieldName;'));
    expect(output, contains('  final List<EnumFields>? nestedFields;'));
  });

  test('a class without fields is an error', () async {
    final result = await run('''
import 'package:graphql_gen/graphql_gen.dart';
part 'dto.fields.g.dart';
@GenerateEnumFields()
class Empty {}
''');
    expect(result.succeeded, isFalse);
  });
}
