import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/data/network/BaseApiServices.dart';
import 'package:anshinpet/data/network/NetworkApiService.dart';

class DonateRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchDonations(String type) async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.fetchDonate(type));
    return response;
  }
}
