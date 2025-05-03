import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/data/network/BaseApiServices.dart';
import 'package:anshinpet/data/network/NetworkApiService.dart';

class HomeRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> quantityAnimals() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityAnimals);
    return response;
  }

  Future<dynamic> quantityDogs() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityDogs);
    return response;
  }

  Future<dynamic> quantityCats() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityCats);
    return response;
  }

   Future<dynamic> quantityBirds() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityBirds);
    return response;
  }
  
  Future<dynamic> quantityAdoption() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityAdoption);
    return response;
  }

  Future<dynamic> quantityUsers() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityUsers);
    return response;
  }

  Future<dynamic> quantityDonations() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityDonations);
    return response;
  }

  Future<dynamic> quantityMoney() async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.quantityMoney);
    return response;
  }
}
