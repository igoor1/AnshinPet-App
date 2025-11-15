import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';
import 'package:anshinpet/model/disease_model.dart';

class DiseaseRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchDiseases() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.diseaseUrl);
    return response;
  }

  Future<Map<String, dynamic>> updateDisease(DiseaseModel disease) async {
    final response = await _apiServices.putApiResponse(AppUrl.updateDisease(disease.id), disease);
    return response;
  }

  Future<Map<String, dynamic>> createDisease(Map<String, dynamic> data) async {
    final response = await _apiServices.getAuthPostApiResponse(AppUrl.diseaseUrl, data);
    return response;
  }

  Future<void> deleteDisease(int id) async {
    await _apiServices.deleteApiResponse(AppUrl.deleteDisease(id));
  }
}