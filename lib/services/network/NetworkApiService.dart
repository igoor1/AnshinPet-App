import 'package:anshinpet/data/app_exceptions.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/model/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:anshinpet/viewmodels/token_view_model.dart';

class NetworkApiService extends BaseApiServices {
  TokenViewModel tokenViewModel = TokenViewModel();

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getAuthApiResponse(String url) async {
    dynamic responseJson;
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      if (token == null || token.isEmpty || token == 'null') {
        throw UnauthorizedException('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet Connection');
    }
    return responseJson;
  }

  @override
  Future<void> deleteApiResponse(String url) async {
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      if (token == null || token.isEmpty || token == 'null') {
        throw UnauthorizedException(
            'Token não encontrado. Por favor, faça login novamente.');
      }

      final response = await http.delete(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw FetchDataException(
            'Failed to delete resource. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
  }

dynamic returnResponse(http.Response response) {
    final String utf8Body = utf8.decode(response.bodyBytes);

    switch (response.statusCode) {
      case 200:
      case 201:
        if (utf8Body.isEmpty) return {};
        return jsonDecode(utf8Body);

      case 204:
        return {};

      case 400:
        throw BadRequestException(utf8Body);

      case 401:
        throw UnauthorizedException(utf8Body);

      default:
        throw FetchDataException(
          'Error occurred while communicating with server with status code ${response.statusCode}',
        );
    }
  }
  @override
  Future<Map<String, dynamic>> getAuthPostApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      if (token == null || token.isEmpty || token == 'null') {
        throw UnauthorizedException(
            'Token não encontrado. Por favor, faça login novamente.');
      }

      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future<Map<String, dynamic>> putApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      if (token == null || token.isEmpty || token == 'null') {
        throw UnauthorizedException(
            'Token não encontrado. Por favor, faça login novamente.');
      }

      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }
  
  @override
  Future<Map<String, dynamic>> multipartRequestApiResponse(
      String method,
      String url,
      File file,
      Map<String, String>? fields) async {
        
    dynamic responseJson;
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      if (token == null || token.isEmpty || token == 'null') {
        throw UnauthorizedException('Token não encontrado');
      }

      var request = http.MultipartRequest(method, Uri.parse(url));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers["Accept"] = 'application/json';

      var multipartFile = await http.MultipartFile.fromPath(
        'file',  
        file.path,
        filename: file.path.split('/').last,
      );

      request.files.add(multipartFile);

      if (fields != null) {
        fields.forEach((key, value) {
          request.fields[key] = value;
        });
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }
}