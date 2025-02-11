import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';
import 'package:lista_ir_agora/core/core.dart';

void main() {
  group('RoomPeriodsDto Validation', () {
    test('should return success when all fields are valid', () {
      final dto = RoomPeriodsDto(
        formattedTime: '3 horas',
        amount: AmountVo(100),
        fullAmount: AmountVo(200),
        percentageDiscount: PercentageVo(0.5),
      );

      final result = dto.validate();

      expect(result.isRight, true);
    });

    test('should return failure when formattedTime is empty', () {
      final dto = RoomPeriodsDto(
        formattedTime: '',
        amount: AmountVo(100),
        fullAmount: AmountVo(200),
        percentageDiscount: PercentageVo(0.5),
      );

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Tempo não Informado');
    });

    test('should return failure when amount validation fails', () {
      final dto = RoomPeriodsDto(
        formattedTime: '3 horas',
        amount: AmountVo(0),
        fullAmount: AmountVo(200),
        percentageDiscount: PercentageVo(0.5),
      );

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Valor inválido');
    });

    test('should return failure when fullAmount validation fails', () {
      final dto = RoomPeriodsDto(
        formattedTime: '3 horas',
        amount: AmountVo(100),
        fullAmount: AmountVo(0),
        percentageDiscount: PercentageVo(0.5),
      );

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Valor inválido');
    });

    test('should return failure when percentageDiscount validation fails', () {
      final dto = RoomPeriodsDto(
        formattedTime: '3 horas',
        amount: AmountVo(100),
        fullAmount: AmountVo(200),
        percentageDiscount: PercentageVo(1.5),
      );

      final result = dto.validate();

      expect(result.isLeft, true);
      expect(result.getLeftOrNull(), isA<ValidationException>());
      expect(result.getLeftOrNull()?.message, 'Valor inválido');
    });
  });

  group('RoomPeriodsDto Serialization', () {
    final validDto = RoomPeriodsDto(
      formattedTime: '3 horas',
      amount: AmountVo(100.0),
      fullAmount: AmountVo(200.0),
      percentageDiscount: PercentageVo(0.5),
    );

    final validMap = {
      'formattedTime': '3 horas',
      'amount': 100.0,
      'fullAmount': 200.0,
      'percentageDiscount': 0.5,
    };

    test('should convert toMap correctly', () {
      expect(validDto.toMap(), equals(validMap));
    });

    test('should convert fromMap correctly', () {
      final dto = RoomPeriodsDto.fromMap(validMap);
      expect(dto.formattedTime, '3 horas');
      expect(dto.amount.value, 100.0);
      expect(dto.fullAmount.value, 200.0);
      expect(dto.percentageDiscount.value, 0.5);
    });

    test('should convert toJson correctly', () {
      final jsonResult = validDto.toJson();
      expect(json.decode(jsonResult), equals(validMap));
    });

    test('should convert fromJson correctly', () {
      final dto = RoomPeriodsDto.fromJson(json.encode(validMap));
      expect(dto.formattedTime, '3 horas');
      expect(dto.amount.value, 100.0);
      expect(dto.fullAmount.value, 200.0);
      expect(dto.percentageDiscount.value, 0.5);
    });
  });
}
