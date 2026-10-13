/// Converts `PascalCase` or `camelCase` to `snake_case`.
///
/// Runs of capitals are kept together: `HTMLParser` becomes `html_parser`.
String toSnakeCase(String input) => input
    .replaceAllMapped(RegExp(r'([A-Z]+)([A-Z][a-z])'), (m) => '${m[1]}_${m[2]}')
    .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}')
    .toLowerCase();

String lowerFirst(String input) =>
    input.isEmpty ? input : input[0].toLowerCase() + input.substring(1);

String upperFirst(String input) =>
    input.isEmpty ? input : input[0].toUpperCase() + input.substring(1);

/// Escapes [input] for use inside a single-quoted Dart string.
String escapeDartString(String input) => input
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$')
    .replaceAll('\n', r'\n');

/// Dart reserved words that cannot be used as parameter names.
const dartReservedWords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
};

const _reservedWordRenames = {
  'new': 'newItem',
  'default': 'defaultValue',
  'class': 'className',
  'enum': 'enumValue',
  'static': 'staticValue',
  'const': 'constValue',
  'final': 'finalValue',
  'var': 'variable',
  'void': 'voidValue',
  'return': 'returnValue',
  'continue': 'continueValue',
  'break': 'breakValue',
};

/// A Dart-safe name for the GraphQL field [name], or [name] itself.
String safeFieldName(String name) => dartReservedWords.contains(name)
    ? _reservedWordRenames[name] ?? '${name}Value'
    : name;
