import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ebookingdoc/src/Utils/utils.dart';
import 'package:ebookingdoc/src/Global/constant.dart';
import 'package:ebookingdoc/src/constants/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class APICaller {
  static APICaller? _apiCaller = APICaller();
  final String BASE_URL = "http://192.168.1.17:3210/";
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Duration timeout = const Duration(seconds: 30);
  static FutureOr<http.Response> Function()? onTimeout = () {
    return http.Response(
        'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
  };

  static APICaller getInstance() {
    _apiCaller ??= APICaller();
    return _apiCaller!;
  }

  handleResponse(http.Response response) async {
    print('[APICaller] Response code: ${response.statusCode}');
    print('[APICaller] Raw body: ${response.body}');
    final body = jsonDecode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return body;
    } else {
      return null;
    }
  }

  Future<dynamic> get(String endpoint, {dynamic body}) async {
    Uri uri = Uri.parse(BASE_URL + endpoint);
    var response = await http
        .get(uri, headers: requestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    Uri uri = Uri.parse(BASE_URL + endpoint);
    var response = await http
        .post(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> put(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(BASE_URL + endpoint);
    var response = await http
        .put(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    Uri uri = Uri.parse(BASE_URL + endpoint);
    var response = await http
        .delete(uri, headers: requestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> postFile(
      {required String endpoint,
      required File filePath,
      required String type,
      required String keyCert,
      required String time}) async {
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('ImageFiles', filePath.path));
    request.fields['Type'] = type;
    request.fields['keyCert'] = keyCert;
    request.fields['time'] = time;
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFiles(String endpoint, List<File> filePath) async {
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('files', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> putFile(
      {required String endpoint, required File filePath}) async {
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    request.files
        .add(await http.MultipartFile.fromPath('FileData', filePath.path));
    request.fields['Type'] = '1';
    request.fields['KeyCert'] = 'string';
    request.fields['Time'] = 'string';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.', 408);
      },
    );
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message']);
      return null;
    }
    return jsonDecode(response.body);
  }
}