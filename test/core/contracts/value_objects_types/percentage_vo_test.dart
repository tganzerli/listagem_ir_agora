import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockValidationException extends Mock implements ValidationException {}

void main() {
  group('PercentageVo', () {
    test('should create an instance with a valid percentage', () {
      final percentage = PercentageVo(0.5);
      expect(percentage.value, equals(0.5));
    });

    test('should return failure when value is less than 0', () {
      final result = PercentageVo(-0.1).validate();
      expect(result.isLeft, isTrue);

      result.fold(
        (error) => expect(error, isA<ValidationException>()),
        (_) => fail('Expected failure, but got success'),
      );
    });

    test('should return failure when value is greater than 1', () {
      final result = PercentageVo(1.5).validate();
      expect(result.isLeft, isTrue);

      result.fold(
        (error) => expect(error, isA<ValidationException>()),
        (_) => fail('Expected failure, but got success'),
      );
    });

    test('should return success when value is between 0 and 1', () {
      final result = PercentageVo(0.75).validate();
      expect(result.isRight, isTrue);
    });

    test('should correctly convert to a map', () {
      final percentage = PercentageVo(0.25);
      expect(percentage.toMap(), equals(0.25));
    });

    test('should correctly create from a map', () {
      final percentage = PercentageVo.fromMap(0.35);
      expect(percentage.value, equals(0.35));
    });

    test('should format the percentage correctly', () {
      final percentage = PercentageVo(0.785);
      expect(percentage.toFormattedString(), equals('0,79'));
    });

    test('should parse formatted string correctly', () {
      final percentage = PercentageVo.fromFormattedString('0,75');
      expect(percentage.value, equals(0.75));
    });

    test('should throw FormatException when parsing invalid formatted string',
        () {
      expect(() => PercentageVo.fromFormattedString('invalid'),
          throwsA(isA<FormatedException>()));
    });

    test('should correctly calculate percentage', () {
      final amount = AmountVo(50.0);
      final fullAmount = AmountVo(100.0);

      final percentage = PercentageVo.calcularPorcentagem(amount, fullAmount);

      expect(percentage.value, equals(0.5));
    });

    test(
        'should throw ArgumentError when calculating percentage with invalid fullAmount',
        () {
      final amount = AmountVo(50.0);
      final fullAmount = AmountVo(0.0); // Invalid full amount

      expect(() => PercentageVo.calcularPorcentagem(amount, fullAmount),
          throwsA(isA<FormatedException>()));
    });
  });
}
