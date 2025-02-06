class UrlContracts {
  static Api api = Api();
}

class Api {
  String base = const String.fromEnvironment('BASE_URL');
  String list = '/1IXK';
}
