import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/data/network/BaseApiServices.dart';
import 'package:anshinpet/data/network/NetworkApiService.dart';
import 'package:anshinpet/model/vaccine_model.dart';

class VaccineRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchVaccines() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.vaccineUrl);
    return response;
  }

  Future<Map<String, dynamic>> updateVaccine(VaccineModel data) async {
    final response = await _apiServices.putApiResponse(AppUrl.updateVaccine(data.id), data);
    return response;
  }

  Future<Map<String, dynamic>> createVaccine(Map<String, dynamic> data) async {
    final response = await _apiServices.getAuthPostApiResponse(AppUrl.vaccineUrl, data);
    return response;
  }

  Future<void> deleteVaccine(int id) async {
    await _apiServices.deleteApiResponse(AppUrl.deleteVaccine(id));
  }
}