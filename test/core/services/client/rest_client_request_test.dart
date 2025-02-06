import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('RestClientRequest', () {
    test('should create an instance with provided values', () {
      final request = RestClientRequest(
        path: '/test',
        method: RestMethod.get,
        data: {'key': 'value'},
        baseUrl: 'https://example.com',
        queryParameters: {'q': 'dart'},
        headers: {'Content-Type': 'application/json'},
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 20),
      );

      expect(request.path, equals('/test'));
      expect(request.method, equals(RestMethod.get));
      expect(request.data, equals({'key': 'value'}));
      expect(request.baseUrl, equals('https://example.com'));
      expect(request.queryParameters, equals({'q': 'dart'}));
      expect(request.headers, equals({'Content-Type': 'application/json'}));
      expect(request.sendTimeout, equals(Duration(seconds: 10)));
      expect(request.receiveTimeout, equals(Duration(seconds: 20)));
    });

    test('copyWith should update provided fields', () {
      final original = RestClientRequest(
        path: '/original',
        method: RestMethod.post,
        data: 'data',
        baseUrl: 'https://original.com',
      );

      final copy = original.copyWith(
        path: '/updated',
        method: RestMethod.put,
        data: 'updatedData',
        baseUrl: 'https://updated.com',
      );

      expect(copy.path, equals('/updated'));
      expect(copy.method, equals(RestMethod.put));
      expect(copy.data, equals('updatedData'));
      expect(copy.baseUrl, equals('https://updated.com'));

      // The remaining fields should be unchanged (in this case, null).
      expect(copy.queryParameters, equals(original.queryParameters));
      expect(copy.headers, equals(original.headers));
      expect(copy.sendTimeout, equals(original.sendTimeout));
      expect(copy.receiveTimeout, equals(original.receiveTimeout));
    });

    test('copyWith should retain original values when no updates are provided',
        () {
      final original = RestClientRequest(
        path: '/test',
        method: RestMethod.get,
        data: 'data',
        baseUrl: 'https://example.com',
      );

      final copy = original.copyWith();

      expect(copy.path, equals(original.path));
      expect(copy.method, equals(original.method));
      expect(copy.data, equals(original.data));
      expect(copy.baseUrl, equals(original.baseUrl));
    });
  });

  group('RestMethod', () {
    test('toString should return the correct method string', () {
      expect(RestMethod.get.toString(), equals('GET'));
      expect(RestMethod.post.toString(), equals('POST'));
      expect(RestMethod.put.toString(), equals('PUT'));
      expect(RestMethod.patch.toString(), equals('PATCH'));
      expect(RestMethod.delete.toString(), equals('DELETE'));
    });

    test('fromString should return the correct enum value', () {
      expect(RestMethod.fromString('GET'), equals(RestMethod.get));
      expect(RestMethod.fromString('POST'), equals(RestMethod.post));
      expect(RestMethod.fromString('PUT'), equals(RestMethod.put));
      expect(RestMethod.fromString('PATCH'), equals(RestMethod.patch));
      expect(RestMethod.fromString('DELETE'), equals(RestMethod.delete));
    });

    test('fromString should return RestMethod.get for unknown methods', () {
      expect(RestMethod.fromString('UNKNOWN'), equals(RestMethod.get));
      expect(RestMethod.fromString(''), equals(RestMethod.get));
    });
  });
}
