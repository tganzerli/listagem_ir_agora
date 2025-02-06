import 'rest_client_http_message.dart';

/// Represents an HTTP request message for a REST client.
class RestClientRequest implements RestClientHttpMessage {
  /// The endpoint path for the request.
  final String path;

  /// The HTTP method used for the request.
  final RestMethod method;

  /// The request body data.
  final dynamic data;

  /// The base URL for the request.
  final String baseUrl;

  /// Query parameters to be appended to the URL.
  final Map<String, dynamic>? queryParameters;

  /// HTTP headers to be sent with the request.
  final Map<String, dynamic>? headers;

  /// The timeout duration for sending the request.
  final Duration? sendTimeout;

  /// The timeout duration for receiving the response.
  final Duration? receiveTimeout;

  /// Creates a new [RestClientRequest] instance.
  ///
  /// The [path] and [method] parameters are required.
  /// Other parameters are optional. If not provided, [baseUrl] defaults to an empty string.
  RestClientRequest({
    required this.path,
    required this.method,
    this.data,
    this.baseUrl = '',
    this.queryParameters,
    this.headers,
    this.sendTimeout,
    this.receiveTimeout,
  });

  /// Returns a copy of this [RestClientRequest] with updated fields.
  ///
  /// Only the fields provided as parameters will be updated; all other fields remain unchanged.
  ///
  /// Example:
  /// ```dart
  /// final request = RestClientRequest(path: '/api', method: RestMethod.get);
  /// final updatedRequest = request.copyWith(path: '/api/v2');
  /// ```
  RestClientRequest copyWith({
    String? path,
    RestMethod? method,
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) {
    return RestClientRequest(
      path: path ?? this.path,
      method: method ?? this.method,
      data: data ?? this.data,
      baseUrl: baseUrl ?? this.baseUrl,
      queryParameters: queryParameters ?? this.queryParameters,
      headers: headers ?? this.headers,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    );
  }
}

/// Enum representing HTTP methods used in REST requests.
enum RestMethod {
  /// HTTP DELETE method.
  delete('DELETE'),

  /// HTTP GET method.
  get('GET'),

  /// HTTP PATCH method.
  patch('PATCH'),

  /// HTTP POST method.
  post('POST'),

  /// HTTP PUT method.
  put('PUT');

  /// The string representation of the HTTP method.
  final String method;

  /// Creates a new [RestMethod] with its string representation.
  const RestMethod(this.method);

  /// Returns the string representation of the HTTP method.
  @override
  String toString() => method;

  /// Creates a [RestMethod] from a given string.
  ///
  /// If the provided [method] does not match any known HTTP method,
  /// [RestMethod.get] is returned by default.
  ///
  /// Example:
  /// ```dart
  /// final method = RestMethod.fromString('POST'); // Returns RestMethod.post
  /// ```
  static RestMethod fromString(String method) {
    return switch (method) {
      'DELETE' => RestMethod.delete,
      'GET' => RestMethod.get,
      'PATCH' => RestMethod.patch,
      'POST' => RestMethod.post,
      'PUT' => RestMethod.put,
      _ => RestMethod.get,
    };
  }
}
