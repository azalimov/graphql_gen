/// A single entry of a GraphQL response `errors` array.
class GraphQLError {
  final String? message;
  final List<GraphQLErrorLocation>? locations;
  final List<String>? path;
  final GraphQLErrorExtensions? extensions;

  GraphQLError({this.message, this.locations, this.path, this.extensions});

  factory GraphQLError.fromJson(Map<String, dynamic> json) {
    return GraphQLError(
      message: json['message'] as String?,
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => GraphQLErrorLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: (json['path'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      extensions: json['extensions'] != null
          ? GraphQLErrorExtensions.fromJson(
              json['extensions'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'locations': locations?.map((e) => e.toJson()).toList(),
    'path': path,
    'extensions': extensions?.toJson(),
  };
}

/// Where in the request document an error occurred.
class GraphQLErrorLocation {
  final int? line;
  final int? column;

  GraphQLErrorLocation({this.line, this.column});

  factory GraphQLErrorLocation.fromJson(Map<String, dynamic> json) {
    return GraphQLErrorLocation(
      line: json['line'] as int?,
      column: json['column'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {'line': line, 'column': column};
}

/// Common server-specific error details from `extensions`.
class GraphQLErrorExtensions {
  final String? code;
  final String? field;
  final String? statusCode;
  final String? trace;

  GraphQLErrorExtensions({this.code, this.field, this.statusCode, this.trace});

  factory GraphQLErrorExtensions.fromJson(Map<String, dynamic> json) {
    return GraphQLErrorExtensions(
      code: json['code']?.toString(),
      field: json['field'] as String?,
      statusCode: json['statusCode']?.toString(),
      trace: json['trace'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'field': field,
    'statusCode': statusCode,
    'trace': trace,
  };
}

/// The `errors` and partial `data` of a failed GraphQL response.
class GraphQLErrorResponse {
  final List<GraphQLError> errors;
  final Object? data;

  GraphQLErrorResponse({this.errors = const [], this.data});

  factory GraphQLErrorResponse.fromJson(Map<String, dynamic> json) {
    List<GraphQLError> errorsList = [];
    final errorsData = json['errors'];

    if (errorsData is List && errorsData.isNotEmpty) {
      errorsList = errorsData
          .whereType<Map<String, dynamic>>()
          .map((error) => GraphQLError.fromJson(error))
          .toList();
    }

    return GraphQLErrorResponse(errors: errorsList, data: json['data']);
  }

  Map<String, dynamic> toJson() => {
    'errors': errors.map((e) => e.toJson()).toList(),
    'data': data,
  };

  String? get firstErrorMessage =>
      errors.isNotEmpty ? errors.first.message : null;
  String? get firstErrorCode =>
      errors.isNotEmpty ? errors.first.extensions?.code : null;

  bool get hasErrors => errors.isNotEmpty;
}
