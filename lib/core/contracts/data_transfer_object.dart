import 'package:lista_ir_agora/core/core.dart';

/// The `DTO` (Data Transfer Object) is an abstract class that serves as a
/// blueprint for objects designed to transfer data between different parts
/// of an application.
///
/// ## Purpose
/// - **Encapsulation**: Keeps internal data structures separate from external layers.
/// - **Efficiency**: Reduces network overhead by aggregating related data.
/// - **Security**: Limits exposure of sensitive information when transferring data.
///
/// ## Characteristics
/// - **Contains only data**: No business logic should be implemented within a DTO.
/// - **Used for data transport**: Typically used to send or receive data in APIs or
///   between application layers.
/// - **Validation**: Can include validation methods to ensure data integrity.
///
/// ## Example Usage
/// ```dart
/// class UserDTO extends DTO {
///   final int id;
///   final String username;
///   final String email;
///
///   UserDTO({required this.id, required this.username, required this.email});
///
///   @override
///   Output<DTO> validate() {
///     // Implement validation logic if necessary
///   }
/// }
/// ```
///
/// This example demonstrates a `UserDTO` class that encapsulates user information
/// while ensuring that sensitive data, such as passwords, is not exposed.
abstract class DTO {
  /// Validates the DTO data.
  ///
  /// Implement this method to ensure that the data within the DTO meets
  /// the required constraints before being processed.
  Output<DTO> validate();
}
