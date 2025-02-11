import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

abstract class FeaturedMotelsStateViewmodels implements ViewState {
  final List<MotelsEntity> motels;
  FeaturedMotelsStateViewmodels({
    required this.motels,
  });

  FeaturedMotelsLoading loading() {
    return FeaturedMotelsLoading(motels: motels);
  }

  FeaturedMotelsSuccess success({List<MotelsEntity>? motels}) {
    return FeaturedMotelsSuccess(motels: motels ?? this.motels);
  }

  FeaturedMotelsError error({required String message}) {
    return FeaturedMotelsError(
      message: message,
      motels: motels,
    );
  }
}

class FeaturedMotelsInitial extends FeaturedMotelsStateViewmodels {
  FeaturedMotelsInitial() : super(motels: []);
}

class FeaturedMotelsLoading extends FeaturedMotelsStateViewmodels {
  FeaturedMotelsLoading({required super.motels});
}

class FeaturedMotelsSuccess extends FeaturedMotelsStateViewmodels {
  FeaturedMotelsSuccess({required super.motels});
}

class FeaturedMotelsError extends FeaturedMotelsStateViewmodels {
  final String message;
  FeaturedMotelsError({
    required super.motels,
    required this.message,
  });
}
