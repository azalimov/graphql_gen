import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:graphql_gen_generator/cli.dart';

Future<void> main(List<String> args) async {
  try {
    exitCode = await GraphQLGenCommandRunner().run(args) ?? 0;
  } on UsageException catch (e) {
    stderr.writeln(e);
    exitCode = 64;
  } on StateError catch (e) {
    stderr.writeln('error: ${e.message}');
    exitCode = 1;
  }
}
