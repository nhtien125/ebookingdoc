class GlobalValue {
  static dynamic global;
  static GlobalValue getInstance() {
    global ??= GlobalValue();
    return global;
  }

  String _token = "";
  String _endpoint = "";
  dynamic _body;


  void setToken(String token) {
    _token = token;
  }

  String getToken() {
    return _token;
  }

  String getEndpoint() {
    return _endpoint;
  }

  void setEndpoint(String endpoint) {
    _endpoint = endpoint;
  }

  dynamic getBody() {
    return _body;
  }

  void setBody(dynamic body) {
    _body = body;
  }
}