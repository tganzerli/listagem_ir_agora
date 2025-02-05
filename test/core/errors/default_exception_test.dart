import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('DefaultException Tests', () {
    test('DefaultException should extend BaseException', () {
      const defaultException = DefaultException(
        message: 'Default error',
        stackTracing: 'Default stack trace',
      );

      expect(defaultException, isA<BaseException>());
      expect(defaultException.message, 'Default error');
      expect(defaultException.stackTracing, 'Default stack trace');
    });

    test('DefaultException should work with only message', () {
      const defaultException = DefaultException(
        message: 'Only message provided',
      );

      expect(defaultException.message, 'Only message provided');
      expect(defaultException.stackTracing, isNull);
    });
  });
}
