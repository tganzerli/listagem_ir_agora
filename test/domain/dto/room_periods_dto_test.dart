import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';

import 'package:mocktail/mocktail.dart';
import 'package:lista_ir_agora/core/core.dart';

class MockAmountVo extends Mock implements AmountVo {}

class MockPercentageVo extends Mock implements PercentageVo {}

void main() {
  late RoomPeriodsDto dto;
  late MockAmountVo mockAmount;
  late MockAmountVo mockFullAmount;
  late MockPercentageVo mockPercentageDiscount;

  setUp(() {
    mockAmount = MockAmountVo();
    mockFullAmount = MockAmountVo();
    mockPercentageDiscount = MockPercentageVo();
    dto = RoomPeriodsDto(
      formattedTime: '3 horas',
      amount: mockAmount,
      fullAmount: mockFullAmount,
      percentageDiscount: mockPercentageDiscount,
    );
  });

  void mockValidations({
    bool isAmountValid = true,
    bool isFullAmountValid = true,
    bool isPercentageValid = true,
  }) {
    when(() => mockAmount.validate()).thenReturn(
      isAmountValid
          ? success(mockAmount)
          : failure(ValidationException(message: 'Invalid amount')),
    );
    when(() => mockFullAmount.validate()).thenReturn(
      isFullAmountValid
          ? success(mockFullAmount)
          : failure(ValidationException(message: 'Invalid full amount')),
    );
    when(() => mockPercentageDiscount.validate()).thenReturn(
      isPercentageValid
          ? success(mockPercentageDiscount)
          : failure(
              ValidationException(message: 'Invalid percentage discount')),
    );
  }

  group('RoomPeriodsDto Validation', () {
    test('should return success when all fields are valid', () {
      mockValidations();

      final result = dto.validate();

      expect(result.isRight, true);
    });

    test('should return failure when formattedTime is empty', () {
      mockValidations();

      final dto = RoomPeriodsDto(
        formattedTime: '',
        amount: mockAmount,
        fullAmount: mockFullAmount,
        percentageDiscount: mockPercentageDiscount,
      );
      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Tempo não Informado');
    });

    test('should return failure when amount validation fails', () {
      mockValidations(isAmountValid: false);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid amount');
    });

    test('should return failure when fullAmount validation fails', () {
      mockValidations(isFullAmountValid: false);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid full amount');
    });

    test('should return failure when percentageDiscount validation fails', () {
      mockValidations(isPercentageValid: false);

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Invalid percentage discount');
    });
  });
}
