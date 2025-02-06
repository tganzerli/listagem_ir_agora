import 'package:lista_ir_agora/core/core.dart';

/// Exception thrown when an error occurs during an HTTP request using the [RestClient].
///
/// This exception extends [BaseException] and implements the [RestClientHttpMessage]
/// interface, capturing specific details of the error such as the HTTP status code,
/// response data, and additional error details.
///
/// Example:
/// ```dart
/// try {
///   // Code that might throw a RestClientException
/// } on RestClientException catch (e) {
///   print(e.toString());
/// }
/// ```
class RestClientException extends BaseException
    implements RestClientHttpMessage {
  /// Additional data returned in the HTTP response.
  final dynamic data;

  /// HTTP status code returned by the request, if available.
  final int? statusCode;

  /// Detailed information about the error.
  final dynamic error;

  /// The complete response of the request, encapsulated in a [RestClientResponse].
  final RestClientResponse? response;

  /// Constructs a [RestClientException].
  ///
  /// Parameters:
  /// - [message]: A descriptive error message (required).
  /// - [statusCode]: The HTTP status code, if available.
  /// - [data]: Additional data returned in the response.
  /// - [response]: The complete response of the request.
  /// - [error]: Detailed error information (required).
  /// - [stackTracing]: The stack trace at the time the exception occurred.
  RestClientException({
    required super.message,
    this.statusCode,
    this.data,
    this.response,
    required this.error,
    super.stackTracing,
  });

  /// Returns a string representation of the exception, containing the main details of the error.
  @override
  String toString() {
    return 'RestClientException: { message: $message, statusCode: $statusCode, error: $error, data: $data }';
  }
}
