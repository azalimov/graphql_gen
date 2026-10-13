import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graphql_gen_example/api/api.dart';
import 'package:graphql_gen_example/api/api_enum_converters.dart';

part 'book_filter.freezed.dart';
part 'book_filter.g.dart';

@freezed
abstract class BookFilter with _$BookFilter {
  const factory BookFilter({
    @JsonKey(toJson: nullableGenreToJson) Genre? genre,
    @Default([]) @JsonKey(toJson: _bookFilterListOfGenreToJson) List<Genre>? genres,
    @JsonKey(toJson: _bookFilterListOfGenreToJson) required List<Genre> requiredGenres,
    String? title,
    int? limit,
    @JsonKey(name: 'new') bool? newItem,
  }) = _BookFilter;

  factory BookFilter.fromJson(Map<String, dynamic> json) => _$BookFilterFromJson(json);
}

List<Object>? _bookFilterListOfGenreToJson(List<Genre>? list) =>
    list?.map((e) => genreToJson(e)).toList();


typedef BookFilterJsonKeys = _$BookFilterJsonKeys;

