import 'package:auto_injector/auto_injector.dart';
import 'package:http/http.dart' as http;

import 'core.dart';
import 'services/client/http/http_impl.dart';

export 'contracts/contracts.dart';
export 'errors/errors.dart';
export 'output/output.dart';
export 'services/services.dart';

final core = AutoInjector(
  tag: 'core',
  on: (i) {
    i.add<http.Client>(http.Client.new);
    i.add<RestClient>(RestClientHttp.new);
  },
);
