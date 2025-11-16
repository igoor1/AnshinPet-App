import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class DiseaseRepository {

  final BaseApiServices _api = NetworkApiService();

  Future<List<dynamic>> fetchDiseases() async {
    final response = await _api.getAuthApiResponse(AppUrl.diseaseUrl);
    return response;
  }

  Future<Map<String, dynamic>> createDisease(Map<String, dynamic> data) async {
    final response = await _api.getAuthPostApiResponse(
      AppUrl.diseaseUrl,
      data,
    );
    return response;
  }

  Future<Map<String, dynamic>> updateDisease(int id, Map<String, dynamic> data) async {
    final response = await _api.putApiResponse(
      "${AppUrl.diseaseUrl}/$id",
      data,
    );
    return response;
  }

  Future<void> deleteDisease(int id) async {
    await _api.deleteApiResponse("${AppUrl.diseaseUrl}/$id");
  }
}
