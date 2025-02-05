/// Base class for custom exceptions.
///
/// This class implements the `Exception` interface and provides a model
/// for custom exceptions, allowing the storage of an error message and
/// optional stack trace information.
///
abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.stackTracing,
  });

  /// The error message associated with the exception.
  final String message;

  /// Optional stack trace details.
  final dynamic stackTracing;
}
