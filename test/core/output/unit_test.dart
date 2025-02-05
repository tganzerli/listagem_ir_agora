import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/output/output.dart';

void main() {
  group('Unit Singleton Tests', () {
    test('unit should be a singleton', () {
      expect(unit, same(unit),
          reason: 'unit should always refer to the same instance');
    });

    test('unit should be of type Unit', () {
      expect(unit, isA<Unit>(), reason: 'unit should be an instance of Unit');
    });
  });
}
