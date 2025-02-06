import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/core/contracts/value_objects_types/amount_vo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockValidationException extends Mock implements ValidationException {}

void main() {
  group('AmountVo', () {
    test('should create an instance with a valid amount', () {
      final amount = AmountVo(100.0);
      expect(amount.value, equals(100.0));
    });

    test('should return failure when value is zero or negative', () {
      final negativeAmount = AmountVo(-10.0).validate();
      final zeroAmount = AmountVo(0.0).validate();

      expect(negativeAmount.isLeft, isTrue);
      expect(zeroAmount.isLeft, isTrue);

      negativeAmount.fold(
        (error) => expect(error, isA<ValidationException>()),
        (_) => fail('Expected failure, but got success'),
      );

      zeroAmount.fold(
        (error) => expect(error, isA<ValidationException>()),
        (_) => fail('Expected failure, but got success'),
      );
    });

    test('should return success when value is positive', () {
      final amount = AmountVo(50.0).validate();
      expect(amount.isRight, isTrue);
    });

    test('should correctly convert to a map', () {
      final amount = AmountVo(75.0);
      expect(amount.toMap(), equals(75.0));
    });

    test('should correctly create from a map', () {
      final amount = AmountVo.fromMap(120.5);
      expect(amount.value, equals(120.5));
    });

    test('should format the amount correctly', () {
      final amount = AmountVo(1234.56);
      expect(amount.toFormattedString(), equals('1.234,56'));
    });

    test('should parse formatted string correctly', () {
      final amount = AmountVo.fromFormattedString('1.234,56');
      expect(amount.value, equals(1234.56));
    });

    test('should throw FormatException for invalid string', () {
      expect(() => AmountVo.fromFormattedString('invalid'),
          throwsA(isA<FormatedException>()));
    });

    test('should correctly handle different decimal separators', () {
      expect(AmountVo.fromFormattedString('1234.56').value, equals(1234.56));
      expect(AmountVo.fromFormattedString('1234,56').value, equals(1234.56));
      expect(AmountVo.fromFormattedString('1.234,56').value, equals(1234.56));
    });
  });
}
