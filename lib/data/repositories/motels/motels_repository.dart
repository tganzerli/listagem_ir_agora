import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

abstract interface class MotelsRepository {
  AsyncOutput<List<MotelsEntity>> getGoNowList();
}
