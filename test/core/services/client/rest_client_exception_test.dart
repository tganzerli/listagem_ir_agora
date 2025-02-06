import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('RestClientException', () {
    test('should create an instance with all fields properly assigned', () {
      const message = 'Request error occurred';
      const statusCode = 500;
      final data = {'key': 'value'};
      const errorDetail = 'Internal server error';

      final exception = RestClientException(
        message: message,
        statusCode: statusCode,
        data: data,
        error: errorDetail,
        response: null,
      );

      expect(exception.message, equals(message));
      expect(exception.statusCode, equals(statusCode));
      expect(exception.data, equals(data));
      expect(exception.error, equals(errorDetail));
      expect(exception.response, isNull);
    });

    test(
        'toString should return a formatted string containing exception details',
        () {
      const message = 'Request error occurred';
      const statusCode = 404;
      const data = 'Not found';
      const errorDetail = 'Resource not found';

      final exception = RestClientException(
        message: message,
        statusCode: statusCode,
        data: data,
        error: errorDetail,
      );

      final stringRepresentation = exception.toString();

      expect(stringRepresentation, contains('RestClientException:'));
      expect(stringRepresentation, contains('message: $message'));
      expect(stringRepresentation, contains('statusCode: $statusCode'));
      expect(stringRepresentation, contains('error: $errorDetail'));
      expect(stringRepresentation, contains('data: $data'));
    });
  });
}
