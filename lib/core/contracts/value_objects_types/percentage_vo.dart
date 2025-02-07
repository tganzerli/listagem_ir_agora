import 'package:intl/intl.dart';
import 'package:lista_ir_agora/core/core.dart';

class PercentageVo extends ValueObject<double> {
  PercentageVo(super.value);

  double toMap() => value;

  factory PercentageVo.fromMap(double amount) => PercentageVo(amount);

  @override
  Output<PercentageVo> validate() {
    if (value < 0 || value > 1) {
      return failure(ValidationException(message: 'Valor inválido'));
    }

    return success(this);
  }

  String toFormattedString() {
    final format = NumberFormat("0.00", "pt_BR");
    return format.format(value);
  }

  factory PercentageVo.fromFormattedString(String formattedValue) {
    String amount = formattedValue.contains(',')
        ? formattedValue.replaceAll(',', '.')
        : formattedValue;

    double? result = double.tryParse(amount);
    if (result == null) {
      throw FormatedException(message: "Valor inválido: $formattedValue");
    }

    return PercentageVo(result);
  }

  factory PercentageVo.calcularPorcentagem(
      AmountVo amount, AmountVo fullAmount) {
    if (fullAmount.validate().isLeft) {
      throw FormatedException(message: "Full Amount não é inválido");
    }

    double percentage = (1 - (amount.value / fullAmount.value));

    return PercentageVo(percentage).validate().fold(
      (exception) {
        throw exception;
      },
      (percentageVo) => percentageVo,
    );
  }
}
