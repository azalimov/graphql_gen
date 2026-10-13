import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'introspection.dart';

/// Downloads the schema described by [source] and returns it as SDL.
Future<String> fetchSchema(
  SchemaSource source, {
  http.Client? client,
  Map<String, String>? environment,
}) async {
  final url = source.url;
  if (url == null) {
    throw StateError('Set `schema.url` in graphql_gen.yaml to use fetch.');
  }
  final env = environment ?? Platform.environment;
  final headers = {
    for (final MapEntry(:key, :value) in source.headers.entries)
      key: expandEnvironment(value, env),
  };
  final httpClient = client ?? http.Client();
  try {
    final http.Response response;
    if (source.introspection) {
      response = await httpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', ...headers},
        body: jsonEncode({'query': introspectionQuery}),
      );
    } else {
      response = await httpClient.get(Uri.parse(url), headers: headers);
    }
    if (response.statusCode != 200) {
      throw HttpException(
        'Schema request failed with ${response.statusCode}: '
        '${response.body.length > 300 ? response.body.substring(0, 300) : response.body}',
        uri: Uri.parse(url),
      );
    }
    if (!source.introspection) return response.body;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['errors'] case final List<dynamic> errors when errors.isNotEmpty) {
      throw StateError('Introspection failed: ${jsonEncode(errors)}');
    }
    return introspectionToSdl(json);
  } finally {
    if (client == null) httpClient.close();
  }
}

/// Replaces `${NAME}` with the value of the environment variable `NAME`.
String expandEnvironment(String value, Map<String, String> environment) =>
    value.replaceAllMapped(RegExp(r'\$\{(\w+)\}'), (match) {
      final name = match[1]!;
      final resolved = environment[name];
      if (resolved == null) {
        throw StateError('Environment variable $name is not set.');
      }
      return resolved;
    });
