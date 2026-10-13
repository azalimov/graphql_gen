import 'package:graphql_gen_example/api/api.dart';

/// Utility functions for converting Dart enums to GraphQL-compatible formats.
///
/// GraphQL expects enum values to be sent without the enum type name,
/// so we need to convert Dart's `EnumName.VALUE` to just `VALUE`.

// Required enum converters (for non-nullable fields)

// Nullable enum converters (for nullable fields)

/// Specific converter for Genre (required)
Object genreToJson(Genre value) => value;

/// Specific converter for Genre (nullable)
Object? nullableGenreToJson(Genre? value) => value;

