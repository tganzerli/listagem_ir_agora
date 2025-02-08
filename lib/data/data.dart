import 'package:auto_injector/auto_injector.dart';

import 'datasources/motels/motels_client_http.dart';
import 'repositories/motels/motels_repository.dart';
import 'repositories/motels/remote_motels_repository.dart';

final data = AutoInjector(
  tag: 'core',
  on: (i) {
    i.add<MotelsClientHttp>(MotelsClientHttp.new);
    i.add<MotelsRepository>(RemoteMotelsRepository.new);
  },
);
