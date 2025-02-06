import 'package:intl/intl.dart';
import 'package:lista_ir_agora/core/core.dart';

class AmountVo extends ValueObject<double> {
  AmountVo(super.value);

  double toMap() => value;

  factory AmountVo.fromMap(double amount) => AmountVo(amount);

  @override
  Output<AmountVo> validate() {
    if (value <= 0) {
      return failure(ValidationException(message: 'Valor inválido'));
    }

    return success(this);
  }

  String toFormattedString() {
    final format = NumberFormat("#,##0.00", "pt_BR");
    return format.format(value);
  }

  factory AmountVo.fromFormattedString(String formattedValue) {
    String amount = formattedValue.contains(',')
        ? formattedValue.replaceAll('.', '').replaceAll(',', '.')
        : formattedValue;

    double? result = double.tryParse(amount);
    if (result == null) {
      throw FormatedException(message: "Valor inválido: $formattedValue");
    }

    return AmountVo(result);
  }
}
