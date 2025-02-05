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
