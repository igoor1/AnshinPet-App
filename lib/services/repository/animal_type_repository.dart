import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';

class AnimalTypeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<dynamic>> fetchAllAnimalTypes() async {
    
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.fetchAnimalTypes);
    
    if (response is List) {
      return response;
    } else {
      return [];
    }
  }
}