abstract class BaseApiServices {

  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);

  Future<dynamic> getAuthApiResponse(String url);

  Future<void> deleteApiResponse(String url);

  Future<Map<String, dynamic>> getAuthPostApiResponse(String url, dynamic data);

  Future<Map<String, dynamic>> putApiResponse(String url, dynamic data);
}