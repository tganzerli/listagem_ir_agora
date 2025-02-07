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
  Output<DTO> validate() {
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
}
