/// Marks a class for field-enum generation by `graphql_gen_generator`.
///
/// For a class `UserDto` the generator emits a private enum `_UserDtoFields`
/// into `user_dto.fields.g.dart`. Expose it from the source file with
/// `typedef UserDtoFields = _UserDtoFields;` and pass its values to
/// [GraphQLFieldBuilder.withEnumFields].
///
/// The generated entries read GraphQL names from `UserDtoJsonKeys`, so
/// json_serializable must run with `create_json_keys: true`.
class GenerateEnumFields {
  const GenerateEnumFields();
}
