import 'package:auto_injector/auto_injector.dart';
import 'package:http/http.dart' as http;
import 'package:lista_ir_agora/ui/pages/go_now/widget/featured_motels/viewmodels/featured_motels_viewmodels.dart';

import '../../ui/pages/go_now/widget/motel_card/viewmodels/motel_card_viewmodels.dart';
import '../core.dart';
import '../services/client/http/http_impl.dart';
import '../../data/datasources/motels/motels_client_http.dart';
import '../../data/repositories/motels/motels_repository.dart';
import '../../data/repositories/motels/remote_motels_repository.dart';
import '../../ui/pages/go_now/viewmodels/go_now_viewmodels.dart';

final injector = AutoInjector();

void setupDependencies() {
  injector.add<http.Client>(http.Client.new);
  injector.add<RestClient>(RestClientHttp.new);
  injector.add<MotelsClientHttp>(MotelsClientHttp.new);
  injector.add<MotelsRepository>(RemoteMotelsRepository.new);
  injector.add<GoNowViewModel>(GoNowViewModel.new);
  injector.add<MotelCardViewmodels>(MotelCardViewmodels.new);
  injector.add<FeaturedMotelsViewmodels>(FeaturedMotelsViewmodels.new);
  injector.commit();
}
