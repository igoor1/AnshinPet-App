import 'package:anshinpet/configs/app_url.dart';
import 'package:anshinpet/services/network/BaseApiServices.dart';
import 'package:anshinpet/services/network/NetworkApiService.dart';
import 'package:anshinpet/model/donate_model.dart';

class DonateRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchDonations(String type) async {
    dynamic response = await _apiServices.getAuthApiResponse(AppUrl.fetchDonate(type));
    return response;
  }

  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> data) async {
    final response = await _apiServices.getAuthPostApiResponse(AppUrl.createDonation, data);
    return response;
  }

  Future<void> deleteDonation(int id) async {
    await _apiServices.deleteApiResponse(AppUrl.deleteDonation(id));
  }

  Future<Map<String, dynamic>> updateDonation(DonateModel donation) async {
    final data = donation.toJson();
    final response = await _apiServices.putApiResponse(AppUrl.updateDonation(donation.id!), data);
    return response;
  }
}
