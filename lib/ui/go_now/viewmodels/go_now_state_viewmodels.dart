import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

abstract class GoNowStateViewmodels implements ViewState {
  final List<MotelsEntity> motels;
  GoNowStateViewmodels({
    required this.motels,
  });

  GoNowLoading loading() {
    return GoNowLoading(motels: motels);
  }

  GoNowSuccess success({List<MotelsEntity>? motels}) {
    return GoNowSuccess(motels: motels ?? this.motels);
  }

  GoNowError error({required String message}) {
    return GoNowError(
      message: message,
      motels: motels,
    );
  }
}

class GoNowInitial extends GoNowStateViewmodels {
  GoNowInitial() : super(motels: []);
}

class GoNowLoading extends GoNowStateViewmodels {
  GoNowLoading({required super.motels});
}

class GoNowSuccess extends GoNowStateViewmodels {
  GoNowSuccess({required super.motels});
}

class GoNowError extends GoNowStateViewmodels {
  final String message;
  GoNowError({
    required super.motels,
    required this.message,
  });
}
