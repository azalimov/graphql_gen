import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:graphql_gen_generator/cli.dart';
import 'package:http/http.dart' show ClientException;

Future<void> main(List<String> args) async {
  try {
    exitCode = await GraphQLGenCommandRunner().run(args) ?? 0;
  } on UsageException catch (e) {
    stderr.writeln(e);
    exitCode = 64;
  } on StateError catch (e) {
    stderr.writeln('error: ${e.message}');
    exitCode = 1;
  } on ClientException catch (e) {
    // Unreachable host, refused connection, TLS failure, ...
    stderr.writeln(
      'error: could not fetch the schema from ${e.uri}: ${e.message}',
    );
    exitCode = 1;
  } on FileSystemException catch (e) {
    stderr.writeln('error: ${e.message}: ${e.path}');
    exitCode = 1;
  }
}
