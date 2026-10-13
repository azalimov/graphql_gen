/// Implemented by every generated GraphQL field enum.
abstract interface class EnumFields {
  /// The GraphQL name of the field.
  String get fieldName;

  /// The fields selected inside this one when it is an object or list of
  /// objects, or `null` for scalar fields.
  List<EnumFields>? get nestedFields;
}
