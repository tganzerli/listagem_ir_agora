import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lista_ir_agora/core/core.dart';

class RestClientHttp implements RestClient {
  final http.Client client;

  RestClientHttp({required this.client});

  String _baseUrl = '';
  Duration? _connectTimeout;
  Duration? _receiveTimeout;
  final Map<String, String> _defaultHeaders = {};

  @override
  Future<RestClientResponse> request(RestClientRequest request) async {
    if (request.baseUrl.isNotEmpty) {
      _baseUrl = request.baseUrl;
    }
    _baseUrl = _baseUrl + request.path;

    final uri =
        Uri.parse(_baseUrl).replace(queryParameters: request.queryParameters);

    final headers = <String, String>{
      ..._defaultHeaders,
      if (request.headers != null)
        ...request.headers!
            .map((key, value) => MapEntry(key, value.toString())),
    };

    String? body;
    if (request.data != null) {
      body = jsonEncode(request.data);
      headers.putIfAbsent('Content-Type', () => 'application/json');
    }

    final totalTimeout = (_connectTimeout ?? const Duration(seconds: 30)) +
        (_receiveTimeout ?? Duration.zero);

    Future<http.Response> fetchRequest() {
      switch (request.method) {
        case RestMethod.get:
          return client.get(uri, headers: headers);
        case RestMethod.post:
          return client.post(uri, headers: headers, body: body);
        case RestMethod.put:
          return client.put(uri, headers: headers, body: body);
        case RestMethod.delete:
          return client.delete(uri, headers: headers);
        case RestMethod.patch:
          return client.patch(uri, headers: headers, body: body);
      }
    }

    try {
      final response = await fetchRequest().timeout(totalTimeout);
      final responseBody = _parseResponseBody(response);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw RestClientException(
          message: 'HTTP request failed',
          statusCode: response.statusCode,
          data: responseBody,
          response: RestClientResponse(
            data: responseBody,
            statusCode: response.statusCode,
            message: response.reasonPhrase,
            request: request,
          ),
          error: 'Request failed with status ${response.statusCode}',
        );
      }

      return RestClientResponse(
        data: responseBody,
        statusCode: response.statusCode,
        message: response.reasonPhrase,
        request: request,
      );
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e) {
      throw RestClientException(
        message: 'Server connection error',
        error: e,
      );
    } on TimeoutException catch (e) {
      throw RestClientException(
        message: 'HTTP request timeout',
        error: 'The request took too long to complete: $e',
      );
    } catch (e) {
      throw RestClientException(
        message: 'Unknown error occurred during the HTTP request',
        error: e,
      );
    }
  }

  dynamic _parseResponseBody(http.Response response) {
    if (response.body.isEmpty) {
      return {'error': 'Empty response from server'};
    }
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {'error': response.body};
    }
  }

  String get baseUrl => _baseUrl;

  @override
  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  @override
  void cleanHeaders() {
    _defaultHeaders.clear();
  }

  @override
  void setHeaders(Map<String, dynamic> headers) {
    _defaultHeaders.addAll(
      headers.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  @override
  void setTimeouts({Duration? connectTimeout, Duration? receiveTimeout}) {
    _connectTimeout = connectTimeout;
    _receiveTimeout = receiveTimeout;
  }
}
