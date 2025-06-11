import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/data/network/BaseApiServices.dart';
import 'package:anshinpet/data/network/NetworkApiService.dart';
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
}