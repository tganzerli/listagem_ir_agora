import 'dart:developer';

import 'package:lista_ir_agora/core/core.dart';

import '../../url_contracts.dart';

class MotelsClientHttp {
  final RestClient restClient;

  MotelsClientHttp({required this.restClient});

  AsyncOutput<Map<String, dynamic>> getGoNowList() async {
    try {
      final baseResponse = await restClient.request(RestClientRequest(
        baseUrl: UrlContracts.api.base,
        path: UrlContracts.api.goNow,
        method: RestMethod.get,
      ));
      final data = baseResponse.data;
      if (data is! Map<String, dynamic>) {
        return failure(
            FormatedException(message: 'Return with different formatting'));
      } else {
        return success(data);
      }
    } on BaseException catch (_) {
      rethrow;
    } catch (e) {
      log(e.toString(), name: 'MotelsClientHttp - getGoNowList');
      return failure(DefaultException(message: e.toString()));
    }
  }
}
