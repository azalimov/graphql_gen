import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen_example/api/api.dart';
import 'package:graphql_gen_example/api/api_enum_converters.dart';

part 'create_book_input.freezed.dart';
part 'create_book_input.g.dart';

@freezed
abstract class CreateBookInput with _$CreateBookInput {
  const factory CreateBookInput({
    required String title,
    @JsonKey(toJson: genreToJson) required Genre genre,
    required List<String> authorIds,
    BookFilter? filter,
  }) = _CreateBookInput;

  factory CreateBookInput.fromJson(Map<String, dynamic> json) => _$CreateBookInputFromJson(json);
}

typedef CreateBookInputJsonKeys = _$CreateBookInputJsonKeys;

