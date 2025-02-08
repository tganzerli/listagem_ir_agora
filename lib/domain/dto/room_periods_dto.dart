import 'dart:convert';

import 'package:lista_ir_agora/core/core.dart';

class RoomPeriodsDto extends DTO {
  final String formattedTime;
  final AmountVo amount;
  final AmountVo fullAmount;
  final PercentageVo percentageDiscount;

  RoomPeriodsDto({
    required this.formattedTime,
    required this.amount,
    required this.fullAmount,
    required this.percentageDiscount,
  });

  @override
  Output<RoomPeriodsDto> validate() {
    if (formattedTime.isEmpty) {
      return failure(ValidationException(message: 'Tempo não Informado'));
    }
    if (amount.validate().isLeft) {
      return amount.validate().map((fn) => this);
    }
    if (fullAmount.validate().isLeft) {
      return fullAmount.validate().map((fn) => this);
    }
    if (percentageDiscount.validate().isLeft) {
      return percentageDiscount.validate().map((fn) => this);
    }

    return success(this);
  }

  Map<String, dynamic> toMap() {
    return {
      'formattedTime': formattedTime,
      'amount': amount.toMap(),
      'fullAmount': fullAmount.toMap(),
      'percentageDiscount': percentageDiscount.toMap(),
    };
  }

  factory RoomPeriodsDto.fromMap(Map<String, dynamic> map) {
    return RoomPeriodsDto(
      formattedTime: map['formattedTime'] ?? '',
      amount: AmountVo.fromMap(map['amount']),
      fullAmount: AmountVo.fromMap(map['fullAmount']),
      percentageDiscount: PercentageVo.fromMap(map['percentageDiscount']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomPeriodsDto.fromJson(String source) =>
      RoomPeriodsDto.fromMap(json.decode(source));
}
