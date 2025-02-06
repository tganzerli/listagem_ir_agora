import 'package:lista_ir_agora/core/core.dart';

abstract interface class RestClient {
  Future<RestClientResponse> request(RestClientRequest request);
  void setBaseUrl(String url);
  void cleanHeaders();
  void setHeaders(Map<String, dynamic> header);
  void setTimeouts({Duration? connectTimeout, Duration? receiveTimeout});
}
