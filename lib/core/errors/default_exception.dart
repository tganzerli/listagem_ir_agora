import 'base_exception.dart';

/// A default exception that extends `BaseException`.
///
/// This class can be used to represent generic errors in the application.
///
/// Example usage:
/// ```dart
/// throw DefaultException(message: "A default error occurred");
/// ```
class DefaultException extends BaseException {
  /// Creates a `DefaultException` instance.
  ///
  /// - [message]: A descriptive error message.
  /// - [stackTracing]: (Optional) Stack trace details.
  const DefaultException({
    required super.message,
    super.stackTracing,
  });
}

/// Exception thrown when a validation error occurs.
///
/// This exception extends [BaseException] and is intended to be used
/// when the input data or the state of an object does not satisfy the
/// defined validation rules. It provides a descriptive error message,
/// and optionally, a stack trace to help with debugging.
///
/// Example usage:
/// ```dart
/// if (!user.isValid()) {
///   throw ValidationException(message: "User validation failed");
/// }
/// ```
class ValidationException extends BaseException {
  /// Creates a [ValidationException] instance.
  ///
  /// The [message] parameter is required and should contain a descriptive
  /// error message explaining why the validation failed.
  ///
  /// The optional [stackTracing] parameter can be used to provide additional
  /// details about the location in the code where the exception occurred.
  const ValidationException({
    required super.message,
    super.stackTracing,
  });
}

/// Exception thrown when a formatted error occurs.
///
/// This exception extends [BaseException] and is intended to be used
/// when an error needs to be presented in a formatted way. It provides
/// a descriptive error message, and optionally, a stack trace to assist
/// with debugging.
///
/// Example usage:
/// ```dart
/// throw FormatedException(message: "An error occurred with specific formatting");
/// ```
class FormatedException extends BaseException {
  /// Creates a [FormatedException] instance.
  ///
  /// - [message]: A descriptive error message.
  /// - [stackTracing]: (Optional) Stack trace details.
  const FormatedException({
    required super.message,
    super.stackTracing,
  });
}
