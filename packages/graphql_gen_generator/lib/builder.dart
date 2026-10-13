/// build_runner entry point for `graphql_gen_generator`.
library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/enum_fields_generator.dart';

export 'src/enum_fields_generator.dart' show EnumFieldsGenerator;

/// Generates `<file>.fields.g.dart` parts for `@GenerateEnumFields` classes.
Builder enumFieldsBuilder(BuilderOptions options) =>
    PartBuilder([EnumFieldsGenerator()], '.fields.g.dart');
