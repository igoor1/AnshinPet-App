import 'dart:io';

abstract class BaseApiServices {

  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getAuthApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getAuthPostApiResponse(String url, dynamic data);
  Future<dynamic> putApiResponse(String url, dynamic data);
  Future<dynamic> deleteApiResponse(String url);

  Future<dynamic> multipartRequestApiResponse(
    String method,
    String url, 
    File file,
    Map<String, String>? fields
  );
}