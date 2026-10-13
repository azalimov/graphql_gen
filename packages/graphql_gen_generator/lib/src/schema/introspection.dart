import 'dart:convert';

/// Standard introspection query, without descriptions.
const introspectionQuery = '''
query IntrospectionQuery {
  __schema {
    queryType { name }
    mutationType { name }
    subscriptionType { name }
    types {
      kind name
      fields(includeDeprecated: true) {
        name
        args { name type { ...TypeRef } defaultValue }
        type { ...TypeRef }
        isDeprecated deprecationReason
      }
      inputFields { name type { ...TypeRef } defaultValue }
      interfaces { ...TypeRef }
      enumValues(includeDeprecated: true) { name }
      possibleTypes { ...TypeRef }
    }
  }
}

fragment TypeRef on __Type {
  kind name
  ofType { kind name ofType { kind name ofType { kind name ofType { kind name
    ofType { kind name ofType { kind name ofType { kind name } } } } } } }
}
''';

const _builtInScalars = {'String', 'Int', 'Float', 'Boolean', 'ID'};

/// Converts an introspection result (the `data` object or the whole
/// response) to SDL.
String introspectionToSdl(Map<String, dynamic> json) {
  final data = json['data'] as Map<String, dynamic>? ?? json;
  final schema = data['__schema'] as Map<String, dynamic>;
  final b = StringBuffer();

  String? rootName(String key) =>
      (schema[key] as Map<String, dynamic>?)?['name'] as String?;

  final roots = {
    'query': rootName('queryType'),
    'mutation': rootName('mutationType'),
    'subscription': rootName('subscriptionType'),
  }..removeWhere((_, name) => name == null);
  b.writeln('schema {');
  roots.forEach((op, name) => b.writeln('  $op: $name'));
  b
    ..writeln('}')
    ..writeln();

  for (final type in (schema['types'] as List).cast<Map<String, dynamic>>()) {
    final name = type['name'] as String;
    if (name.startsWith('__')) continue;
    switch (type['kind']) {
      case 'SCALAR':
        if (!_builtInScalars.contains(name)) b.writeln('scalar $name\n');
      case 'ENUM':
        b.writeln('enum $name {');
        for (final value in _list(type['enumValues'])) {
          b.writeln('  ${value['name']}');
        }
        b.writeln('}\n');
      case 'UNION':
        final members = _list(type['possibleTypes']).map((t) => t['name']);
        b.writeln('union $name = ${members.join(' | ')}\n');
      case 'INPUT_OBJECT':
        b.writeln('input $name {');
        for (final field in _list(type['inputFields'])) {
          b.writeln('  ${_inputValue(field)}');
        }
        b.writeln('}\n');
      case final kind && ('OBJECT' || 'INTERFACE'):
        final keyword = kind == 'OBJECT' ? 'type' : 'interface';
        final interfaces = _list(type['interfaces']).map((t) => t['name']);
        final implements = interfaces.isEmpty
            ? ''
            : ' implements ${interfaces.join(' & ')}';
        b.writeln('$keyword $name$implements {');
        for (final field in _list(type['fields'])) {
          final args = _list(field['args']).map(_inputValue);
          final argList = args.isEmpty ? '' : '(${args.join(', ')})';
          final deprecated = field['isDeprecated'] == true
              ? ' @deprecated(reason: ${jsonEncode(field['deprecationReason'] ?? 'No longer supported')})'
              : '';
          b.writeln(
            '  ${field['name']}$argList: '
            '${_typeRef(field['type'] as Map<String, dynamic>)}$deprecated',
          );
        }
        b.writeln('}\n');
    }
  }
  return b.toString();
}

List<Map<String, dynamic>> _list(Object? value) =>
    value is List ? value.cast<Map<String, dynamic>>() : const [];

String _inputValue(Map<String, dynamic> value) {
  final defaultValue = value['defaultValue'];
  final suffix = defaultValue == null ? '' : ' = $defaultValue';
  return '${value['name']}: '
      '${_typeRef(value['type'] as Map<String, dynamic>)}$suffix';
}

String _typeRef(Map<String, dynamic> ref) {
  final ofType = ref['ofType'] as Map<String, dynamic>?;
  return switch (ref['kind']) {
    'NON_NULL' => '${_typeRef(ofType!)}!',
    'LIST' => '[${_typeRef(ofType!)}]',
    _ => ref['name'] as String,
  };
}
