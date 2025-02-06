import 'package:lista_ir_agora/core/core.dart';

/// Represents an HTTP response message for a REST client.
class RestClientResponse implements RestClientHttpMessage {
  /// The response body data.
  dynamic data;

  /// The HTTP status code of the response.
  int? statusCode;

  /// A message associated with the response, often used for error or status details.
  String? message;

  /// The original request that generated this response.
  RestClientRequest request;

  /// Creates a new [RestClientResponse] instance.
  ///
  /// The [request] parameter is required. Other fields are optional.
  RestClientResponse({
    this.data,
    this.statusCode,
    this.message,
    required this.request,
  });

  /// Returns `true` if the [statusCode] indicates a successful response (between 200 and 299).
  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}
