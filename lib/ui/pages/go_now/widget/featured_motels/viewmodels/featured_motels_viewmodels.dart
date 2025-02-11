import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/data/repositories/motels/motels_repository.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

import 'featured_motels_state_viewmodels.dart';

class FeaturedMotelsViewmodels
    extends ViewModel<FeaturedMotelsStateViewmodels> {
  final MotelsRepository motelsRepository;

  late final Command0<Unit> initEvent;

  FeaturedMotelsViewmodels({required this.motelsRepository})
      : super(FeaturedMotelsInitial()) {
    initEvent = Command0(_initEvent);
  }

  //Esta aplicação é apenas um Mock para simular os destaques
  AsyncOutput<Unit> _initEvent() async {
    return await motelsRepository.getGoNowList().fold(
      (exception) {
        emit(state.error(message: exception.message));
        return failure(exception);
      },
      (motels) {
        List<MotelsEntity> featuredMotels = motels.first.motelRooms
            .map((room) => MotelsEntity(
                name: 'Motel destaques 1',
                logo: room.imagens.first,
                neighborhood: 'Local motel 1',
                motelRooms: []))
            .toList();

        emit(state.success(motels: featuredMotels));
        return success(unit);
      },
    );
  }
}
