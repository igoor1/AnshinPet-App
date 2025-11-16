import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class AnimalStatusRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<dynamic>> fetchAllAnimalStatus() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.fetchAnimalStatus);
    
    if (response is List) {
      return response;
    } else {
      return [];
    }
  }
}