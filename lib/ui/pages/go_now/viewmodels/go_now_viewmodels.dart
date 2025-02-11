import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/data/repositories/motels/motels_repository.dart';

import 'go_now_state_viewmodels.dart';

class GoNowViewModel extends ViewModel<GoNowStateViewmodels> {
  final MotelsRepository motelsRepository;

  late final Command0<Unit> initEvent;

  GoNowViewModel({required this.motelsRepository}) : super(GoNowInitial()) {
    initEvent = Command0(_initEvent);
  }

  AsyncOutput<Unit> _initEvent() async {
    return await motelsRepository.getGoNowList().fold(
      (exception) {
        emit(state.error(message: exception.message));
        return failure(exception);
      },
      (motels) {
        emit(state.success(motels: motels));
        return success(unit);
      },
    );
  }
}
