import 'package:lista_ir_agora/core/output/async_output.dart';
import 'package:lista_ir_agora/data/adapters/motels/go_now_list_adapter.dart';
import 'package:lista_ir_agora/data/repositories/motels/motels_repository.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';

import '../../datasources/motels/motels_client_http.dart';

class RemoteMotelsRepository implements MotelsRepository {
  final MotelsClientHttp motelsClientHttp;

  RemoteMotelsRepository({required this.motelsClientHttp});

  @override
  AsyncOutput<List<MotelsEntity>> getGoNowList() async {
    return motelsClientHttp.getGoNowList().bind(GoNowListAdapter.fromMap);
  }
}
