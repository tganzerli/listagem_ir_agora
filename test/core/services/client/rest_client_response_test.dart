import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('RestClientResponse', () {
    final dummyRequest = RestClientRequest(
      path: '/dummy',
      method: RestMethod.get,
    );

    test('should create an instance with provided values', () {
      final response = RestClientResponse(
        data: {'result': 'success'},
        statusCode: 200,
        message: 'OK',
        request: dummyRequest,
      );

      expect(response.data, equals({'result': 'success'}));
      expect(response.statusCode, equals(200));
      expect(response.message, equals('OK'));
      expect(response.request, equals(dummyRequest));
    });

    test('isSuccess should return true for status codes 200-299', () {
      final response200 = RestClientResponse(
        request: dummyRequest,
        statusCode: 200,
      );
      expect(response200.isSuccess, isTrue);

      final response250 = RestClientResponse(
        request: dummyRequest,
        statusCode: 250,
      );
      expect(response250.isSuccess, isTrue);

      final response299 = RestClientResponse(
        request: dummyRequest,
        statusCode: 299,
      );
      expect(response299.isSuccess, isTrue);
    });

    test('isSuccess should return false for status codes below 200', () {
      final response = RestClientResponse(
        request: dummyRequest,
        statusCode: 199,
      );
      expect(response.isSuccess, isFalse);
    });

    test('isSuccess should return false for status codes 300 and above', () {
      final response = RestClientResponse(
        request: dummyRequest,
        statusCode: 300,
      );
      expect(response.isSuccess, isFalse);
    });

    test('isSuccess should return false when statusCode is null', () {
      final response = RestClientResponse(
        request: dummyRequest,
      );
      expect(response.isSuccess, isFalse);
    });
  });
}
