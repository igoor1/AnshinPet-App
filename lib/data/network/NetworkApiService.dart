import 'package:anshinpet/data/app_exceptions.dart';
import 'package:anshinpet/data/network/BaseApiServices.dart';
import 'package:anshinpet/model/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:anshinpet/view_model/token_view_model.dart';

class NetworkApiService extends BaseApiServices {
  TokenViewModel tokenViewModel = TokenViewModel();

  @override
  Future getGetApiResponse(String url) async {
    
    dynamic responseJson;
    try{
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getAuthApiResponse(String url) async {
    
    dynamic responseJson;
    try{
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;
    
      final response = await http.get(
        Uri.parse(url),
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try{
      Response response = await post(
        Uri.parse(url),
        body:  jsonEncode(data),
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{
      throw FetchDataException('No internet Connection');
    }
    return responseJson;
  }


  @override
  Future<void> deleteApiResponse(String url) async {
    
    try{
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 204) {
      throw FetchDataException('Failed to delete resource. Status code: ${response.statusCode}');
      }
    } on SocketException {
    throw FetchDataException('No internet connection');
    }
  }

  dynamic returnResponse (http.Response response) {
    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchDataException('Error accourded while communicating with server'+
        'with status code' + response.statusCode.toString());
    }
  }
  
  @override
  Future<Map<String, dynamic>> getAuthPostApiResponse(String url, data) async {
        dynamic responseJson;
    try {
      TokenModel tokenModel = await tokenViewModel.getToken();
      String? token = tokenModel.token;

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

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

      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }
  
}