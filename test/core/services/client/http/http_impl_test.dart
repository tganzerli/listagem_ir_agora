import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:lista_ir_agora/core/services/client/http/http_impl.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late RestClientHttp restClient;

  const baseUrl = 'http://example.com/';
  final sampleResponseData = {'message': 'success'};
  final sampleResponseJson = jsonEncode(sampleResponseData);

  setUpAll(() => registerFallbackValue(Uri()));

  setUp(() {
    mockHttpClient = MockHttpClient();
    restClient = RestClientHttp(client: mockHttpClient);
    restClient.setBaseUrl(baseUrl);
  });

  group('HTTP Requests', () {
    test('GET request returns correct response', () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'test',
        queryParameters: {'q': 'dart'},
      );
      final uri = Uri.parse(baseUrl)
          .resolve(request.path)
          .replace(queryParameters: request.queryParameters);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(sampleResponseJson, 200, reasonPhrase: 'OK'),
      );

      final response = await restClient.request(request);

      expect(response.statusCode, equals(200));
      expect(response.data, equals(sampleResponseData));
      expect(response.message, equals('OK'));
      expect(response.request, equals(request));

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });

    test('POST request with data returns correct response', () async {
      final requestData = {'name': 'John'};
      final request = RestClientRequest(
        method: RestMethod.post,
        path: 'create',
        data: requestData,
        headers: {'Custom-Header': 'custom'},
      );
      final uri = Uri.parse(baseUrl).resolve(request.path);
      final expectedHeaders = {
        'Custom-Header': 'custom',
        'Content-Type': 'application/json',
      };

      when(() => mockHttpClient.post(
            uri,
            headers: expectedHeaders,
            body: jsonEncode(requestData),
          )).thenAnswer(
        (_) async =>
            http.Response(sampleResponseJson, 201, reasonPhrase: 'Created'),
      );

      final response = await restClient.request(request);

      expect(response.statusCode, equals(201));
      expect(response.data, equals(sampleResponseData));
      expect(response.message, equals('Created'));
      expect(response.request, equals(request));

      verify(() => mockHttpClient.post(
            uri,
            headers: expectedHeaders,
            body: jsonEncode(requestData),
          )).called(1);
    });

    test('Request does not override baseUrl when request.baseUrl is empty',
        () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'test',
        baseUrl: '',
      );

      final uri = Uri.parse(baseUrl).resolve(request.path);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(sampleResponseJson, 200, reasonPhrase: 'OK'),
      );

      await restClient.request(request);

      expect(restClient.baseUrl, equals(uri.toString()));

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });
  });

  group('Error Handling', () {
    test('Throws RestClientException for 4xx status codes', () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'error',
      );
      final uri = Uri.parse(baseUrl).resolve(request.path);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response('Not Found', 404, reasonPhrase: 'Not Found'),
      );

      expect(
        () async => await restClient.request(request),
        throwsA(
          isA<RestClientException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.data, 'data', 'Not Found'),
        ),
      );

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });

    test('Throws RestClientException for unknown error', () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'unknown-error',
      );
      final uri = Uri.parse(baseUrl).resolve(request.path);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenThrow(http.ClientException('Failed to connect'));

      expect(
        () async => await restClient.request(request),
        throwsA(
          isA<RestClientException>().having(
              (e) => e.message, 'message', contains('Server connection error')),
        ),
      );

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });

    test('Throws RestClientException on timeout', () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'timeout',
      );
      final uri = Uri.parse(baseUrl).resolve(request.path);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenAnswer(
        (_) => Future.delayed(
          const Duration(seconds: 2),
          () => http.Response(sampleResponseJson, 200),
        ),
      );

      restClient.setTimeouts(connectTimeout: const Duration(milliseconds: 10));

      expect(
        () async => await restClient.request(request),
        throwsA(isA<RestClientException>().having(
            (e) => e.message, 'message', contains('HTTP request timeout'))),
      );

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });

    test('Throws exception when response has malformed JSON', () async {
      final request = RestClientRequest(
        method: RestMethod.get,
        path: 'malformed-json',
      );
      final uri = Uri.parse(baseUrl).resolve(request.path);

      when(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response('Invalid JSON', 200, reasonPhrase: 'OK'),
      );

      expect(
        () async => await restClient.request(request),
        throwsA(
          isA<RestClientException>().having(
            (e) => e.message,
            'message',
            contains('Invalid JSON response'),
          ),
        ),
      );

      verify(() => mockHttpClient.get(uri, headers: any(named: 'headers')))
          .called(1);
    });
  });

  group('Configuration & Utilities', () {
    test('Base URL getter works correctly', () {
      restClient.setBaseUrl('http://newexample.com/');
      expect(restClient.baseUrl, equals('http://newexample.com/'));
    });

    test('Headers manipulation works correctly', () async {
      restClient.setHeaders({'Authorization': 'Bearer token123'});
      restClient.cleanHeaders();
      expect(restClient.baseUrl, equals(baseUrl));
    });
  });
}
