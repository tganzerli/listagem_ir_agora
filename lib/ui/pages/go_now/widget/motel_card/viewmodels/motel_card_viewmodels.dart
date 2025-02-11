import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/entities/rooms_entity.dart';

import 'motel_card_state_viewmodels.dart';

class MotelCardViewmodels extends ViewModel<MotelCardStateViewmodels> {
  late final Command1<double, RoomsEntity> setCardHeight;

  MotelCardViewmodels() : super(MotelCardInitial()) {
    setCardHeight = Command1(_setCardHeight);
  }

  AsyncOutput<double> _setCardHeight(RoomsEntity room) async {
    return success(346 + (room.periods.length * 88));
  }
}
